# Load required libraries
library(shiny)
library(httr)
library(aws.s3)

minio_url <- "https://play.min.io"

# Load MinIO credentials from 'faasr_env' file
env_vars <- readLines("faasr_env")

for (line in env_vars) {
  without_quotes <- gsub('"', '', line)
  key_value <- strsplit(without_quotes, "=")[[1]]
  key <- key_value[1]
  value <- key_value[2]
  Sys.setenv(key = value)
}

Sys.setenv("AWS_ACCESS_KEY_ID" = Sys.getenv("My_Minio_Bucket_ACCESS_KEY"),
           "AWS_SECRET_ACCESS_KEY" = Sys.getenv("My_Minio_Bucket_SECRET_KEY"),
           "AWS_S3_ENDPOINT" = minio_url)


# Define UI
ui <- fluidPage(
  titlePanel("Reddit Sentiment Analysis Workflow"),
  sidebarLayout(
    sidebarPanel(
      textInput("keyword", "Enter Reddit Keyword:", value = ""),
      actionButton("analyze", "Analyze Sentiment")
    ),
    mainPanel(
      textOutput("status"),
      plotOutput("sentimentPlot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  print("enter server")
  observeEvent(input$analyze, {
    keyword <- input$keyword
    if (keyword != "") {
      print("keyword found")
      print(keyword)
      # Trigger FaaSr scraping function
      output$status <- renderText("Starting sentiment analysis workflow...")
      keyword_data <- data.frame(keyword = keyword)
      write.csv(keyword_data, "./keyword.csv")
      
      #status <- put_object(
      #  file = "keyword.csv",
      #  object = "keyword.csv",
      #  bucket = "laurafaasrchallenge",
      #  use_https = TRUE,
      #  url = minio_url
      #)
      
      faasr_put_file(local_file="keyword.csv", remote_folder="laurafaasrchallenge", remote_file="keyword.csv")
      
      # (Here you would add code to trigger the FaaSr scraping step)
      # Example: Store the keyword in MinIO and trigger the workflow
      
      # Show results after they are available
      #output$sentimentPlot <- renderPlot({
        # Retrieve sentiment analysis results from MinIO
        # (Load data from MinIO and plot)
      #})
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server)
