library(httr)
library(jsonlite)

scrape_and_parse <- function(keyword){
  client_id <- "isQm_ZT-BchuVAk_bxQXOQ"
  client_secret <- "r5cA2ybl1ywrzfw5PT9BIeRHuOSNkg"
  response <- POST("https://www.reddit.com/api/v1/access_token",
                   authenticate("isQm_ZT-BchuVAk_bxQXOQ", "r5cA2ybl1ywrzfw5PT9BIeRHuOSNkg"),
                   user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"),
                   body = list(grant_type="password", 
                               username="No_Abrocoma5070", 
                               password="03141006Aa!!"))
  
  access_token_json <- rawToChar(response$content)
  access_token_content <- fromJSON(access_token_json)
  access_token <- access_token_content$access_token
  
  url <- "https://oauth.reddit.com/search"
  authorization_bearer <- paste("Bearer ", access_token, sep="")
  result <- GET(url, 
                user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"), 
                add_headers(Authorization = authorization_bearer))
  
  query_params <- list(
    limit = 100,
    q = keyword
  )
  
  response <- GET(url, query = query_params, add_headers(Authorization = authorization_bearer, `User-Agent` = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"))
  
  response_json <- rawToChar(response$content)
  response_content <- fromJSON(response_json)
  
  text <- response_content$data$children$data$selftext
  texts_df <- data.frame(text <- unlist(text))
  write.csv(texts_df, file="texts.csv", row.names = FALSE)
  
  faasr_put_file(local_file="texts.csv", remote_folder="reddit_texts", remote_file="texts.csv")
  log_msg <- paste0('Function test')
  faasr_log(log_msg)
}

