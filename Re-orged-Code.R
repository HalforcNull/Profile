source("Libraries.R")
library(RMySQL)
con <- dbConnect(MySQL(),
                 user = DB_USERNAME,
                 password = DB_PASSWORD,
                 host = DB_HOSTNAME,
                 dbname= DB_SCHEMA)


options(sqldf.driver = "SQLite") 
weightloss_daily_track <- 
  dbGetQuery(conn = con, statement = "
             Select user_id, measureDay, min(weightloss) as weightloss, firstweight
             From 
             ( Select a.user_id, firstweight-weight as weightloss, firstweight, datediff(date_recorded, firstdate) as measureDay, firstdate
             from device_weight a join 
             (Select user_id, min(date_recorded) as firstdate, weight as firstweight
             from device_weight
             group by user_id
             ) b on a.user_id = b.user_id
             where b.firstdate > '2016-01-01' and b.firstdate < '2017-06-01'
             ) k
             group by user_id, measureDay")


firstSix <- weightloss_daily_track[weightloss_daily_track$measureDay < 180,]
boxplot(weightloss~measureDay, data=firstSix, outline=FALSE)
temp <- firstSix[,c("user_id","measureDay")]
require(data.table)
DT_byDay=as.data.table(temp)
temp_byDay <- DT_byDay[,.SD[which.max(measureDay)],by=user_id]
colnames(temp_byDay) <- c("user_id", "maxMeasureDay")
tmp_id_count <- data.frame( table(temp$user_id) )

hist(tmp_id_count$Freq)


uid <- unique(weightloss_daily_track$user_id)
lowestDay <- NULL
for(i in 1:length(uid)){
  k = weightloss_daily_track[weightloss_daily_track$user_id == uid[i],]
  lowestDay <- rbind(lowestDay, k[which.max(k$weightloss),]$measureDay)
}

boxplot(lowestDay, ylim = c(0,300))
plot(table(lowestDay), xlim = c(0,300))






