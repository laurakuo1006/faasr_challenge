# Overview
This project uses Reddit's API to scrape and process posts based on a given keyword, storing the data in a MinIO S3 bucket for sentiment analysis and most common words. 

#Run RStudio on Docker conatiner
Run the following on your local machine's terminal (for Mac users).
```
docker pull --platform linux/amd64 rocker/rstudio
docker run --rm -ti --platform linux/amd64 -e ROOT=true -e PASSWORD=yourpassword -p 8787:8787 rocker/rstudio
```
Then, point your browser to http://localhost:8787 and log in (username is rstudio and use the password you provided in the command above)

#Clone Git repository
```
system('git clone https://github.com/laurakuo1006/faasr_challenge.git')
```


