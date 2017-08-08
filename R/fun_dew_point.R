#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   fun_dew_point.R
# Description:  Calculate dew point from RH an T_Air
# Autor:        Christian Brida  
#               Institute for Alpine Environment
# Data:         26/07/2017
# Version:      1.0
#------------------------------------------------------------------------------------------------------------------------------------------------------

# Method 4: GEOtop formula https://github.com/geotopmodel/geotop/blob/master/src/geotop/meteo.cc

NULL

#' Saturated vapour pressure 
#' 
#' @param TEMP Air Temperature 
#' @param P Air pressure  
#'

SatVapPressure=function(TEMP, P){
  A=6.1121*(1.0007+P*3.46e-6)
  b=17.502
  c=240.97
  e=A*exp((b*TEMP)/(c+TEMP))
  return(e)
}

NULL

#' Temperature from saturated water vapour
#' 
#' @param SVP Saturated vapour pressure
#' @param P Air pressure  
#'

TfromSatVapPressure=function(SVP,P){
  A=6.1121*(1.0007+P*3.46e-6)
  b=17.502
  c=240.97
  temp_dew=c*log(SVP/A)/(b-log(SVP/A))
  return (temp_dew)
}

NULL

#' Air pressure 
#' 
#' @param Z elevation  
#'

pressure=function(Z){
  scael_ht=8500
  press=1013*exp(-Z/scael_ht)
  return(press)
}

NULL

#' Temperature from saturated water vapour
#' 
#' @param e Saturated vapour pressure
#' @param P Air pressure  
#'

TfromSatVapPressure=function(e,P){
  A=6.1121*(1.0007+P*3.46e-6)
  b=17.502
  c=240.97
  temp_dew=c*log(e/A)/(b-log(e/A))
  return (temp_dew)
}

NULL

#' Dew Point Temperature 
#' 
#' @param TEMP Air temperature
#' @param RH Relative Humidity
#' @param Z elevation 
#'

Tdew=function(TEMP, RH,Z){
  P=pressure(Z)
  e=SatVapPressure(TEMP,P)
  RH[RH>100]=100
  RH[RH<0]=0
  dew=TfromSatVapPressure(e*RH/100,P)
  return(dew)
}


