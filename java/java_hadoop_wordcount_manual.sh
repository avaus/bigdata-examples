# Java Hadoop word count example using manually compiled java code
# Run this script on the data-master as the 'hadoop' user

# Get java mapper and reducer files from github
# Originally from http://codesfusion.blogspot.fi/2013/10/hadoop-wordcount-with-new-map-reduce-api.html
wget https://raw.githubusercontent.com/avaus/bigdata-examples/master/java/WordMapper.java
wget https://raw.githubusercontent.com/avaus/bigdata-examples/master/java/WordCount.java
wget https://raw.githubusercontent.com/avaus/bigdata-examples/master/java/SumReducer.java

# Create folder for the .class files
mkdir wordcount_classes

# Compile using `hadoop classpath`
javac -classpath `hadoop classpath` -d wordcount_classes WordCount.java WordMapper.java SumReducer.java

# Package into a jar file
jar -cvf WordCount.jar -C wordcount_classes .

# Clear output directory if exists
hadoop fs -rm -r ./gutenberg_java_manual_output

# Run with gutenberg data
hadoop jar WordCount.jar WordCount ./gutenberg_data ./gutenberg_java_manual_output

# Get output back from HDFS (remove earlier output if exists)
rm -r gutenberg_java_manual_output/
hadoop fs -get ./gutenberg_java_manual_output

# Study output
less gutenberg_java_manual_output/part-r-00000
