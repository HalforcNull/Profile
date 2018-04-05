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

#save(weightloss_daily_track, file = "weightloss_daily_track.rda")

activity_daily_track <-
  dbGetQuery(conn = con, statement = "
            SELECT activity_type_id, activity_intensity_id, user_id, duration, date_added
            FROM activity
            WHERE id_deleted = 0 and date_added > '2016-01-01' and date_added < '2017-06-01'") 


#save(activity_daily_track, file = "activity_daily_track.rda")




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


userinfo <- 
  dbGetQuery(conn = con, statement = paste0(
                      "SELECT id, city, state, zip, birthdate, marital_status, comments_message, gender, height, goal_weight, 
                                sap_num, referred_by, start_weight, start_bp_sys, start_bp_dia, member_since, a.date_added as date_added, 
                                a.date_modified as date_modified, or_coach_id, store_id, bmr, promo_code, physician_referral, other_referral, 
                                is_first_time, is_coach, is_verified, emr_patient_no, hl_connection, user_disable_hl, opt_research, opt_email,
                                homestore,lead_source,membership_purchased_date,crm_id,pos_id
                        FROM userinfo a
                        WHERE a.id in ('",
                      paste(uid, collapse = "','"),
                      "');") )
                     
             

source("Libraries.R")
tmp1 <- sqldf("Select * from userinfo a join weightloss_daily_track b on a.id = b.user_id",drv="SQLite")

uid.in.userinfo <- unique(userinfo$id)
k <- uid.in.userinfo
userinfo.missed.uid.1 <- setdiff(as.numeric(uid.in.userinfo), uid)
userinfo.missed.uid.2 <- setdiff(uid, as.numeric(uid.in.userinfo))
length(userinfo.missed.uid.2)
userinfo.missed.uid.2






#######################################################################################################
##############################       Part 2. Create data table           ##############################
#######################################################################################################

firstSix <- weightloss_daily_track[weightloss_daily_track$measureDay < 180,]

df <- data.frame(matrix(unlist(seq(from = 1, to = 27, by = 1)), nrow=27, byrow=T))
colnames(df) <- c("week")

my.wl.data.table <-sqldf( "SELECT a.user_id, b.week, a.avgWL, a.varWL, measureCount
FROM
df b 
left join
(
  SELECT user_id, weekCount, avg(weightloss) as avgWL, VARIANCE(weightloss) as varWL, count(*) as measureCount FROM
  ( Select user_id, floor(measureDay/7)+1 as weekCount, weightloss FROm firstSix )
  GROUP BY
  user_id,
  weekCount
) a on b.week=a.weekCount ORDER BY user_id", drv="SQLite")

#TESTCODE: k <- my.wl.data.table[my.wl.data.table$user_id == 2613,]
#k <- my.wl.data.table[my.wl.data.table$user_id == 2613 & my.wl.data.table$week == 3,c(3,4,5)]

k <- list()
for(i in 1:27){
  tempt <- my.wl.data.table[my.wl.data.table$user_id == 2613 & my.wl.data.table$week == i,c(3,4,5)]
  if(length(tempt[,1])==0)
  {
    tempt =  t(c(NA,NA,NA))
    #rownames(tempt) <- c("avgWL","varWL","measureCount")
  }
  print(tempt)
  ##https://www.rdocumentation.org/packages/rlist/versions/0.4.6.1/topics/list.append
  
  k.append(unlist(tempt[1,], use.names = FALSE) )
}
