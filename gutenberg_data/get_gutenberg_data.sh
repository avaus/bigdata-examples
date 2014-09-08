# Run this script on the data-master

# # Create home folder for hadoop and switch user
# sudo mkdir /home/hadoop
# sudo chmod 775 /home/hadoop
# sudo chgrp hadoop /home/hadoop
# sudo su - hadoop

# Check what's in HDFS
hadoop fs -ls

# If this gives an error: 'ls: `.': No such file or directory',
# we need to create a home folder in HDFS
hadoop fs -mkdir /user/hadoop

# Download data from Project Gutenberg, http://www.gutenberg.org/

# Create folder for the data
mkdir gutenberg_data

# Originally downloaded from, using Dropbox as can not access gutenberg from hosted server
# http://www.gutenberg.org/ebooks/20417
# http://www.gutenberg.org/ebooks/5000
# http://www.gutenberg.org/ebooks/4300
wget -P gutenberg_data/ https://raw.githubusercontent.com/avaus/bigdata-examples/master/gutenberg_data/pg20417.txt
wget -P gutenberg_data/ https://raw.githubusercontent.com/avaus/bigdata-examples/master/gutenberg_data/pg5000.txt
wget -P gutenberg_data/ https://raw.githubusercontent.com/avaus/bigdata-examples/master/gutenberg_data/pg4300.txt

# Copy data to HDFS
hadoop fs -put gutenberg_data

# Check that it is there and that the content is correct
hadoop fs -ls 
hadoop fs -ls gutenberg_data
