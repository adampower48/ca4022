# Assignment 1: Pig & Hive
## Scripts
Pig/Hive scripts should not be ran directly, use associated Bash scripts instead. All scripts should be ran from the [assignment1](.) directory.

- [data_cleaning.pig](data_cleaning.pig): Pig shell script containing all initial data cleaning/processing.
- [pig_data_cleaning.sh](pig_data_cleaning.sh): Bash script responsible for setup/teardown for above Pig script.
- [analysis.pig](analysis.pig): Pig shell script containing all analysis done in Pig.
- [pig_analysis.sh](pig_analysis.sh): Bash script responsible for setup/teardown for above Pig script.
- [hive_analysis.sql](hive_analysis.sql): HiveSQL script containing all analysis done in Hive.
- [hive_analysis.sh](hive_analysis.sh): Bash script responsible for setup/teardown for above HiveSQL script.  
- [csv_helpers.sh](csv_helpers.sh): Bash helper functions for combining output data into csv files.
- [download_movielens.sh](download_movielens.sh): Bash script to download/extract MovieLens dataset.
- [plots.py](plots.py): Python script to visualise data from Hive analysis.