#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   read_all_stations.R
# Description:  Import all files in folder meteo, extract column VARIABLE and merge in a dataframe 
# Autor:        Christian Brida  
#               Institute for Alpine Environment
# Data:         25/05/2017
# Version:      1.0
#------------------------------------------------------------------------------------------------------------------------------------------------------

NULL

#' Function that read from a folder all file inside and extract the variable selected
#' 
#' @param FOLDER package folder (where package is cloned) 
#' @param FILES  vector of files available in folder data/Input/. Files must have a single raw of headers and all file must start and end at the same time
#' @param VARIABLE variable to extract from every single file and merge in one single dataframe
#'

fun_read_all_stations=function(FOLDER,FILES,VARIABLE){
  # loop1: import file meteo0001.txt
  i=FILES[1]
  data=read.table(paste(FOLDER,"/data/Input/",i,sep = ""),sep = ",",stringsAsFactors = F,header = T)
  
  data=data[c(which(colnames(data)=="TIMESTAMP"),which(colnames(data)==VARIABLE))]
  variable_df=data
  colnames(variable_df)=c("TIMESTAMP",substring(FILES[1], 1, nchar(FILES[1])-4))
 
   # other loops: import other files and merge with data in loop1
  new_FILES=FILES[-1]
  for(i in new_FILES){
    data=read.table(paste(FOLDER,"/data/Input/",i,sep = ""),sep = ",",stringsAsFactors = F,header = T)
    if(nrow(data)==nrow(variable_df)){
      data=data[c(which(colnames(data)=="TIMESTAMP"),which(colnames(data)==VARIABLE))]
      variable_df=cbind(variable_df,data[,2])
      colnames(variable_df)[ncol(variable_df)]=substring(i, 1, nchar(i)-4)
    }else{
      warning("Check length of FILES in FOLDER data/Input/! All file must start at: yyyy/mm/dd hh:mm and end at: YYYY/MM/DD HH:MM")
    }
  }
  
  # summary(variable_df)
  variable_df[variable_df==("NaN")]=NA
  return(variable_df)
}