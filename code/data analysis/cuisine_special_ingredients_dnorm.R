library(ggplot2)

cuisines <- c('brazilian', 'british', 'cajun_creole', 'chinese', 'filipino', 'french', 'greek', 'indian', 'irish', 'italian', 'jamaican', 'japanese', 'korean', 'mexican', 'moroccan', 'russian', 'southern_us', 'spanish', 'thai', 'vietnamese')

for(cuisine in cuisines) {
  data <- read.csv(sprintf('data/csv/special/%s_special_ingredients_used_times.csv', cuisine), header=FALSE, quote='')
  colnames(data) <- c('ingredient', 'count')
  dnorm_special_ingredients <- dnorm(data$count, mean=mean(data$count), sd=sd(data$count))
  dnorm_chart <- ggplot(data.frame(x=data$count, y=dnorm_special_ingredients), aes(x=x, y=y)) + geom_line()
  ggsave(sprintf('img/%s_speical_dnorm.png', cuisine), plot=dnorm_chart)
}
