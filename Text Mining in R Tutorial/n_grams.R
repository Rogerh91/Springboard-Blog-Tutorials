library(tm)
library(RSQLite)
library(quanteda)

db <- dbConnect(dbDriver("SQLite"), "/Users/shubham/Documents/hillary-clinton-emails/database.sqlite")

# Get all the emails sent by Hillary
emailHillary <- dbGetQuery(db, "SELECT ExtractedBodyText EmailBody FROM Emails e INNER JOIN Persons p ON e.SenderPersonId=P.Id WHERE p.Name='Hillary Clinton'  
                           AND e.ExtractedBodyText != '' ORDER BY RANDOM()")
txt <- paste(emailHillary$EmailBody, collapse=" // ")


collocations(txt, size = 2:3)
print(removeFeatures(collocations(txt, size = 2:3), stopwords("english")))


