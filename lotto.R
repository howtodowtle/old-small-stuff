##############################
##  Authors: A J Dautel
##  Datum: 18.05.2016
##  Projekt: Erwartungswert beim Lottospiel erhöhen
##  Script: lotto.R
##  Input Data: eigene Gewichtung schlechter Lottozahlen (hoher Wert = schlecht)
##############################


rm(list=ls())
getwd()

folder_wd = "~/lotto"
setwd(folder_wd)
getwd()

# install.packages("gridExtra")
iPak = function(pkg){
  # Function will install new packages and require already installed ones
  #
  # Args:
  #  pkg: A character string containing the packages to be used in the
  #       project.
  #
  # Returns:
  #  None, apart from the function calls for install.packages() and/or
  #  require(). 
  new.pkg = pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

# Install and Load Packages -----------------------------------------------

packages = c("gridExtra")
iPak(packages)


# Load data ---------------------------------------------------------------

data = read.csv("lottozahlen weights.csv", header = TRUE, sep = ";")
head(data)

# NB: Make sure that "lottozahlen weights.csv" is up to date!

# Drawing Probabilities ---------------------------------------------------

# weight numbers with the inverse of their "badness score"
weights_uncal = 1 / data$inv.weight

# now calibrate probabilities to achieve sum 1
weights_cal = weights_uncal / sum(weights_uncal)


# Draw numbers ------------------------------------------------------------

# obviously, no seed needed
# set.seed(4)

numbers_1  = sort(sample(1:49, 6, replace = FALSE, prob = weights_cal))
numbers_2  = sort(sample(1:49, 6, replace = FALSE, prob = weights_cal))
numbers_3  = sort(sample(1:49, 6, replace = FALSE, prob = weights_cal))
numbers_4  = sort(sample(1:49, 6, replace = FALSE, prob = weights_cal))
numbers_5  = sort(sample(1:49, 6, replace = FALSE, prob = weights_cal))
numbers_6  = sort(sample(1:49, 6, replace = FALSE, prob = weights_cal))
numbers_7  = sort(sample(1:49, 6, replace = FALSE, prob = weights_cal))
numbers_8  = sort(sample(1:49, 6, replace = FALSE, prob = weights_cal))
numbers_9  = sort(sample(1:49, 6, replace = FALSE, prob = weights_cal))
numbers_10 = sort(sample(1:49, 6, replace = FALSE, prob = weights_cal))
numbers_11 = sort(sample(1:49, 6, replace = FALSE, prob = weights_cal))
numbers_12 = sort(sample(1:49, 6, replace = FALSE, prob = weights_cal))


# Get previous numbers-----------------------------------------------------

numbers_old = read.csv("numbers.csv")


# Format new numbers accordingly ------------------------------------------


numbers_new = as.data.frame(rbind(numbers_1, numbers_2, numbers_3, numbers_4,
                                  numbers_5, numbers_6, numbers_7, numbers_8,
                                  numbers_9, numbers_10, numbers_11, numbers_12))

felder = c("numbers_1", "numbers_2", "numbers_3", "numbers_4", 
            "numbers_5", "numbers_6", "numbers_7", "numbers_8",
            "numbers_9", "numbers_10", "numbers_11", "numbers_12")

# System date & time (example: "Mi., 18.05.2016, 22:30:56 Uhr"), repeat 12 times
date = rep(format(Sys.time(), "%a., %d.%m.%Y, %X Uhr"), 12)

numbers_new = cbind(felder, numbers_new, date)
# now numbers_new has 8 variables: feld#, numbers 1-6, date & time

# colnames(numbers_old) = c("Feld", "Zahl 1", "Zahl 2", "Zahl 3", "Zahl 4",
#                           "Zahl 5", "Zahl 6", "Datum und Zeit")
# not needed anymore, but keep just in case

colnames(numbers_new) = colnames(numbers_old)

# Bind together and overwrite old numbers with old AND new numbers --------

numbers_all = rbind(numbers_old, numbers_new)

write.csv(numbers_all, "numbers.csv", row.names = FALSE)


pdf("latest_numbers.pdf", height = 11, width = 8.5)
grid.table(numbers_new)
dev.off()
