# Apache-Oozie-workflow-with-Oozie-API
How to setup Apache Oozie workflow with Apache Oozie API


#POST Request:
curl -X POST -H "Content-Type: application/xml" -d @config.xml "http://localhost:11000/oozie/v1/jobs?action=start"

#Config.xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
   <property>
       <name>user.name</name>
       <value>sharad</value>
   </property>
   <property>
       <name>oozie.wf.application.path</name>
       <value>maprfs:///path/oozie/oozie_api_test</value>
   </property>
   <property>
       <name>queueName</name>
       <value>default</value>
   </property>
   <property>
       <name>nameNode</name>
       <value>maprfs:///</value>
   </property>
   <property>
       <name>jobTracker</name>
       <value>localhost:8032</value>
   </property>
   <property>
       <name>scriptName</name>
       <value>oozie_api.sh</value>
   </property>
   <property>
       <name>scriptPath</name>
       <value>/path/oozie/oozie_api_test</value>
   </property>
   <property>
       <name>directoryName</name>
       <value>oozie_test_dir</value>
   </property>
</configuration>



#Workflow.xml

<workflow-app xmlns="uri:oozie:workflow:0.4" name="shell-wf">
   <start to="shell-node"/>
   <action name="shell-node">
       <shell xmlns="uri:oozie:shell-action:0.2">
           <job-tracker>${jobTracker}</job-tracker>
           <name-node>${nameNode}</name-node>
           <configuration>
               <property>
                   <name>mapred.job.queue.name</name>
                   <value>${queueName}</value>
               </property>
           </configuration>
           <exec>${scriptName}</exec>
           <argument>${scriptPath}</argument>
           <argument>${directoryName}</argument>
           <file>maprfs://${scriptPath}/${scriptName}</file>
           <capture-output/>
       </shell>
       <ok to="end"/>
       <error to="fail"/>
   </action>
   <kill name="fail">
       <message>Shell action failed, error message[${wf:errorMessage(wf:lastErrorNode())}]</message>
   </kill>
   <kill name="fail-output">
       <message>Incorrect output</message>
   </kill>
   <end name="end"/>
</workflow-app>



# oozie_api_pig_test.pig

fs -rmr $input/pig_output
data = LOAD '$input/data.txt' USING

  PigStorage(',') as (id:int,name:chararray);

store data into '$input/pig_output' using PigStorage('\t');

fs -mkdir $input/$directoryName


#oozie_api.sh

_inputPath=$1

_directoryName=$2

pig -useHCatalog -Dmapreduce.job.queuename=default -f 'maprfs:///path/oozie_api_pig_test.pig' -param input=$_inputPath -param partnerDir=$_directoryName

