
library(ggplot2)

d <- read.csv('data/csv/cuisine.csv')
d$name <- rownames(d)

p <- ggplot() + geom_bar(data=d, aes(x=reorder(cuisine,d$count), y=count), stat='identity') + coord_flip()
p <- p + labs(y='count', x='cuisines') + theme(plot.title = element_text(size=18))
g<-p + geom_bar(data=d[d$cuisine=='italian', ], aes(x=cuisine, y=count), fill='#5CBED2', stat='identity') +theme_minimal()

ggsave(('img/cuisine_num.png'), plot=g)
