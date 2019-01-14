library(ggplot2)

data <- read.csv('data/csv/cuisine_ingredient_num.csv', header=TRUE, quote='')

for(cuisine in levels(data$cuisine)) {
  temp <- data[data$cuisine == cuisine, ]
  ccd <- ggplot(temp,aes(x=temp$ingredients_count,color=temp$cuisine)) +
         geom_step(aes(y=..y..), stat="ecdf") +
         labs(x = 'ingredients', color = "cuisine") +
         ggtitle(sprintf("%s Cumulative Distribution", cuisine))
  ggsave(sprintf('img/%s_ccd.png', cuisine), plot=ccd)
}
