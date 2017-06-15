#if you need to install the packages needed, the following lines of code will do so
install.packages("kernlab")
install.packages("caret")
install.packages("tm")
install.packages("dplyr")
install.packages("splitstackshape")
install.packages("e1071")

#the following commands will activate the needed libraries
library("kernlab")
library("caret")
library("tm")
library("dplyr")
library("splitstackshape")
library("e1071")

# Step 1. Ingest your training data and clean it.
train <- VCorpus(DirSource("Training", encoding = "UTF-8"), readerControl=list(language="English"))
train <- tm_map(train, content_transformer(stripWhitespace))
train <- tm_map(train, content_transformer(tolower))
train <- tm_map(train, content_transformer(removeNumbers))
train <- tm_map(train, content_transformer(removePunctuation))

# Step 2. Create your document term matrices for the training data.
train.dtm <- as.matrix(DocumentTermMatrix(train, control=list(wordLengths=c(1,Inf))))
#train.matrix <- as.matrix(train.dtm, stringsAsFactors=F)

# Step 3. Repeat steps 1 & 2 above for the Test set.
test <- VCorpus(DirSource("Test", encoding = "UTF-8"), readerControl=list(language="English"))
test <- tm_map(test, content_transformer(stripWhitespace))
test <- tm_map(test, content_transformer(tolower))
test <- tm_map(test, content_transformer(removeNumbers))
test <- tm_map(test, content_transformer(removePunctuation))
test.dtm <- as.matrix(DocumentTermMatrix(test, control=list(wordLengths=c(1,Inf))))

# Step 4. Make test and train matrices of identical length (find intersection)
train.df <- data.frame(train.dtm[,intersect(colnames(train.dtm), colnames(test.dtm))])
test.df <- data.frame(test.dtm[,intersect(colnames(test.dtm), colnames(train.dtm))])

# Step 5. Retrieve the correct labels for training data and put dummy values for testing data
label.df <- data.frame(row.names(train.df))
colnames(label.df) <- c("filenames")
label.df<- cSplit(label.df, 'filenames', sep="_", type.convert=FALSE)
train.df$corpus<- label.df$filenames_1
test.df$corpus <- c("Neg")


# Step 6. Create folds of your data, then run the training once to inspect results
df.train <- train.df
df.test <- train.df
df.model<-ksvm(corpus~., data= df.train, kernel="rbfdot")
df.pred<-predict(df.model, df.test)
con.matrix<-confusionMatrix(df.pred, df.test$corpus)
print(con.matrix)

# Step 7. Run the final prediction on the test data and re-attach file names. 
df.test <- test.df
df.pred<-predict(df.model, df.test)
results <- as.data.frame(df.pred)
rownames(results) <- rownames(test.df)
print(results)

