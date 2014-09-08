# Run this script on the data-master

# # Create home folder for hadoop and switch user
# sudo mkdir /home/hadoop
# sudo chmod 775 /home/hadoop
# sudo chgrp hadoop /home/hadoop
sudo su - hadoop

# Check what's in HDFS
hadoop fs -ls

# Should give an error: 'ls: `.': No such file or directory'
# So let's create a home folder in HDFS
hadoop fs -mkdir /user/hadoop

# Download data from Project Gutenberg, http://www.gutenberg.org/

# Create folder for the data
mkdir gutenberg_data

# Originally downloaded from, using Dropbox as can not access gutenberg from hosted server
# http://www.gutenberg.org/cache/epub/20417/pg20417.txt
# http://www.gutenberg.org/cache/epub/5000/pg5000.txt
# http://www.gutenberg.org/cache/epub/4300/pg4300.txt
wget -P gutenberg_data/ https://dl.dropboxusercontent.com/u/792906/data/gutenberg_data/pg20417.txt
wget -P gutenberg_data/ https://dl.dropboxusercontent.com/u/792906/data/gutenberg_data/pg5000.txt
wget -P gutenberg_data/ https://dl.dropboxusercontent.com/u/792906/data/gutenberg_data/pg4300.txt

# Copy data to HDFS
hadoop fs -put gutenberg_data

# Check that it is there and that the content is correct
hadoop fs -ls 
hadoop fs -ls gutenberg_data
