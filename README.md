Avaus big data examples
================

These examples allow you to test the [Avaus big data cluster](https://github.com/avaus/bigdata-cluster).

## Get data used in the examples

Get example data using the [script](data/get_example_data.sh). This includes

* text document data form Project Gutenberg
* iris data

## Hadoop examples

### Java

* Word count using precompiled code: [script](java/java_hadoop_wordcount_precompiled.sh)
* Word count using manually compiled code: [script](java/java_hadoop_wordcount_manual.sh)

### Python

* Word count using hadoop streaming and python scripts: [script](python/python_hadoop-streaming_wordcount.sh)

## H2O

* [Install and run H2O](/h2o/)

## R, RStudio and Shiny

* [Use R, RStudio and Shiny](/R/)
* [Running H2O from R](/R/R_H2O.md)
* [Trafi open car registry data analysis](/R/trafi_h2o.R). Note that this replicates an earlier analysis done with R+H2O without a server. The earlier analysis has a [more extensive documentation](https://github.com/avaus/opendata/blob/master/trafi.md), which is good to read through.

## Contribute examples?

You are welcome to contribute more examples! Simply make pull request!

## License

See the [license note](LICENSE)