#########################
# Pig Script to call from Apache Oozie
#########################
fs -rmr $input/pig_output
data = LOAD '$input/data.txt' USING

  PigStorage(',') as (id:int,name:chararray);

store data into '$input/pig_output' using PigStorage('\t');

fs -mkdir $input/$directoryName