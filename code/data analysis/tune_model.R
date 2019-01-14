# library(randomForest)
library(e1071)

best_model <- ''
best_test_accuracy <- 0
best_params <- c()
n <- 10

for(k in 4:10) {
  load(sprintf('data/train_%d.Rdata', k))
  raw_train_df <- train_df
  for(m in c("3.5", "3.8", "4.0", "4.2")) {
    drop_ingredients <- as.vector(read.csv(sprintf('data/txt/drop_e%s.txt', m), header=FALSE)$V1)
    for(p in c(25, 30)) {
      print(sprintf('Least ingredient used times: %d, Entropy: %s, Most recipe ingredients num: %d', k, m, p))
      train_df <- raw_train_df
      train_df <- train_df[(train_df$ingredient_num > 2 & train_df$ingredient_num < p),]
      train_df <- train_df[,!(names(train_df) %in% drop_ingredients)]

      avg_train_accuracy <- 0
      avg_valid_accuracy <- 0
      avg_test_accuracy <- 0

      part_best_test_accuracy <- 0
      part_best_model <- ''

      for(i in 1:n) {
        set.seed(106289)
        rgroup <- sample(1:n, size=nrow(train_df), replace=TRUE)
        valid_set <- train_df[rgroup == i,]
        test_set <- train_df[rgroup == ifelse(i == 10, 1, i+1),]
        train_set <- train_df[rgroup %in% (1:n)[-c(i, ifelse(i == 10, 1, i+1))],]

        train_labels <- train_set$cuisine
        valid_labels <- valid_set$cuisine
        test_labels <- test_set$cuisine

        gc()
        model <- naiveBayes(cuisine~., data=train_set[-c(1, 3)]) # 0.72928
        # model <- svm(cuisine~., data=train_set[-c(1)]) # 0.31
        # model <- randomForest(cuisine~., data=train_set[-c(1)], importance=TRUE, proximity=TRUE, ntree=10, mtry=1000, do.trace=1) # 0.62

        gc()
        train_pred <- predict(model, train_set[-c(1,2,3)])
        train_compare <- sum(train_pred == train_labels)
        train_accuracy <- 0
        train_accuracy <- train_accuracy + (train_compare / length(train_labels))
        print(sprintf('train accuracy: %f', train_accuracy))
        gc()

        valid_pred <- predict(model, valid_set[-c(1,2,3)])
        valid_compare <- sum(valid_pred == valid_labels)
        valid_accuracy <- 0
        valid_accuracy <- valid_accuracy + (valid_compare / length(valid_labels))
        print(sprintf('valid accuracy: %f', valid_accuracy))
        gc()

        test_pred <- predict(model, test_set[-c(1,2,3)])
        test_compare <- sum(test_pred == test_labels)
        test_accuracy <- 0
        test_accuracy <- test_accuracy + (test_compare / length(test_labels))
        print(sprintf('test accuracy: %f', test_accuracy))
        print('==================================================')
        gc()

        if(test_accuracy > part_best_test_accuracy) {
          part_best_test_accuracy <- test_accuracy
          part_best_model <- model
        }

        avg_train_accuracy <- avg_train_accuracy + train_accuracy
        avg_valid_accuracy <- avg_valid_accuracy + valid_accuracy
        avg_test_accuracy <- avg_test_accuracy + test_accuracy
      }

      avg_train_accuracy <- avg_train_accuracy / n
      avg_valid_accuracy <- avg_valid_accuracy /n
      avg_test_accuracy <- avg_test_accuracy /n

      print(sprintf('avg train accuracy: %f', avg_train_accuracy))
      print(sprintf('avg valid accuracy: %f', avg_valid_accuracy))
      print(sprintf('avg test accuracy:  %f', avg_test_accuracy))
      print('##################################################')

      if(avg_test_accuracy > best_test_accuracy) {
        best_test_accuracy <- avg_test_accuracy
        best_model <- part_best_model
        best_params <- c(k, m, p)
      }
    }
  }
}

print(best_params)
print(best_test_accuracy)

load('data/test.Rdata')
test_df <- test_df[,!(names(test_df) %in% drop_ingredients)]
final_pred <- predict(model, test_df[-c(1)])
final_df <- data.frame(id=test_df$id, cuisine=final_pred)
write.table(final_df, 'data/submit.csv', quote=FALSE, sep=',', row.names=FALSE)