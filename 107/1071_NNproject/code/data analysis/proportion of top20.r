# 計算Top 20 ingredients 在每個cuisine中的佔比(%)，
# 若在每種cuisine中佔比差不多，則可視為非重要feature而排除

# 針對一個ingredient, 看所有cuisine佔比
# garlic golves 小一顆
library(ggplot2)

ingredient_list <-c("salt", "onions", "olive oil", "water", "garlic", "sugar", "garlic cloves",
              "butter" , "ground black pepper", "all purpose flour","pepper",
              "vegetable oil", "eggs", "soy sauce", "kosher salt", "green onions",
              "tomatoes", "large eggs", "carrots", "unsalted butter")

cuisine_list <- c('brazilian', 'british', 'cajun_creole', 'chinese', 'filipino', 'french', 'greek', 'indian', 'irish', 'italian', 'jamaican', 'japanese', 'korean', 'mexican', 'moroccan', 'russian', 'southern_us', 'spanish', 'thai', 'vietnamese')
cuisines <- list()
for(cuisine in cuisine_list) {
  cuisines[[cuisine]] <- read.csv(sprintf('data/csv/train/%s.csv', cuisine), header=TRUE, sep=',', encoding='UTF-8')
}

## proportion table for top20ingredient*allcuisine
proportion <-matrix(1:400,20,20,byrow=F)
for(i in 1:length(ingredient_list)) {
  ingredient <- gsub(' ', '.', ingredient_list[i])
  #print(ingredient_list[i])
  for(j in 1:length(cuisine_list)) {
    cuisine<-cuisine_list[j]
    n<-dim(cuisines[[cuisine]])[[1]]
    s<-sum(cuisines[[cuisine]][[ingredient]])
    #print(s/n)
    proportion[[i,j]]<-s/n
  }
  #print("==========")
}


##
proportion_data<-data.frame(proportion, row.names = ingredient_list)
colnames(proportion_data)=cuisine_list

##plot
for(i in 1:20) {
    p <- ggplot(proportion_data, aes(x=colnames(proportion_data), y=as.list.data.frame(proportion_data[i,]))) +
         geom_bar(stat='identity') +
         coord_flip(ylim=c(0,1)) +
         ylab('use rate') +
         xlab('cuisine')
    ggsave(sprintf('img/proportion/%s.png', row.names(proportion_data[i,])), plot=p)
}

##save img
#ggsave('./img/proportion/salt.png', plot=p)


