# Trafi H2O analysis coming

## Setup ########

# Load and initialize h2o
library("h2o")
H2Oserver <- h2o.init()

# Load other necessary packages
library("ggplot2")
library("reshape2")
library("plyr")
# install.packages("gdata")
library("gdata")

## Load data into h2o ########

# The data is available here: http://www.trafi.fi/tietopalvelut/avoin_data
# Download an unzip
download.file("http://wwwtrafifi.97.fi/opendata/Avoindata-20140915.zip", destfile="Avoindata-20140915.zip")
unzip("Avoindata-20140915.zip")

# Load data as a H2OParsedData object
trafi.original.hex <- h2o.importFile(H2Oserver, path="Avoindata_9.csv", parse=TRUE, header=TRUE, sep=",")

# Let's see what the imported H2OParsedData object looks like
str(trafi.original.hex)

# Read annotations too
download.file(url = "http://www.trafi.fi/filebank/a/1402650899/782fd1d67f9f64628ae4e330c6a88b6a/14931-Koodisto.xlsx",
              destfile = "14931-Koodisto.xlsx")
trafi.codes <- read.xls("14931-Koodisto.xlsx")

## Process data #########

# Take first a subset of passenger cars only
trafi.hex <- trafi.original.hex[trafi.original.hex$ajoneuvoluokka=="M1", ]

# Choose a subset of the variables and translate to English
trafi.hex <- trafi.hex[,c(2,5,6,7,10,11,14,15,16,17,18,19,20,21,22,31)]
names(trafi.hex) <- c("Registering_date", "Starting_date", "Colour", "Door_amount", 
                      "Seat_amount", "Weight", "Length", "Width", 
                      "Height", "Energy_source", "Cylinder_capacity", "Net_power",
                      "Cylinder_amount", "Compressor", "Manufacturer", "CO2")

# Change these to factors
trafi.hex$Colour <- as.factor(trafi.hex$Colour)
trafi.hex$Energy_source <- as.factor(trafi.hex$Energy_source)

# Registering date is give in milliseconds
# Convert that to a year with h2o.year()
trafi.hex$Registering_year <- h2o.year(trafi.hex$Registering_date) + 1900

# Start of usage date is given in year month date without separators
# Convert to year simply by diving by 10000 and taking floor
trafi.hex$Starting_year <- floor(trafi.hex$Starting_date/10000)

# Remove original date columms
trafi.hex <- trafi.hex[,-c(1,2)]


## Explore data #######

# Summarise the data
summary(trafi.hex)

# The Min. and Max. value reveal some outliers, let's filter those out
# Note! Cutoffs chosen very arbitrarily now, can be improved later
trafi.clean.hex <- trafi.hex[trafi.hex$Door_amount < 10 & 
                               trafi.hex$Seat_amount < 50 & 
                               trafi.hex$Weight < 100000 & 
                               trafi.hex$Length < 10000 &
                               trafi.hex$Width < 20000 &
                               trafi.hex$Height < 20000 &
                               trafi.hex$Net_power < 1000 &
                               trafi.hex$Cylinder_amount < 10 &
                               trafi.hex$CO2 > 0, ]

# Take only the most common manufacturers
# Note! There are a lot of messy manufacturer names, which should be cleaned.
man.table <- as.data.frame(h2o.table(trafi.clean.hex$Manufacturer))
man.tokeep <- as.character(man.table$row.names[man.table$Count > 10000])
# Remove Volkswagen VW manually, need to fix this later
man.tokeep <- man.tokeep[man.tokeep!="Volkswagen VW"]

# H2O does not support match or %in%, so we'll need a trick to take a subset based on a group of factor values
subset.expression <- paste("trafi.clean.hex$Manufacturer == man.tokeep[",1:length(man.tokeep),"]",
                           sep="", collapse=" | ")
trafi.clean.hex <- eval(parse(text=paste0("trafi.clean.hex[", subset.expression,",]")))

# Repeat the same for the energy sources (represented by the numerical codes still)
en.table <- as.data.frame(h2o.table(trafi.clean.hex$Energy_source))
en.tokeep <- as.character(en.table$row.names[en.table$Count > 100])
subset.expression <- paste("trafi.clean.hex$Energy_source == en.tokeep[",1:length(en.tokeep),"]",
                           sep="", collapse=" | ")
trafi.clean.hex <- eval(parse(text=paste0("trafi.clean.hex[", subset.expression,",]")))

##  Visualize relationships between variables ########

# Study distribution of the Weight variable
quantile(trafi.clean.hex$Weight, na.rm=TRUE)

# Group weight into discrete variables
trafi.clean.hex$Weight.cut <- h2o.cut(trafi.clean.hex$Weight, quantile(trafi.clean.hex$Weight, na.rm=TRUE))

# Now we can use cross tables to compare variables, e.g. weights and years
wy.table <- h2o.table(trafi.clean.hex[c("Registering_year", "Weight.cut")])

# This table we can pull into R for plotting using as.data.frame()
wy.df <- as.data.frame(wy.table)
names(wy.df) <- c("Registering_year", "0-1182", "1182-1350", "1350-1520", "1520-")
# Transform into a more convenient form
wy.df <- reshape2::melt(wy.df, id.var="Registering_year")
names(wy.df)[2] <- "Weight_group"
# Compute proportion of different Weight groups per year
wy.df <- plyr::ddply(wy.df, "Registering_year", transform, Proportion=value/sum(value))
# Plot
ggplot(wy.df, aes(x=Registering_year, y=Weight_group)) + geom_tile(aes(fill=Proportion)) + 
  theme(legend.position="bottom") +
  labs(x="Registering year", y="Weight (kg)", fill="Percentage of cars per year") + 
  guides(fill=guide_legend(label.position="bottom", keywidth=2, keyheight=2))

## Quantify relationships between variables ########

# Center numerical variables to start from zero
trafi.clean.hex$Year_n <- trafi.clean.hex$Registering_year - mean(trafi.clean.hex$Registering_year, na.rm=TRUE)
trafi.clean.hex$Weight_n <- trafi.clean.hex$Weight - mean(trafi.clean.hex$Weight, na.rm=TRUE)
# Run linear regression
trafi.glm <- h2o.glm(y="CO2", x=c("Year_n", "Weight_n", "Energy_source", "Compressor", "Manufacturer"),
                     data=trafi.clean.hex, family="gaussian", alpha=0.5, variable_importances=TRUE, 
                     use_all_factor_levels=TRUE, standardize=FALSE)

# Separate coefficients for manufactures, energy sources, and other factors
coefs <- trafi.glm@model$coefficients
coefs.manufactures <- sort(coefs[grep("Manufacturer", names(coefs))], decreasing = TRUE)
coefs.energysource <- sort(coefs[grep("Energy_source", names(coefs))], decreasing = TRUE)
coefs.other <- coefs[!(names(coefs) %in% c(names(coefs.manufactures), names(coefs.energysource)))]
names(coefs.manufactures) <- gsub("Manufacturer.", "", names(coefs.manufactures))

# Translate energy source codes appearing in the model to understandable ones
# Note! This is not needed when we figure out how to fix the levels already in H2O
energysource.codes <- droplevels(subset(trafi.codes, KOODISTONKUVAUS=="Polttoaine" & KIELI=="en"))
energysource.codes$KOODINTUNNUS <- as.numeric(as.character(energysource.codes$KOODINTUNNUS))
es.codes.num <- as.numeric(gsub("Energy_source.", "", names(coefs.energysource)))
names(coefs.energysource) <- as.character(energysource.codes$LYHYTSELITE[match(es.codes.num, energysource.codes$KOODINTUNNUS)])

# Plot the  the effect of force types
en.df <- data.frame(Energy_source=factor(names(coefs.energysource), levels=names(coefs.energysource)),
                    Coefficient=coefs.energysource)
ggplot(en.df, aes(x=Energy_source, y=Coefficient)) + geom_bar(stat="identity") + coord_flip() + 
  labs(y="CO2 coefficient (g/km)", x="Energy source")

# Plot the  the effect of force types
man.df <- data.frame(Manufacturer=factor(names(coefs.manufactures), levels=names(coefs.manufactures)),
                     Coefficient=coefs.manufactures)
ggplot(man.df, aes(x=Manufacturer, y=Coefficient)) + geom_bar(stat="identity") + coord_flip() + 
  labs(y="CO2 coefficient (g/km)")

# Let's also check the remaining factors that were included in the regression.
coefs.other


## Shut down H2O ##############

h2o.shutdown(H2Oserver)
