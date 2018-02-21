listOfVars <- ls()


if(!(   'DBRaw_userinfo' %in% listOfVars &&
        'DBRaw_userinfo_notes' %in% listOfVars &&
        'DBRaw_device_weight' %in% listOfVars &&
        'DBRaw_device_circ' %in% listOfVars &&
        'DBRaw_activity' %in% listOfVars &&
        'DBRaw_activity_intensity' %in% listOfVars &&
        'DBRaw_activity_type' %in% listOfVars &&
        'DBRaw_food' %in% listOfVars &&
        'DBRaw_meds' %in% listOfVars &&
        'DBRaw_plans' %in% listOfVars) )
{
    cat('Backup Raw Data does not exist or missing part of them. Loading whole data from database')
    source('Dataload.R')
}
else
{
    cat('Raw Data found in memory. Directly using raw Data.')
    userinfo = DBRaw_userinfo
    userinfo_notes = DBRaw_userinfo_notes
    device_weight = DBRaw_device_weight
    device_circ = DBRaw_device_circ
    activity = DBRaw_activity
    activity_intensity = DBRaw_activity_intensity
    activity_type = DBRaw_activity_type
    food = DBRaw_food
    meds = DBRaw_meds
    plans = DBRaw_plans
}


system("rm data08.csv.bak.gz")
system("rm data09.csv.bak.gz")
system("mv data08.csv.gz data08.csv.bak.gz")
system("mv data09.csv.gz data09.csv.bak.gz")

source('Preparation.R')

cat('Raw data process is done\r\n')

source('Development_Data.R')

source('LME_Models.R')



