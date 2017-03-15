library(ggplot2)
library(dplyr)
library(reshape2)

#ingest the data
met.collection <- read.csv("~/Data/Art/Met/MetObjects.csv")

# isolate and create frequency table for nationality

nationality <- data.frame(table(met.collection$Artist.Nationality))
nationality <- nationality[order(nationality$Freq,-rank(nationality$Freq), decreasing = TRUE), ]

#plot top 10

df <- nationality[2:11, ]
ggplot(df, aes(x = Var1, y = Freq)) + 
  geom_bar(stat = "identity", color = "black", fill = "grey") +
  labs(title = "Frequency by Country\n", x = "\nCountry", y = "Frequency\n") +
  theme_classic() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# isolate and create frequency table for city

city <- data.frame(table(met.collection$City))
city <- city[order(city$Freq,-rank(city$Freq), decreasing = TRUE), ]

#plot top 10
df <- city[2:11, ]
ggplot(df, aes(x = Var1, y = Freq)) + 
  geom_bar(stat = "identity", color = "black", fill = "grey") +
  labs(title = "Frequency by City\n", x = "\nCountry", y = "Frequency\n") +
  theme_classic() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# isolate and create frequency table for date

date <- data.frame(table(met.collection$Object.Date))
date <- date[order(date$Freq,-rank(date$Freq), decreasing = TRUE), ]

#plot top 10
df <- date[3:11, ]
ggplot(df, aes(x = Var1, y = Freq)) + 
  geom_bar(stat = "identity", color = "black", fill = "grey") +
  labs(title = "Frequency by Date\n", x = "\nCountry", y = "Frequency\n") +
  theme_classic() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
