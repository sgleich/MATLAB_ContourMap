### Convert .nc file to an x, y, z data frame - pre-processing needed to create a contour plot ###
### By: Samantha Gleich ###
### Last Updated: June 16, 2022 ###

### Packages ###
# install.packages('raster')
library(raster) 

### Load .nc file ###
nc <- brick("chla_june42022.nc")
dim(nc)

### Make x,y,z data frame ###
nc.df <- as.data.frame(nc[[1]], xy=T)
colnames(nc.df) <- c("x","y","chl")
head(nc.df)

### Save x,y,z dataframe as csv for downstream work in MATLAB ###
write.csv(nc.df, "chla_june42022.csv")
