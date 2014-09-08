# Run in projects/tutorials/python/

# Get python mapper and reducer
# Originally from http://www.michael-noll.com/tutorials/writing-an-hadoop-mapreduce-program-in-python/
wget https://dl.dropboxusercontent.com/u/792906/data/hadoop_stuff/mapper.py
wget https://dl.dropboxusercontent.com/u/792906/data/hadoop_stuff/reducer.py

# Clear output folder
hadoop fs -rm -r ./gutenberg_python_output

# Run MapReduce job using Hadoop streaming
# Note! Using -files instead of -file (deprecated)
hadoop jar /usr/local/hadoop-1/share/hadoop/tools/lib/hadoop-streaming-2.4.0.jar  \
-files ./mapper.py,./reducer.py -mapper ./mapper.py -reducer ./reducer.py \
-input ./gutenberg_data/* -output ./gutenberg_python_output

# hadoop jar /usr/local/hadoop-1/share/hadoop/tools/lib/hadoop-streaming-2.4.0.jar  \
# -file ./mapper.py    -mapper ./mapper.py \
# -file ./reducer.py   -reducer ./reducer.py \
# -input ./gutenberg_data/* -output ./gutenberg_python_output

# Get output back from HDFS (remove earlier output if exists)
rm -r gutenberg_python_output/
hadoop fs -get ./gutenberg_python_output

# Study output
less gutenberg_python_output/part-00000