source("Libraries.R")

listOfVars <- list()
if(!(   'DB_USERNAME' %in% listOfVars &&
        'DB_PASSWORD' %in% listOfVars &&
        'DB_HOSTNAME' %in% listOfVars &&
        'DB_SCHEMA' %in% listOfVars) )
{
    cat('Data base login info is missing')
}

con <- dbConnect(MySQL(),
    user = DB_USERNAME,
    password = DB_PASSWORD,
    host = DB_HOSTNAME,
    dbname= DB_SCHEMA)
dbDisconnect(con)     
     
options(sqldf.driver = "SQLite") 





device_weight <- dbGetQuery(conn = con, statement = 
                "SELECT user_id, DATE(date_recorded) AS date_recorded, weight, substring(date_recorded, 1, 7) AS yearmo
                FROM device_weight
                WHERE weight > 100 AND weight < 1000 AND user_id !=0;
                ")   
