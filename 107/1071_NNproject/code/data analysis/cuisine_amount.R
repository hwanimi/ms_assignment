library(ggplot2)

top <- 20
train <- read.csv('data/csv/train.csv', header=TRUE ,sep=',', encoding = 'UTF-8')
temp <- summary(train$cuisine)
cuisines <- as.data.frame(t(temp))
cuisines <- data.frame(cuisine=colnames(cuisines), amount=temp)
cuisines <- cuisines[order(cuisines$amount, decreasing = FALSE),]
cuisines$cuisine <- factor(cuisines$cuisine, levels=unique(cuisines$cuisine))
bar_chart <- ggplot(cuisines) +
             geom_bar(aes(x=cuisine, y=amount),
                      stat="identity", fill='gray') +
             coord_flip() + 
             geom_text(aes(x=cuisine, y=amount, label=amount), vjust=0) +
             ggtitle("Cuisine amount")
#ggsave('img/train_cuisine_amount.png', plot=bar_chart)

n <- length(colnames(train))
sum_in_df <- data.frame(ingredient = character(n-2), total = numeric(n-2), stringsAsFactors = FALSE)
for(i in 3:n) {
  column <- colnames(train)[[i]]
  sum_in_df$ingredient[i-2] <- column
  sum_in_df$total[i-2] <- colSums(train[column])
}
print(summary(sum_in_df$total))

sum_in_df <- sum_in_df[order(sum_in_df$total, decreasing = FALSE),]
sum_in_df$ingredient <- factor(sum_in_df$ingredient, levels=unique(sum_in_df$ingredient))
bar_chart <- ggplot(sum_in_df[(n-top-1):(n-2),]) +
  geom_bar(aes(x=ingredient, y=total),
           stat="identity", fill='gray') +
  coord_flip() + 
  geom_text(aes(x=ingredient, y=total, label=total), vjust=0) +
  ggtitle(sprintf("Top %d ingredients", top))
#ggsave(sprintf('img/top_%d_ingredients.png', top), plot=bar_chart)
