#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   example_transect_dew_point.R
# TITLE:        Calculate lapse rate of Temperature and Dew Point
# Autor:        Christian Brida  
#               Institute for Alpine Environment
# Data:         25/07/2017
# Version:      1.0
#------------------------------------------------------------------------------------------------------------------------------------------------------


if(!require("zoo")){
  install.packages(zoo)
  require("zoo")
}

# ~~~~~~~~~~ Section 1 ~~~~~~~~~~ 

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Import informations and functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ========= INPUT 1-3 ========= 

git_folder = getwd()
# git_folder="C://Users/CBrida/Desktop/Git/Upload/LapseRateCalculator/"

ELEVATION_PATH=paste(git_folder,"/data/Support files/elevation.csv",sep="")

<<<<<<< HEAD
FILES = dir(paste(git_folder,"/data/Input/",sep = "")) 
# FILES = FILES[-2] # <- YOU CAN ALSO APPLY DEW POINT AND LAPSE RATE TO EVERY FILES EXCLUDING THE SECOND, OR OTHER!
=======
#- To set folder of cloned package -----------------------------------------------------------------------------------------------------------------
FOLDER="C:\\Users\\GBertoldi\\Documents\\Git\\EURAC-Ecohydro\\LapseRateCalculator/"
>>>>>>> debe399d23dfc08a856d9600ef9a1e8d11d13b78

# ============================= 

#- To import external functions --------------------------------------------------------------------------------------------------------------------------

source(paste(git_folder,"/R/fun_read_all_stations.R",sep=""))
source(paste(git_folder,"/R/fun_dew_point.R",sep=""))
source(paste(git_folder,"/R/fun_lapse_rate.R",sep=""))

#- To Import elevation of stations. Remind to fill file elevation.csv ------------------------------------------------------------------------------------

elevation_df=read.csv(ELEVATION_PATH,stringsAsFactors = F)
warning(paste("Have you properly filled the file ",git_folder,"/data/Support files/elevation.csv ? If YES, don't worry, if NO check and fill it!",sep = ""))

# ~~~~~~~~~~ Section 2 ~~~~~~~~~~ 

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Dew Point Calculator
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ========= INPUT 4-5 ========= 

VARIABLE_1="T_Air"

VARIABLE_2="RH"

# ============================= 

#- Read data and extract variable AirT (Air Temperature) ----------------------------------------------------------------------------------------------

Air_T=fun_read_all_stations(VARIABLE = VARIABLE_1,FILES = FILES ,FOLDER = git_folder)

#- Read data and extract variable RelHum (Relative Humidity) ------------------------------------------------------------------------------------------

Rel_Hum=fun_read_all_stations(VARIABLE = VARIABLE,FILES = FILES ,FOLDER = git_folder)

#- Dew Point calculator -------------------------------------------------------------------------------------------------------------------------------
Dew_point_temperature=Tdew(TEMP = Air_T[,-1],RH = Rel_Hum[,-1],Z = elevation_df$elevation) # import should be without dates! (E.g. Air_T[,-1], ...)

Dew_point=data.frame(Air_T[,1],Dew_point_temperature)
colnames(Dew_point)[1]="TIMESTAMP"

# ~~~~~~~~~~ Section 3 ~~~~~~~~~~ 

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Lapse Rate Calculator
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ========= INPUT 6-7 ========= 

DATA_FOR_LAPSERATE = Dew_point                    # <-- SELECT HERE THE data.frame TO APPLY LAPSE RATE (with TIMESTAMP!)

ELEVATION_VECTOR = elevation_df$elevation         # <-- SELECT HERE THE vector of ELEVATIONS OF STATIONS (Lenght of ELEVATION_VECTOR should be 
                                                  # the same of the number of stations in DATA_FOR_LAPSERATE)
# ============================= 

#- Lapserate calculator -------------------------------------------------------------------------------------------------------------------------------

output_complete = fun_lapse_rate(DATA_FOR_LAPSERATE = Dew_point,ELEVATION_VECTOR = elevation_df$elevation )

# ~~~~~~~~~~ Section 4 ~~~~~~~~~~ 

#- Export lapse rate as VARIABLE_FOR_LAPSERATE.csv ------------------------------------------------------------------------------------

# ========= INPUT 8 ========= 

VARIABLE_FOR_LAPSERATE = "Dew_point"              # <-- SELECT HERE THE NAME OF VARIABLE USED (e.g. Dew_point or T_Air or ...) (Usually copy under " " DATA_FOR_LAPSERATE )

# =========================== 

write.csv(OUTPUT_COMPLETE,paste(git_folder,"/data/Output/",VARIABLE_FOR_LAPSERATE,".csv",sep = ""),quote = F,row.names = F,na = "NA")

