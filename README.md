### SQL Analysis Mini-Project

#### Overview
This repository contains the code used in a small project meant as an exercise in data ingestion and SQL programming. Here, multiple flat <tt>.csv</tt> files are ingested into a MySQL database. These files pertain to individual tables that contain data related to a soccer tournament. The exercise includes 20 analytics questions that can be answered by performing joins, aggregations, regular expressions, and windowing functions.

### Project Structure
The project includes the following folders:

- <tt>src</tt>: Contains Python scripts for data ingestion as well as all SQL logic for answering analytics prompts
- <tt>docs</tt>: Documentation files including relational schema and data dictionary
- <tt>data</tt>: Flat files for ingestion
- <tt>logs</tt>: Logs for ingestion process
- <tt>notebooks</tt>: Contains analytic notebook that displays sampling of datasets obtained by running each query

The database can be created by running <tt>src/db_setup.py</tt>. Each solution is written in as <tt>src/sql_q{n}_sol.sql</tt>, where <tt>n</tt> is the question number. <tt>src/query_exercises_all.sql</tt> is a combined SQL script containing all proposed solutions.
