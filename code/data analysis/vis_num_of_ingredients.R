
library(ggplot2)

data <- read.csv('data/csv/cuisine_ingredient_num.csv')
colnames(data) <- c('recipe', 'count')

ingredients_number <-data$count

g<-ggplot(data, aes(ingredients_number, fill = cut(ingredients_number, 100))) +
  geom_bar(show.legend = FALSE) +
  scale_fill_discrete(h = c(240, 10)) +
  theme_minimal() 

ggsave(('img/all_recipes_num.png'), plot=g)

