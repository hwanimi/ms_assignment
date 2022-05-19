library(stringr)
library(jsonlite)
library(DescTools)

# functions
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
handle_string <- function(str) {
  str <- iconv(str, to='ASCII')
  
  # all string to lower case
  str <- tolower(str)
  
  # remove word behind ,
  if(grepl(',', str)) {
    index <- str_locate(pattern=',', str)
    str <- substr(str, 1, index-1)
  }
  
  # remove word before oz.)
  if(grepl('oz\\.\\) ', str)) {
    index <- str_locate(pattern='oz\\.\\) ', str)[[2]]
    str <- substr(str, index + 1, str_length(str))
  }
  
  # remove !
  str <- gsub('!', '', str)
  # remove %
  str <- gsub('[0-9]+% ', '', str)
  # remove ()
  str <- gsub(" \\(.+\\)", '', str)
  # remove _&
  str <- gsub(' & ', ' ', str)
  # remove &
  str <- gsub('&', '', str)
  # remove lb.
  str <- gsub('.+ lb\\. ', '', str)
  # remove ounc
  str <- gsub('.+ ounc ', '', str)
  # remove 's
  str <- gsub(".+\\'s ", '', str)
  # remove '
  str <- gsub("'", '', str)
  # replace all dash to dot
  str <- gsub('-', '.', str)
  # replace all blank to dot
  str <- gsub(' ', '.', str)
  
  str <- trim(str)
  str
}

# Preprocess train data
train_json <- fromJSON('data/train.json')
# backup_train_json <- train_json
# train_json <- backup_train_json
all_ids <- c()
all_cuisines <- c()
all_ingredients <- c()
all_ingredient_num <- c()
rows <- dim(train_json)[[1]]

for(i in 1:rows) {
  ingredients <- train_json[i,]$ingredients[[1]]
  ingredients_num <- length(ingredients)
  all_ids <- c(all_ids, train_json[i,]$id)
  all_cuisines <- c(all_cuisines, train_json[i,]$cuisine)
  all_ingredient_num <- c(all_ingredient_num, ingredients_num)
  for(j in 1:ingredients_num) {
    str <- train_json[i,]$ingredients[[1]][[j]]
    str <- handle_string(str)
    train_json[i,]$ingredients[[1]][[j]] <- str
    all_ingredients <- union(all_ingredients, str)
  }
}

rows <- length(all_ids)
cols <- length(all_ingredients)
ingredient_total <- rep(0, cols)

ingredient_matrix <- matrix(rep(FALSE, rows * cols), nrow=rows, ncol=cols)
for(i in 1:rows) {
  ingredients <- train_json[i,]$ingredients[[1]]
  ingredients_num <- length(ingredients)
  for(j in 1:ingredients_num) {
    ingredient <- train_json[i,]$ingredients[[1]][[j]]
    index <- which(all_ingredients == ingredient)
    if(length(index) == 1) {
      ingredient_matrix[i, index] <- TRUE
      ingredient_total[[index]] <- ingredient_total[[index]] + 1
    }
  }
}

head_df <- data.frame(id=all_ids, cuisine=all_cuisines, ingredient_num=all_ingredient_num)
ingredient_df <- as.data.frame(ingredient_matrix)
colnames(ingredient_df) <- all_ingredients
ingredient_df_bak <- ingredient_df

for(i in 1:10) {
  keep_cols <- ingredient_total >= i
  ingredient_df <- ingredient_df[keep_cols]
  train_df <- cbind(head_df, ingredient_df)
  train_df$`7.up` <- NULL
  save(train_df, file=sprintf('data/train_%d.Rdata', i))
  ingredient_df <- ingredient_df_bak
}



# calculate entropy
# all_ingredients <- colnames(train_df[-c(1,2)])
# all_cuisines <- train_df$cuisine
# drop_ingredients <- c()
# for(i in a) {
#   all_use_rate <- c()
#   for(j in unique(all_cuisines)) {
#     total <- length(train_df[train_df$cuisine == j,]$cuisine)
#     use_rate <- sum(train_df[train_df$cuisine == j,][[i]])/total
#     all_use_rate <- c(all_use_rate, use_rate)
#   }
#   entropy <- Entropy(all_use_rate)
#   if(entropy > 3.8) {
#     print(i)
#     print(entropy)
#     drop_ingredients <- c(drop_ingredients, i)
#   }
# }



# Preprocess test data
test_json <- fromJSON('data/test.json')
backup_test_json <- test_json
# test_json <- backup_test_json
all_ids <- c()
rows <- dim(test_json)[[1]]

for(i in 1:rows) {
  ingredients <- test_json[i,]$ingredients[[1]]
  ingredients_num <- length(ingredients)
  all_ids <- c(all_ids, test_json[i,]$id)
  for(j in 1:ingredients_num) {
    str <- test_json[i,]$ingredients[[1]][[j]]
    str <- handle_string(str)
    test_json[i,]$ingredients[[1]][[j]] <- str
  }
}

cols <- length(all_ingredients)

ingredient_matrix <- matrix(rep(FALSE, rows * cols), nrow=rows, ncol=cols)
for(i in 1:rows) {
  ingredients <- test_json[i,]$ingredients[[1]]
  ingredients_num <- length(ingredients)
  for(j in 1:ingredients_num) {
    ingredient <- test_json[i,]$ingredients[[1]][[j]]
    index <- which(all_ingredients == ingredient)
    if(length(index) == 1) {
      ingredient_matrix[i, index] <- TRUE
    }
  }
}

head_df <- data.frame(id=all_ids)
ingredient_df <- as.data.frame(ingredient_matrix)
colnames(ingredient_df) <- all_ingredients
test_df <- cbind(head_df, ingredient_df)

save(test_df, file='data/test.Rdata')
