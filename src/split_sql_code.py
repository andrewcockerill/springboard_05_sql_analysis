# Packages
import os

# Constants
FILENAMES = [f"sql_q0{i}_sol.sql" if i <
             10 else f"sql_q{i}_sol.sql" for i in range(1, 21)]
MAIN_SQL_FILE = "query_exercises_all.sql"

# Perform splittling
with open(MAIN_SQL_FILE, "r") as f:
    sql_codes = ["--" + s for s in f.read().split("--")[1:]]

for code, fn in zip(sql_codes, FILENAMES):
    with open(fn, "w") as f:
        f.write(code)
