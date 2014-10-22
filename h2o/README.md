# Install and run H2O on Avaus bigdata cluster

## Installation

Note! This should be packaged into a Chef cookbook...

These instructions follow roughly the official [Running H2O on Hadoop guide](http://docs.0xdata.com/deployment/hadoop_tutorial.html).

Preparations: set locale, install git, curl, [Scala SBT](http://www.scala-sbt.org/release/tutorial/Setup.html) and Python Sphinx.

```bash
#!/bin/bash

# Set correct locale (based on http://www.google.com/url?q=http%3A%2F%2Faskubuntu.com%2Fquestions%2F162391%2Fhow-do-i-fix-my-locale-issue&sa=D&sntz=1&usg=AFQjCNHqArOU_XUHwtSKPwR5tKv4NdEr4w)
# sudo sh -c "echo -e 'LANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8' > /etc/default/locale"
sudo sh -c "echo 'LANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8' > /etc/default/locale"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Install git
sudo apt-get -y install git-core

# Install curl
sudo apt-get -y install curl

# Install Scala SBT: http://www.scala-sbt.org/release/tutorial/Setup.html
wget https://dl.bintray.com/sbt/debian/sbt-0.13.6.deb
sudo dpkg -i sbt-0.13.6.deb

# Install python sphinx
sudo apt-get install -y python-sphinx
```

Install more requirements for the UI: [node](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager) and [bower](https://github.com/0xdata/h2o/tree/master/client).

```bash
#!/bin/bash

# Install node: https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install -y nodejs

# Seems that this needs to be done after all
sudo npm install -g bower
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

Finally install H2O. Installing the UI requires bower, but the installation with `make setup build` fails due to permission errors. So here it is first run with `sudo make setup build`, which fails at some point with a note that you should not install it with sudo. After that `make setup build` however completes. This works for now but should be fixed somehow!

```bash
#!/bin/bash

# Clone h2o from github
git clone https://github.com/0xdata/h2o.git

# Install UI first!
cd h2o/client
sudo make setup build
# This will fail, but after that running make again without sudo works!
make setup build

# Install
cd ..
make

# Finally you need to unzip h2o stuff to be able run it
unzip target/h2o-*.zip -d ../
```


## H2O Web UI

Start H2O server

```bash
#!/bin/bash

# Go through the folder unzipped above
# cd h2o-*/

# Start H2O
java -Xmx2g -jar h2o-*/h2o.jar
```

To open the H2O UI in browser, go to address [http://192.168.60.2:54321/](http://192.168.60.2:54321/). The address is of the form: `data-master-ip:port`, where data-master-ip is defined in the Vagrantfile and the port is something like 54321 (see what's printed in the console!).

## Run H2O on Hadoop

Need to first switch to hadoop user (with homefolder) by `sudo su - hadoop`.

```bash
#!/bin/bash

# Unzip necessary stuff from h2o
unzip /home/vagrant/h2o/target/h2o-*.zip

cd h2o-*/hadoop
# cd hadoop

# Run example command
hadoop jar h2odriver_cdh4.jar water.hadoop.h2odriver -libjars ../h2o.jar -mapperXmx 1g -nodes 2 -output h20_test_output
```

## Run H2O with R

See [here](https://github.com/avaus/bigdata-examples/blob/master/R/R_H2O.md)
