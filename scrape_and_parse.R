library(RedditExtractoR)
library(dplyr) 
options(HTTPUserAgent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36")

scrape_and_parse <- function(keyword) {
  threads <- find_thread_urls(keywords = keyword, sort_by = "relevance", period = "hour")
  thread_content <- get_thread_content(threads$url[1:5])
  text_data <- thread_content$threads %>%
    filter(!is.na(text) & text != "") %>%
    select(text)
  
  comment_data <- thread_content$comments %>%
    filter(!is.na(comment) & comment != "") %>%
    select(comment)
  
  all_texts = c(text_data, comment_data)
  texts_df <- data.frame(all_texts <- unlist(all_texts))
  
  write.csv(texts_df, file="texts.csv", row.names = FALSE)
  
  faasr_put_file(local_file="texts.csv", remote_folder="reddit_texts", remote_file="texts.csv")
  log_msg <- paste0('Function create_sample_data finished; outputs written to folder ', folder, ' in default S3 bucket')
  faasr_log(log_msg)
}
