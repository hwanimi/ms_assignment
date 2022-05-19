library(ggplot2)
library(scales)

cuisine <- 'vietnamese'
top <- 20
cuisine_csv <- read.csv(sprintf('data/csv/train/%s.csv', cuisine), header=TRUE ,sep=',', encoding = 'UTF-8')
drops <- c()
for(column in colnames(cuisine_csv[3:length(colnames(cuisine_csv))])) {
  cuisine_sum <- colSums(cuisine_csv[column])
  if(cuisine_sum == 0) {
    drops <- c(drops, column)
  }
}

# temp_df <- data.frame(used=c('used', 'not_used'),
#                       amount=c((dim(cuisine_csv)[[2]] - length(drops)), length(drops)))
# pie_chart <- ggplot(temp_df, aes(x="", y=amount,fill=used)) +
#             geom_bar(stat = "identity") +
#             coord_polar("y", start=0) +
#             geom_text(aes(y = amount/3 + c(0, cumsum(amount)[-length(amount)]),
#                       label = percent(amount/dim(cuisine_csv)[[2]])), size=5) +
#             geom_text(aes(y = amount/3 + c(0, cumsum(amount)[-length(amount)]),
#                       label = sprintf("(%d)", amount)), size=5, vjust=2) +
#             ggtitle(sprintf("%s ingredients use rate", cuisine))
# ggsave(sprintf('img/%s_use_ingredient_amount.png', cuisine), plot=pie_chart)

used_df <- cuisine_csv[ , !(colnames(cuisine_csv) %in% drops)]
# n <- length(colnames(used_df))
# write(colnames(used_df)[3:n], sprintf('data/txt/%s_ingredients.txt', cuisine))

# recipes_ingredients_num <- c()
# for(i in 1:dim(used_df)[1]) {
#   recipes_ingredients_num <- c(recipes_ingredients_num, (rowSums(used_df[i,][3:n])[[1]]))
# }
# dnorm_recipes_ingredients_num <- dnorm(recipes_ingredients_num, mean=mean(recipes_ingredients_num), sd=sd(recipes_ingredients_num))
# dnorm_chart <- ggplot(data.frame(x=recipes_ingredients_num, y=dnorm_recipes_ingredients_num), aes(x=x, y=y)) + geom_line()
#ggsave(sprintf('img/%s_dnorm.png', cuisine), plot=dnorm_chart)

# used_in_df <- data.frame(ingredient = character(n-2), total = numeric(n-2), stringsAsFactors = FALSE)
# for(i in 3:n) {
#   column <- colnames(used_df)[[i]]
#   used_in_df$ingredient[i-2] <- column
#   used_in_df$total[i-2] <- colSums(used_df[column])
# }

# used_in_df <- used_in_df[order(used_in_df$total, decreasing = FALSE),]
# used_in_df$ingredient <- factor(used_in_df$ingredient, levels=unique(used_in_df$ingredient))
# bar_chart <- ggplot(used_in_df[(n-top-1):(n-2),]) +
#   geom_bar(aes(x=ingredient, y=total),
#            stat="identity", fill='gray') +
#   coord_flip() + 
#   geom_text(aes(x=ingredient, y=total, label=total), vjust=0) +
#   ggtitle(sprintf("Top %d ingredients used by %s", top, cuisine))
#ggsave(sprintf('img/%s_top_%d_ingredients.png', cuisine, top), plot=bar_chart)

special <- scan(sprintf('data/txt/%s_special_ingredients.txt', cuisine), character())
special_df <- used_df[ , (colnames(used_df) %in% special)]
n <- length(colnames(special_df))
special_in_df <- data.frame(ingredient = character(n), total = numeric(n), stringsAsFactors = FALSE)
for(i in 1:n) {
  column <- colnames(special_df)[[i]]
  special_in_df$ingredient[i] <- column
  special_in_df$total[i] <- colSums(used_df[column])
}
# write.table(special_in_df,
#             sprintf('data/csv/special/%s_special_ingredients_used_times.csv', cuisine),
#             row.names=FALSE,
#             col.names=FALSE,
#             quote=FALSE,
#             sep=',')
