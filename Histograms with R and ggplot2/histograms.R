library(ggplot2)

#step 1. import the data as a dataframe
met <- as.data.frame(read.csv("MetObjects_5k-sample.csv"))
tate <- as.data.frame(read.csv("TateObjects_5k-sample.csv"))

#step 2. subset the data

met.subset <- subset(met, met$Object.Begin.Date>-2000 & met$Object.Begin.Date<2016)
tate.subset <- subset(tate, tate$year>-2000 & tate$year<2016)

# step 3. plot the histogram by decade
ggplot(data = met.subset, aes(met.subset$Object.Begin.Date)) + 
  geom_histogram(binwidth = 10) +
  ggtitle("Art Object Date Distribution in the Met") + xlab("Year") + ylab("Number of Art Objects")

ggplot(data = tate.subset, aes(tate.subset$year)) + 
  geom_histogram(binwidth = 10) +
  ggtitle("Art Object Date Distribution in the Tate") + xlab("Year") + ylab("Number of Art Objects")

#step 4. modern art subsets
met.modern <- subset(met, met$Object.Begin.Date>1850 & met$Object.Begin.Date<2016)
tate.modern <- subset(tate, tate$year>1850 & tate$year<2016)

ggplot(data = met.modern, aes(met.modern$Object.Begin.Date)) + 
  geom_histogram(binwidth = 10) +
  ggtitle("Met: Modern Art Date Distribution") + xlab("Year") + ylab("Number of Art Objects")

ggplot(data = tate.modern, aes(tate.modern$year)) + 
  geom_histogram(binwidth = 10) +
  ggtitle("Tate: Modern Art Date Distribution") + xlab("Year") + ylab("Number of Art Objects")