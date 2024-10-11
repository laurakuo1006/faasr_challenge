combine_summary <- function(keyword) {
  faasr_get_file(remote_folder="reddit_texts", remote_file="common_words.csv", local_file="common_words.csv")
  faasr_get_file(remote_folder="reddit_texts", remote_file="sentiment_summary.csv", local_file="sentiment_summary.csv")
  
  common_words <- read.csv("common_words.csv")
  sentiment_summary <- read.csv("sentiment_summary.csv")
  
  neg_percentage <- round(sentiment_summary$neg_percentage * 100)
  pos_percentage <- round(sentiment_summary$pos_percentage * 100)
  
  summary<-file("summary.txt")
  
  neg_text <- paste0(neg_percentage, "% of the posts containing ", keyword, " are NEGATIVE")
  cat(neg_text, file="summary.txt", sep="\n")
  pos_text <- paste0(pos_percentage, "% of the posts containing ", keyword, " are POSITIVE")
  cat(pos_text, file="summary.txt", sep="\n", append=TRUE)
  
  cat("\n", file="summary.txt", append=TRUE)
  cat("Top 5 Most Frequent Words:", file="summary.txt", sep="\n", append=TRUE)
  for (i in 1:5) {
    cat(paste0(i,". ", common_words$word[i]), file="summary.txt", sep="\n", append=TRUE)
  }
  
  faasr_put_file(local_file="summary.txt", remote_folder="reddit_texts", remote_file="combined_summary.txt")
  log_msg <- paste0('Combine summary test')
  faasr_log(log_msg)
  
}
