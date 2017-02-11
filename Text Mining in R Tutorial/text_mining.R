# Connection
library(RSQLite)
db <- dbConnect(dbDriver("SQLite"), "/Users/shubham/Documents/hillary-clinton-emails/database.sqlite")

# Get all the emails sent by Hillary
emailHillary <- dbGetQuery(db, "SELECT ExtractedBodyText EmailBody FROM Emails e INNER JOIN Persons p ON e.SenderPersonId=P.Id WHERE p.Name='Hillary Clinton'  
                           AND e.ExtractedBodyText != '' ORDER BY RANDOM()")
emailRaw <- paste(emailHillary$EmailBody, collapse=" // ")

# Transform and clean the text
library("tm")
docs <- Corpus(VectorSource(emailRaw))

# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)

# Text stemming (reduces words to their root form)
library("SnowballC")
docs <- tm_map(docs, stemDocument)
# Remove additional stopwords
docs <- tm_map(docs, removeWords, c("clintonemailcom", "stategov", "hrod"))

# Term-document matrix
dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

# Generate the WordCloud
library("wordcloud")
library("RColorBrewer")
par(bg="grey30") 
png(file="WordCloud2.png",width=1000,height=700, bg="grey30")
wordcloud(d$word, d$freq, col=terrain.colors(length(d$word), alpha=0.9), random.order=FALSE, rot.per=0.3 )
title(main = "Hillary Clinton's Most Used Words in the Emails", font.main = 1, col.main = "cornsilk3", cex.main = 1.5)
dev.off()

Emails <- data.frame(dbGetQuery(db,"SELECT * FROM Emails"))

library('syuzhet')

d<-get_nrc_sentiment(Emails$RawText)
print(d)
td<-data.frame(t(d))

td_new <- data.frame(rowSums(td[2:7945]))

#Transformation and  cleaning
names(td_new)[1] <- "count"

td_new <- cbind("sentiment" = rownames(td_new), td_new)

rownames(td_new) <- NULL
td_new2<-td_new[1:8,]
print(td_new2)

#Vizualisation
library("ggplot2")
qplot(sentiment, data=td_new2, weight=count, geom="bar",fill=sentiment)+ggtitle("Email sentiments")


