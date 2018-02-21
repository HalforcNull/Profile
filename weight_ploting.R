





#histogram of all weight measurements -  between 100 and 1000
png('all_weight.png',width=6, height=4, units='in', res=300)
ggplot(data=clean_weight[which(clean_weight$date_recorded>='2014-05-01'),], aes(weight)) +
  geom_histogram(color="black", fill="blue", breaks = seq(100, 600, 50)) +
  xlab("Weight") +	
  ylab("Number of Measurements") +
  scale_x_continuous(breaks = seq(100, 600, 50)) +
  scale_y_continuous(breaks=seq(0,1000000,100000), label = comma) +
  theme(axis.text.x = element_text(angle = 45, hjust=1),
        axis.text = element_text(size = 16),
        axis.title = element_text(size = 18),
        panel.grid.major = element_line(colour = "white"),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "grey90"))
dev.off()


#histogram of the hour of weight measurement - ALL MEASUREMENTS between 100 and 1000
png('time_weight.png',width=10, height=4, units='in', res=300)
ggplot(data=clean_weight2[which(clean_weight2$date_recorded>='2014-05-01'),], aes(weight_hour)) +
  geom_bar(color="black", fill="blue", aes(y=..count../sum(..count..))) +
  xlab("Hour") +	
  ylab("Proportion of Measurements") +
  scale_y_continuous(breaks=seq(0,1,.05)) +
  theme(axis.text = element_text(size = 16),
        axis.title = element_text(size = 18),
        panel.grid.major = element_line(colour = "white"),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "grey90"))
dev.off()



#histogram of the month of weight measurements - starting in May 2014
png('date_weight.png',width=8, height=4, units='in', res=300)
ggplot(data=clean_weight[which(clean_weight$date_recorded>='2014-05-01'),], aes(yearmo)) +
  geom_bar(stat="count", color="black", fill="blue") +
  xlab("Date") +	
  ylab("Number of Measurements") +
  scale_y_continuous(breaks=seq(0,200000,10000), label = comma) +
  theme(axis.text.x = element_text(angle = 45, hjust=1),
        axis.text = element_text(size = 16),
        axis.title = element_text(size = 18),
        panel.grid.major = element_line(colour = "white"),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "grey90"))
dev.off()


##scatterplot of weight measurements by days in program
#all measurements
ggplot(clean_weight4[which(clean_weight4$days>0),] , aes(x=days, y=weight)) +
  stat_binhex()

#the first year
ggplot(clean_weight4[which(clean_weight4$days>0 & clean_weight4$days<=365),] , aes(x=days, y=weight)) +
  stat_binhex(bins=50, geom="hex")

#first six months - weight
png('weight_meas_sixmo_days.png',width=8, height=6, units='in', res=300)
ggplot(clean_weight4[which(clean_weight4$days>0 & clean_weight4$days<=183),] , aes(x=days, y=weight)) +
  stat_binhex(bins=50, geom="hex") +
  scale_fill_gradientn(colours=c("lightskyblue","black"),name = "Frequency",na.value=NA) +
  xlab("Days in Program") +	
  ylab("Weight") +
  ggtitle("Weight Measurement by Days in Program \n for the first six months") +
  scale_x_continuous(breaks = seq(0, 183, 30)) +
  scale_y_continuous(breaks=seq(100,600,100)) +
  theme(
    axis.text = element_text(size = 16),
    axis.title = element_text(size = 18),
    panel.grid.major = element_line(colour = "white"),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "grey90"),
    legend.text = element_text(size = 16),
    legend.title = element_text(size = 16),
    legend.position="right",
    plot.title = element_text(size=18, face="bold", hjust=0.5))
dev.off()

#first six months - cum WL
nrow(clean_weight4[which(clean_weight4$days>0 & clean_weight4$days<=183),])
png('cumWL_meas_sixmo_days.png',width=8, height=6, units='in', res=300)
ggplot(clean_weight4[which(clean_weight4$days>0 & clean_weight4$days<=183),] , aes(x=days, y=pct_WL_cum)) +
  stat_binhex(bins=50, geom="hex") +
  scale_fill_gradientn(colours=c("plum","black"),name = "Frequency",na.value=NA) +
  xlab("Days in Program") +	
  ylab("Cumulative Weight Loss") +
  ggtitle("Cumulative Weight Loss by Days in Program \n for the first six months") +
  scale_x_continuous(breaks = seq(0, 183, 30)) +
  scale_y_continuous(breaks=seq(-60,60,15)) +
  theme(
    axis.text = element_text(size = 16),
    axis.title = element_text(size = 18),
    panel.grid.major = element_line(colour = "white"),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "grey90"),
    legend.text = element_text(size = 16),
    legend.title = element_text(size = 16),
    legend.position="right",
    plot.title = element_text(size=18, face="bold",hjust = 0.5))
dev.off()

