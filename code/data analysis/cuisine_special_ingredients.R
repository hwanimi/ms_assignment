cuisines <- c('brazilian', 'british', 'cajun_creole', 'chinese', 'filipino', 'french', 'greek', 'indian', 'irish', 'italian', 'jamaican', 'japanese', 'korean', 'mexican', 'moroccan', 'russian', 'southern_us', 'spanish', 'thai', 'vietnamese')
ingredient_list <- list()
for(cuisine in cuisines) {
  b <- scan(sprintf('data/txt/%s_ingredients.txt', cuisine), character())
  print(length(b))
  ingredient_list[[cuisine]] <- b
}

for(cuisine in cuisines) {
  others <- setdiff(cuisines, cuisine)
  special <- ingredient_list[[cuisine]]
  for(other in others) {
    special <- setdiff(special, ingredient_list[[other]])
  }
  write(special, sprintf('data/txt/%s_special_ingredients.txt', cuisine))
}
