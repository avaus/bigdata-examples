# Install and run H2O on Avaus bigdata cluster

## Installation

Note! This should be packaged into a Chef cookbook...

These instructions follow roughly the official [Running H2O on Hadoop guide](http://docs.0xdata.com/deployment/hadoop_tutorial.html).

Preparations: set locale, install git and curl.

```bash
#!/bin/bash

# Set correct locale (based on http://www.google.com/url?q=http%3A%2F%2Faskubuntu.com%2Fquestions%2F162391%2Fhow-do-i-fix-my-locale-issue&sa=D&sntz=1&usg=AFQjCNHqArOU_XUHwtSKPwR5tKv4NdEr4w)
# sudo sh -c "echo -e 'LANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8' > /etc/default/locale"
sudo sh -c "echo 'LANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8' > /etc/default/locale"

# Install git
sudo apt-get -y install git-core

# Install curl
sudo apt-get -y install curl
```

Install more requirements: [node](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager), [bower](https://github.com/0xdata/h2o/tree/master/client) and [Scala SBT](http://www.scala-sbt.org/release/tutorial/Setup.html).

```bash
#!/bin/bash

# Install node: https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install -y nodejs

# Install bower: https://github.com/0xdata/h2o/tree/master/client
sudo npm install -g bower

# Install Scala SBT: http://www.scala-sbt.org/release/tutorial/Setup.html
wget https://dl.bintray.com/sbt/debian/sbt-0.13.6.deb
sudo dpkg -i sbt-0.13.6.deb
```

Install R packages: rjson, RCurl (requires bitops), statsmod

```bash
#!/bin/bash

# Install libcurl
sudo apt-get -y install libcurl4-openssl-dev

# Install R packages
wget http://cran.r-project.org/src/contrib/rjson_0.2.14.tar.gz
sudo R CMD INSTALL rjson_0.2.14.tar.gz

wget http://cran.r-project.org/src/contrib/bitops_1.0-6.tar.gz
sudo R CMD INSTALL bitops_1.0-6.tar.gz

wget http://cran.r-project.org/src/contrib/RCurl_1.95-4.3.tar.gz
sudo R CMD INSTALL RCurl_1.95-4.3.tar.gz

wget http://cran.r-project.org/src/contrib/statmod_1.4.20.tar.gz
sudo R CMD INSTALL statmod_1.4.20.tar.gz
```

Finally install H2O

```bash
#!/bin/bash

# Clone h2o from github
git clone https://github.com/0xdata/h2o.git

cd h2o
make

# If the above does not work, run these first
# cd h2o/client
# make setup build
# cd ..

# Copy and unzip h2o stuff to homefolder
unzip target/h2o-*.zip ../
# cp target/h2o-*.zip .
# cd ..
# unzip h2o-*.zip
```


## H2O Web UI

Start H2O server

```bash
#!/bin/bash

# Go through the folder unzipped above
cd h2o-*/

# Start H2O
java -Xmx2g -jar h2o.jar
```

To open the H2O UI in browser, go to address `http://192.168.60.2:54321/`. The address is of the form: `data-master-ip:port`, where data-master-ip is defined in the Vagrantfile and the port is something like 54321. 

## Run H2O on Hadoop

Need to first switch to hadoop user (with homefolder) by `sudo su - hadoop`.

```bash
#!/bin/bash

# Unzip necessary stuff from h2o
unzip /home/vagrant/h2o/target/h2o-*.zip .

# cp /home/vagrant/h2o/target/h2o-*.zip .
# unzip h2o-*.zip
cd h2o-*
cd hadoop

# Run example command
hadoop jar h2odriver_cdh4.jar water.hadoop.h2odriver -libjars ../h2o.jar -mapperXmx 1g -nodes 2 -output h20_test_output
```

## Run H2O with R

See [here](https://github.com/avaus/bigdata-examples/blob/master/R/R_H2O.md)
