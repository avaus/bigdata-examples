# Run this script on the data-master as the 'hadoop' user

# Check what's in HDFS
hadoop fs -ls

# If this gives an error: 'ls: `.': No such file or directory',
# we need to create a home folder in HDFS
hadoop fs -mkdir /user/hadoop

# If you want to clear everything on HDFS, run the following
# hadoop fs -rm -r *

# Create folder for the data
mkdir gutenberg_data

# Originally downloaded from Project Gutenberg, http://www.gutenberg.org/
# http://www.gutenberg.org/ebooks/20417
# http://www.gutenberg.org/ebooks/5000
# http://www.gutenberg.org/ebooks/4300
# As gutenberg.org does not allow access from hosted servers, we'll download the data from github
wget -P gutenberg_data/ https://raw.githubusercontent.com/avaus/bigdata-examples/master/gutenberg_data/pg20417.txt
wget -P gutenberg_data/ https://raw.githubusercontent.com/avaus/bigdata-examples/master/gutenberg_data/pg5000.txt
wget -P gutenberg_data/ https://raw.githubusercontent.com/avaus/bigdata-examples/master/gutenberg_data/pg4300.txt

# Copy data to HDFS
hadoop fs -put gutenberg_data

# Check that it is there and that the content is correct
hadoop fs -ls gutenberg_data
