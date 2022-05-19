library(jsonlite)
library(tidyverse)
library(qdapTools)
library(keras)

## read data
rawData <- fromJSON("data/train.json", flatten = T)
rawData$cuisine <- factor(rawData$cuisine)
rawTest <- fromJSON("data/test.json", flatten = T)

## edit data ; neural network need same number of variables
rawTest <- rawTest %>% mutate(cuisine = NA)
combined <- rbind(rawData, rawTest)
combined <- mtabulate(combined$ingredients)

newtrain <- combined[1:39774,]
newtest <- combined[39775:49718,]

## remove outlier by feature extraction
for(m in c("3.8")) {
  drop_ingredients <- as.vector(read.csv(sprintf('data/txt/drop_e%s.txt', m), header=FALSE)$V1)
  # distribution skewness: remove recipes if the number of ingredients in recipe is over 30
  for(p in c(30)) {
    print(sprintf('Entropy: %s, Most recipe ingredients num: %d', m, p))
    combined_df <- combined
    #combined_df <- combined_df[(combined_df$ingredient_num > 2 & combined_df$ingredient_num < p),]
    combined_df <- combined_df[,!(names(combined_df) %in% drop_ingredients)]
  }
}
# special: remove ingredients if used times of ingredient is under 5 in all dataset
df<-combined_df
for (k in (1: ncol(combined_df))){
  s = sum(combined_df[k])
  if (s <= 1) {
    df[,colnames(combined_df[k])]       <- NULL
  }
}

# dimension -2000
#dim(combined)
#[1] 49718  7137
#dim(combined_df)
#[1] 49718  7110
#dim(df)
#[1] 49718  5285

## final data after application of machine learning preprocessing
dftrain <- df[1:39774,]
dftest <- df[39775:49718,]

## transfer matrix ; input style of neural network
x_dftrain <- dftrain %>% data.matrix(rownames.force = F)
#train_y<- factor(train_df$cuisine)
y_dftrain<- to_categorical(as.numeric(rawData$cuisine))

x_dftest <- dftest %>% data.matrix(rownames.force = F)

## train model
model <- keras_model_sequential() %>% 
  layer_dense(units  = 180, activation = 'relu', input_shape = ncol(dftrain)) %>% 
  layer_dropout(rate = 0.4) %>% 
  layer_dense(units  = 90, activation  = 'relu') %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units  = 21, activation   = 'softmax')

model %>% compile(
  loss = 'categorical_crossentropy',
  optimizer = optimizer_rmsprop(),
  metrics = c('accuracy')
)
model

history <- model %>% fit(
  x_dftrain, y_dftrain, 
  epochs = 10, batch_size = 64, 
  validation_split = 0.2,
  callbacks = list(
    callback_early_stopping(min_delta = 0.0001, patience = 5)
  )
)
plot(history)

## get output through input test data to model
dfoutput <- predict_classes(model, x_dftest) %>% data_frame()
rawData$cuisine %>% levels()
dfoutput$cuisine = levels(rawData$cuisine)[dfoutput$.]
submission <- data_frame(id = rawTest$id, cuisine = dfoutput$cuisine)
write_csv(submission, "submission.csv") #0.78
