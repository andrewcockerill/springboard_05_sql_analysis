# Packages
import numpy as np
import pandas as pd
import mysql.connector
from sqlalchemy import create_engine, text
import os
import logging
from dotenv import load_dotenv
import re

# Constants
load_dotenv()
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
HOST = os.getenv("HOST")
PORT = os.getenv("PORT")
DB_NAME = "euro_cup_2016"
INIT_CONNECT_STR = f"mysql+mysqlconnector://{DB_USER}:{DB_PASSWORD}@{HOST}:{PORT}"
DB_CONNECT_STR = INIT_CONNECT_STR+f"/{DB_NAME}"
FLAT_FILE_LOC = "../data/"
FLAT_FILES = os.listdir(FLAT_FILE_LOC)
FLAT_FILES_PK = [i for i in FLAT_FILES
                 if bool(re.search("mast.csv$|penalty_shootout|goal_details|^soccer", i))]
DATE_FIELDS = {'player_mast': 'dt_of_bir', 'match_mast': 'play_date'}

# Logging
logger = logging.getLogger('db_setup')
logger.setLevel(logging.INFO)
formatter = logging.Formatter(
    '%(asctime)s - %(name)s - %(levelname)s - %(message)s')
fh = logging.FileHandler('../logs/db_setup.log')
fh.setFormatter(formatter)
logger.addHandler(fh)
logger.info('application started')


# Setup Database
try:
    engine = create_engine(INIT_CONNECT_STR)

    with engine.connect() as conn:
        conn.execute(text(f"DROP DATABASE IF EXISTS {DB_NAME}"))
        conn.execute(text(f"CREATE DATABASE {DB_NAME}"))
        logger.info('database created')

    engine.dispose()
except Exception as e:
    logger.error(e)
    logger.error('database setup failed unexpectedly')

# Setup tables and objects
try:
    engine = create_engine(DB_CONNECT_STR)

    for file in FLAT_FILES:
        logger.info(f'attempting ingestion of {file}')
        file_loc = os.path.join(FLAT_FILE_LOC, file)
        context_df = pd.read_csv(file_loc)
        table_name = re.sub(r"\.csv$", "", file)

        # Cast date columns
        if table_name in DATE_FIELDS.keys():
            context_df.loc[:, DATE_FIELDS[table_name]] = pd.to_datetime(
                context_df[DATE_FIELDS[table_name]]).dt.date

        # Create table
        context_df.to_sql(table_name, con=engine,
                          if_exists='fail', index=False)

        # Setup primary keys where applicable
        if file in FLAT_FILES_PK:
            with engine.connect() as con:
                pk_col = context_df.columns[0]
                con.execute(
                    text(f'ALTER TABLE {table_name} ADD PRIMARY KEY (`{pk_col}`)'))

        # Add data types to logs for review
        table_info = pd.read_sql(
            f"SHOW FIELDS FROM {DB_NAME}.{table_name}", engine).to_string().replace('\n', '\n\t')
        logger.info(
            f'ingested {table_name} with following data types: \n'+'\t' + table_info)

    engine.dispose()
except Exception as e:
    logger.error(e)
    logger.error('table creation failed unexpectedly')
finally:
    logger.info('application ended')
