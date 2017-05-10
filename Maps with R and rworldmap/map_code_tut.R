library(rworldmap)

#bring in the data
met <- as.data.frame(read.csv("MetObjects_5k-sample.csv"))

#country of origin frequency table
countries.met <- as.data.frame(table(met$Country))
colnames(countries.met) <- c("country", "value")

#optional -- delete egypt b/c of skew

matched <- joinCountryData2Map(countries.met, joinCode="NAME", nameJoinColumn="country")

mapCountryData(matched, nameColumnToPlot="value", mapTitle="Met Collection Country Sample", catMethod = "pretty", colourPalette = "heat")

# without egypt
countries.met.2 <- countries.met[-21,]
matched.2 <- joinCountryData2Map(countries.met.2, joinCode="NAME", nameJoinColumn="country")

mapCountryData(matched.2, nameColumnToPlot="value", mapTitle="Met Collection Country Sample", catMethod = "pretty", colourPalette = "heat")

mapCountryData(matched, nameColumnToPlot="value", mapTitle="Eurasia",mapRegion="Eurasia", colourPalette="terrain", catMethod="pretty")
