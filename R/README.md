# Using R, RStudio and Shiny on Avaus bigdata cluster

## Run R

Simply type `R` on the command line. However, we recommend using RStudio as instructed below.

## Use RStudio Server

Currently you need a unix username with a password to log into RStudio. You can create this in the data-master as follows.

```bash
#!/bin/bash

# Create user 'ruser' with homefolder
sudo useradd -m ruser
# Set password for 'ruser'
sudo passwd ruser
```

Access RStudio from the browser at [http://192.168.60.2:8787](http://192.168.60.2:8787).

## Use Shiny Server

Instructions coming...

## More examples

* [Running H2O from R](https://github.com/avaus/bigdata-examples/blob/master/R/R_H2O.md)