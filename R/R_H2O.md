# Run H2O from R

For general instructions for using R and RStudio, see [here](https://github.com/avaus/bigdata-examples/tree/master/R).

## Install H2O R package

Note! This requires you have installed H2O as instructed [here](https://github.com/avaus/bigdata-examples/tree/master/h2o)!

Run on data-master homefolder:

```bash
#!/bin/bash

# Unzip h2o stuff
unzip h2o/target/h2o-*.zip -d .

# Install R package
sudo R CMD INSTALL h2o-*/R/h2o_*.tar.gz
```

## Run H2O with R

### Initiating H2O

Load package
```r
library("h2o")
```

Start H2O. This will automatically initiate H2O in the background. 
```r
H2Oserver <- h2o.init()
```

Alternatively you can connect to already running H2O.
```r
H2Oserver <- h2o.init(ip = "192.168.60.2", port = 54321, startH2O = FALSE)
```

### Loading data

From the web
```r
iris.hex <- h2o.importFile(H2Oserver, path="https://dataminingproject.googlecode.com/svn/DataMiningApp/datasets/Iris/iris.csv", parse=TRUE, header=TRUE, sep="\t")
```

From local file
```r
iris.hex <- h2o.importFile(H2Oserver, path="/home/hadoop/example_data/iris.csv", parse=TRUE, header=TRUE, sep="\t")
```

From HDFS
```r
iris.hex <- h2o.importFile(H2Oserver, path="hdfs://data-master:54310/user/ubuntu/VR_customers.txt", parse=TRUE, header=TRUE, sep="\t")
```


### Data analysis

Some example commands with the iris data

```r
# Apply simple sum
x <- h2o::apply(iris.hex[,1:4], 2, sum)

# Run RandomForestq
rf.res <- h2o.randomForest(x=1:4, y=5, data=iris.hex, key="rf.res", classification=TRUE, importance=TRUE, type="BigData", verbose=TRUE)
```

### More examples

* [Trafi open car registry data analysis](trafi_h2o.R)
* Airlines?
