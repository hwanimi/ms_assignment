# include
tryCatch({
  library('class')
}, error = function(e) {
  cat('You need to install "class" package before running this code.')
  quit()
})

tryCatch({
  library('e1071')
}, error = function(e) {
  cat('You need to install "e1071" package before running this code.')
  quit()
})

# functionss
# convert_float_format <- function(chr)
# {
#   temp <- formatC(chr, digits = 2, format = 'f', drop0trailing = TRUE)
# }

# main
n <- 5

train_file <- 'data/csv/train.csv'
#test_file <- 'data/csv/test.csv'

train_dataset <- read.csv(train_file, sep=',', header=TRUE, encoding='UTF-8')
#test_dataset <- read.csv(test_file, sep=',', header=TRUE, encoding='UTF-8')

rgroup <- sample(1:3, size=nrow(train_dataset), replace=TRUE, prob=c(0.5, 0.35, 0.15))
train_set <- train_dataset[rgroup == 2,]
test_set <- train_dataset[rgroup == 3,]

test_labels <- test_set$cuisine

# model <- naiveBayes(cuisine ~., data=train_set[-c(1)])
model <- knn(train=train_set[-c(1, 2)], test=test_set[-c(1, 2)], cl=train_set$cuisine)

test_pred <- predict(model, test_set[-c(1,2)])
test_compare <- sum(test_pred == test_labels)
test_accuracy <- test_accuracy + (test_compare / length(test_labels))

print(test_accuracy)

final_pred <- predict(model, test_dataset[-c(1)])
final_df <- data.frame(PassengerId=test_dataset$id, cuisine=final_pred)
submit_file <- 'submit.csv'
write.table(final_df, submit_file, sep=',', quote=FALSE, row.names=FALSE)
# 
# res_df <- data.frame()
# train_df <- data.frame(set='training', accuracy=convert_float_format(best_train_accuracy))
# valid_df <- data.frame(set='validation', accuracy=convert_float_format(best_valid_accuracy))
# test_df <- data.frame(set='test', accuracy=convert_float_format(best_test_accuracy))
# final_df <- data.frame(set='final', accuracy=convert_float_format(final_accuracy))
# res_df <- rbind(res_df, train_df)
# res_df <- rbind(res_df, valid_df)
# res_df <- rbind(res_df, test_df)
# res_df <- rbind(res_df, final_df)
# print(res_df)