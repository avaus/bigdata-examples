# Using R, RStudio and Shiny on Avaus bigdata cluster

## Run R

Simply type `R` on the command line.

## Use RStudio Server

Currently you need a unix username to log into RStudio. You can create this by connecting to the data-master.

```bash
#!/bin/bash

# Create user 'ruser' with homefolder
sudo useradd -m ruser
# Set password for 'ruser'
sudo passwd ruser
```

Access RStudio from the browser: `http://192.168.60.2:8787`

## Use Shiny Server

Instructions coming...

## More examples

* [Running H2O from R](https://github.com/avaus/bigdata-examples/blob/master/R/R_H2O.md)