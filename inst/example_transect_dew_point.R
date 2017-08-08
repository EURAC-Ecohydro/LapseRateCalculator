#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   example_transect_dew_point.R
# TITLE:        Calculate lapse rate of Temperature and Dew Point
# Autor:        Christian Brida  
#               Institute for Alpine Environment
# Data:         25/07/2017
# Version:      1.0
#------------------------------------------------------------------------------------------------------------------------------------------------------

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Settings
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

require(zoo)

# ~~~~~~~~~~ Section 1 ~~~~~~~~~~ 

# --------- INPUT 1 --------- 

#- To set folder of cloned package -----------------------------------------------------------------------------------------------------------------
FOLDER="C:\\Users\\GBertoldi\\Documents\\Git\\EURAC-Ecohydro\\LapseRateCalculator/"

# --------------------------- 

#- To extract meteo files -----------------------------------------------------------------------------------------------------------------------------
FILES = dir(paste(FOLDER,"data/Input/",sep = ""))

#- To import external functions -------------------------------------------------------------------------------------------------------------
source(paste(FOLDER,"R/fun_read_all_stations.R",sep=""))
source(paste(FOLDER,"R/fun_dew_point.R",sep=""))

#- To Import elevation of stations. Remind to fill file elevation.csv ------------------------------------------------------------------------------------
elevation_df=read.csv(paste(FOLDER,"data/Support files/elevation.csv",sep=""),stringsAsFactors = F)
warning(paste("Have you properly filled the file ",FOLDER,"data/Support files/elevation.csv ? If YES, don't worry, if NO check and fill it!",sep = ""))

# ~~~~~~~~~~ Section 2 ~~~~~~~~~~ 

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Dew Point Calculator
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Select and import variables needed for dew point (To calculate only lapse rate you need only one variable)

# --------- INPUT 2 --------- 

#- Read data and extract variable AirT (Air Temperature) ----------------------------------------------------------------------------------------------
VARIABLE="T_Air"

# --------------------------- 

Air_T=fun_read_all_stations(VARIABLE = VARIABLE,FILES = FILES ,FOLDER = FOLDER)

# --------- INPUT 3 --------- 

#- Read data and extract variable RelHum (Relative Humidity) ------------------------------------------------------------------------------------------
VARIABLE="RH"

# --------------------------- 

Rel_Hum=fun_read_all_stations(VARIABLE = VARIABLE,FILES = FILES ,FOLDER = FOLDER)


#- Dew Point calculator -------------------------------------------------------------------------------------------------------------------------------
Dew_point_temperature=Tdew(TEMP = Air_T[,-1],RH = Rel_Hum[,-1],Z = elevation_df$elevation) # import should be without dates! (E.g. Air_T[,-1], ...)

Dew_point=data.frame(Air_T[,1],Dew_point_temperature)
colnames(Dew_point)[1]="TIMESTAMP"

# ~~~~~~~~~~ Section 3 ~~~~~~~~~~ 

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Lapse Rate Calculator
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# --------- INPUT 4 --------- 

DATA_FOR_LAPSERATE = Dew_point                    # <-- SELECT HERE THE DATASET TO USE FOR LAPSE RATE (with dates!)
VARIABLE_FOR_LAPSERATE = "Dew_point"              # <-- SELECT HERE THE NAME OF VARIABLE USED (e.g. Dew_point or T_Air or ...) (Usually copy under " " DATA_FOR_LAPSERATE )

# --------------------------- 

# number of station available for each time step
n_station=apply(DATA_FOR_LAPSERATE,1,function(x) sum(!is.na(x))-1)

# applies the linear fitting function lm() to the data
# lapse rate as linear fit slope coefficient between variable (y axis) and elevation (x axis). 
# Result is deg C for 1000 m
lr=apply(DATA_FOR_LAPSERATE,1, function(x) 1000*lm(x[-1]~elevation_df$elevation)$coefficients[2]) # lm(y~x)    y = x[,-1] ~~> value of dew point temperature; x = elevations of stations 

# linear fit r squared 
r2=apply(DATA_FOR_LAPSERATE,1, function(x) summary(lm(x[-1]~elevation_df$elevation))$r.squared)

OUTPUT_COMPLETE=data.frame(DATA_FOR_LAPSERATE[,1],n_station,lr,r2)
colnames(OUTPUT_COMPLETE)=c("TIMESTAMP","n_stations", "lapse_rate", "r_squared")

LAPSE_RATE=OUTPUT_COMPLETE[,c(1,3)]
colnames(LAPSE_RATE)[2]=paste(VARIABLE_FOR_LAPSERATE,"_lapse_rate",sep = "")                # <-- SELECT HERE THE NAME OF VARIABLE USED (e.g. T_dew_point or T_Air or ...)

# ~~~~~~~~~~ Section 4 ~~~~~~~~~~ 

#- Export lapse rate as VARIABLE_FOR_LAPSERATE.csv ------------------------------------------------------------------------------------

write.csv(OUTPUT_COMPLETE,paste(FOLDER,"data/Output/",VARIABLE_FOR_LAPSERATE,".csv",sep = ""),quote = F,row.names = F,na = "NA")

