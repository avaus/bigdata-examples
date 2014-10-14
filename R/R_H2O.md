# Run H2O from R

# This works!
cp target/h2o-*.zip ../
cd ..
unzip h2o-*.zip
sudo R CMD INSTALL h2o-*/R/h2o_*.tar.gz