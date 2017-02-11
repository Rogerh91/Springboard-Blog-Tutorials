###################################
#  Sentiment Analysis             #
###################################

library(RSQLite) #for sqlite

# let's get the data
db <- dbConnect(dbDriver("SQLite"), "/Users/shubham/Documents/R-papers/PlantDisease/hillary-clinton-emails/database.sqlite")

#I need here only the emails
Emails <- data.frame(dbGetQuery(db,"SELECT * FROM Emails"))


library('syuzhet')

d<-get_nrc_sentiment(Emails$RawText)
td<-data.frame(t(d))

td_new <- data.frame(rowSums(td[2:7945]))

#Transformation and  cleaning
names(td_new)[1] <- "count"
td_new <- cbind("sentiment" = rownames(td_new), td_new)
rownames(td_new) <- NULL
td_new2<-td_new[1:8,]

#Vizualisation
library("ggplot2")
qplot(sentiment, data=td_new2, weight=count, geom="histogram",fill=sentiment)+ggtitle("sentiment Email")

