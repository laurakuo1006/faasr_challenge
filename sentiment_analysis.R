library(tidyverse)
library(tidytext)
library(forcats)
library(scales)

sentiment_analysis <- function(){
  faasr_get_file(remote_folder="laurafaasrchallenge", remote_file="texts.csv", local_file="texts.csv")
  readfile <- read.csv("texts.csv")
  contents <- data.frame(ID=1:nrow(readfile), readfile)
  colnames(contents)[2] <- "reddit_post"
  #give each word sentiment (positive, negative)
  #all neutral words will be elimiated
  tidy_contents <- contents %>% 
    unnest_tokens(word, reddit_post) %>%
    count(ID ,word) %>%
    inner_join(get_sentiments("bing"),by="word") %>%
    group_by(ID,sentiment) %>%
    summarize(total=sum(n)) %>%
    spread(sentiment,total) %>%
    replace(is.na(.), 0) %>%
    mutate(net_positve=positive-negative)
  
  neg_percentage <- nrow(tidy_contents[tidy_contents$net_positve < 0,]) / nrow(tidy_contents)
  pos_percentage <- nrow(tidy_contents[tidy_contents$net_positve > 0,]) / nrow(tidy_contents)
  
  summary <- data.frame(neg_percentage=neg_percentage, pos_percentage=pos_percentage)
  write.csv(summary, file="summary.csv", row.names = FALSE)
  
  faasr_put_file(local_file="summary.csv", remote_folder="reddit_texts", remote_file="summary.csv")
  log_msg <- paste0('Sentiment analysis test')
  faasr_log(log_msg)
}
