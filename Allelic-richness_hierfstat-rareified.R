library(hierfstat)
library(adegenet)


rm(list=ls())
##Function for calculating standard error on all columns of a table.
colSe <- function (x, na.rm = TRUE) {
  if (na.rm) {
    n <- colSums(!is.na(x))
  } else {
    n <- nrow(x)
  }
  colVar <- colMeans(x*x, na.rm = na.rm) - (colMeans(x, na.rm = na.rm))^2
  return(sqrt(colVar/n))
}

##Modify as Needed
setwd("C:/R Folder")
data1<-read.genepop("populations.haps.gen")

##Rarefaction happens at the population and missing data level. So, rarefaction number is double (for diploid) the lowest number of individuals that have a locu across the entire data.
##For datasets with a large amount of missing data, or low samples in any given population, this rarefaction number (min.n in hierfstat) will be low.
##For melanoides, it was 6 because for at least once locus, only 3 individuals in any given population had a locus present.

data_fstat<-genind2hierfstat(data1)
data_fstat$pop
AR<-allelic.richness(data_fstat)##Used 4 because it was the lowest across all samples
AR_mean<-colMeans(AR$Ar,na.rm=TRUE)
AR_SE<-colSe(AR$Ar,na.rm=TRUE)
AR_mean
AR_SE

help(allelic.richness)
AR$min.all

