library(data.table)

### Clear environment i.e. delete all data and variables
rm(list = ls())
# Clear console
cat("\014")


EndWeek <- '2021-W23'
StartWeek <- paste0(as.numeric(substr(EndWeek,1,4)) - 5 - as.numeric(substr(EndWeek,7,8) < "26"), "-W27")


# Population data ---------------------------------------------------------
source("/R/GetDKPopData.R", encoding = "UTF-8")
PopData <- GetDKPopData(StartWeek, EndWeek)
rm(GetDKPopData)


# Virological data --------------------------------------------------------
source(paste0(getwd(), "/R/GetVirData.R"), encoding = "UTF-8")
VirData <- data.table(merge(GetVirData(StartWeek, EndWeek), PopData, by = c('group', 'ISOweek')))
rm(GetVirData)

# SARI
saveRDS(VirData, "data/VirData_SARI.RDS")


# Clinical data -----------------------------------------------------------
source(paste0(getwd(), "/R/GetSILSData.R"), encoding = "UTF-8")
SILSData <- data.table(merge(GetSILSData(StartWeek, EndWeek), PopData, by = c('group', 'ISOweek')))
rm(GetSILSData)

# SARI
saveRDS(SILSData, "data/SILSData_SARI.RDS")
