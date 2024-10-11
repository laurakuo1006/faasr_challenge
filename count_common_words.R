library(tidyverse)
library(tidytext)
library(dplyr)
library(tm)

count_common_words <- function(){
  faasr_get_file(remote_folder="reddit_texts", remote_file="texts.csv", local_file="texts.csv")
  readfile <- read.csv("texts.csv")
  contents <- data.frame(readfile)
  colnames(contents)[1] <- "reddit_post"
  corpus<-Corpus(VectorSource(contents$reddit_post))
  reddit_text_clean <- tm_map(corpus, removePunctuation)
  reddit_text_clean <- tm_map(reddit_text_clean, content_transformer(tolower))
  reddit_text_clean <- tm_map(reddit_text_clean, removeNumbers)
  reddit_text_clean <- tm_map(reddit_text_clean, stripWhitespace)
  reddit_text_clean <- tm_map(reddit_text_clean, removeWords, stopwords('english'))
  
  clean_reddit_df <- data.frame(text = sapply(reddit_text_clean, as.character), stringsAsFactors = FALSE)
  
  common_words <- clean_reddit_df %>% 
    unnest_tokens(word, text) %>% 
    count(word, sort = TRUE) %>%
    head(5)
  
  write.csv(common_words, file="common_words.csv", row.names = FALSE)
  
  faasr_put_file(local_file="common_words.csv", remote_folder="reddit_texts", remote_file="common_words.csv")
  log_msg <- paste0('Count common words test')
  faasr_log(log_msg)
}

