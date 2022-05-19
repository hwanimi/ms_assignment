library(jsonlite)
library(tidyverse)
library(qdapTools)
library(keras)

rawData <- fromJSON("data/train.json", flatten = T)
rawData$cuisine <- factor(rawData$cuisine)
rawTest <- fromJSON("data/test.json", flatten = T)

rawTest <- rawTest %>% mutate(cuisine = NA)
combined <- rbind(rawData, rawTest)
combined <- mtabulate(combined$ingredients)

newtrain <- combined[1:39774,]
newtest <- combined[39775:49718,]

x_train <- newtrain %>% data.matrix(rownames.force = F)
#train_y<- factor(train_df$cuisine)
y_train<- to_categorical(as.numeric(rawData$cuisine))

x_test <- newtest %>% data.matrix(rownames.force = F)

model <- keras_model_sequential() %>% 
  layer_dense(units  = 180, activation = 'relu', input_shape = 7137) %>% 
  layer_dropout(rate = 0.4) %>% 
  layer_dense(units  = 90, activation  = 'relu') %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units  = 21, activation   = 'softmax')

model %>% compile(
  loss = 'categorical_crossentropy',
  optimizer = optimizer_rmsprop(),
  metrics = c('accuracy')
)

history <- model %>% fit(
  x_train, y_train, 
  epochs = 10, batch_size = 64, 
  validation_split = 0.2,
  callbacks = list(
    callback_early_stopping(min_delta = 0.0001, patience = 5)
  )
)

output <- predict_classes(model, x_test) %>% data_frame()

rawData$cuisine %>% levels()
output$cuisine = levels(rawData$cuisine)[output$.]

submission <- data_frame(id = rawTest$id, cuisine = output$cuisine)
write_csv(submission, "submission.csv")
