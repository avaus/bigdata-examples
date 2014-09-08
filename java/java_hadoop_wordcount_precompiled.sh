# Java Hadoop word count example using the precompiled jar file
# Run this script on the data-master as the 'hadoop' user

# Clear output directory if exists
hadoop fs -rm -r ./gutenberg_java_output

# Run built-in in word count jar
hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.4.0.jar wordcount ./gutenberg_data ./gutenberg_java_output

# Get output back from HDFS (remove earlier output if exists)
rm -r gutenberg_java_output/
hadoop fs -get ./gutenberg_java_output

# Study output
less gutenberg_java_output/part-r-00000

