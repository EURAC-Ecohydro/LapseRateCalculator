#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   fun_lapse_rate.R
# Description:  Calculate lapse rate
# Autor:        Christian Brida  
#               Institute for Alpine Environment
# Data:         26/07/2017
# Version:      1.0
#------------------------------------------------------------------------------------------------------------------------------------------------------

# Method 4: GEOtop formula https://github.com/geotopmodel/geotop/blob/master/src/geotop/meteo.cc

NULL

#' Saturated vapour pressure 
#' 
#' @param DATA_FOR_LAPSERATE data.frame of data from stations 
#' @param VARIABLE_FOR_LAPSERATE character of variable name which it is apply the lapse rate 
#' @param ELEVATION_VECTOR vector which contain the elevations of stations in the same order as in DATA_FOR_LAPSERATE
#'

fun_lapse_rate=function(DATA_FOR_LAPSERATE,ELEVATION_VECTOR){
  
  if((ncol(DATA_FOR_LAPSERATE)-1)!=length(ELEVATION_VECTOR)){
    stop("Error in the number of station or in elevation vector! The number of station should correspond to the number of elements of ELEVATION_VECTOR")
  }
  # --------------------------- 
  
  # number of station available for each time step
  n_station=apply(DATA_FOR_LAPSERATE,1,function(x) sum(!is.na(x))-1)
  
  # applies the linear fitting function lm() to the data
  # lapse rate as linear fit slope coefficient between variable (y axis) and elevation (x axis). 
  # Result is deg C for 1000 m
  lr=apply(DATA_FOR_LAPSERATE,1, function(x) 1000*lm(x[-1]~ELEVATION_VECTOR)$coefficients[2]) # lm(y~x)    y = x[,-1] ~~> value of dew point temperature; x = elevations of stations 
  
  # linear fit r squared 
  r2=apply(DATA_FOR_LAPSERATE,1, function(x) summary(lm(x[-1]~ELEVATION_VECTOR))$r.squared)
  
  OUTPUT_COMPLETE=data.frame(DATA_FOR_LAPSERATE[,1],n_station,lr,r2)
  colnames(OUTPUT_COMPLETE)=c("TIMESTAMP","n_stations", "lapse_rate", "r_squared")
  
  return(OUTPUT_COMPLETE)
}