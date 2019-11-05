_inputPath=$1

_directoryName=$2

pig -useHCatalog -Dmapreduce.job.queuename=default -f 'maprfs:///path/oozie_api_pig_test.pig' -param input=$_inputPath -param partnerDir=$_directoryName