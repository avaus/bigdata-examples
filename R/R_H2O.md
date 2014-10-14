# Run H2O from R

## Install H2O R package

Note! This requires you have installed H2O as instructed [here](/../h2o/)!

Run on homefolder:

```bash
#!/bin/bash

# Unzip h2o stuff
unzip h2o/target/h2o-*.zip .
#cp h2o/target/h2o-*.zip 
#cd ..
#unzip h2o-*.zip
# Install R package

sudo R CMD INSTALL h2o-*/R/h2o_*.tar.gz
```
