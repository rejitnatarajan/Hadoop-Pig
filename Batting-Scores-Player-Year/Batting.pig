--load statement

batting = load 'Batting.csv' using PigStorage(',');

--

runs = FOREACH batting GENERATE $0 as playerID, $1 as year, $8 as runs;
grp_data = GROUP runs by (year);


-- find the maximum runs by batsmen

max_runs = FOREACH grp_data GENERATE group as grp,MAX(runs.runs) as max_runs;


-- perform JOIN operation

join_max_run = JOIN max_runs by ($0, max_runs), runs by (year,runs);  
join_data = FOREACH join_max_run GENERATE $0 as year, $2 as playerID, $1 as runs;  

--dump data

dump join_data;

-- export to csv

store join_data into '/path/to/output/' using org.apache.pig.piggybank.storage.CSVExcelStorage();

