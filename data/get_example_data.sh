# Run this script on the data-master as the 'hadoop' user

# Check what's in HDFS
hadoop fs -ls

# If this gives an error: 'ls: `.': No such file or directory',
# we need to create a home folder in HDFS
hadoop fs -mkdir /user/hadoop

# If you want to clear everything on HDFS, run the following
# hadoop fs -rm -r *

# Create folder for the data
mkdir example_data

# Get Gutenber text data
# Originally downloaded from Project Gutenberg, http://www.gutenberg.org/
# http://www.gutenberg.org/ebooks/20417
# http://www.gutenberg.org/ebooks/5000
# http://www.gutenberg.org/ebooks/4300
# As gutenberg.org does not allow access from hosted servers, we'll download the data from github
wget -P example_data/ https://raw.githubusercontent.com/avaus/bigdata-examples/master/data/pg20417.txt
wget -P example_data/ https://raw.githubusercontent.com/avaus/bigdata-examples/master/data/pg5000.txt
wget -P example_data/ https://raw.githubusercontent.com/avaus/bigdata-examples/master/data/pg4300.txt

# Get iris data
wget -P example_data/ https://dataminingproject.googlecode.com/svn/DataMiningApp/datasets/Iris/iris.csv

# Copy data to HDFS
hadoop fs -put example_data

# Check that it is there and that the content is correct
hadoop fs -ls example_data

