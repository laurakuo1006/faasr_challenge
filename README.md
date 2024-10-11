# Overview
This project uses Reddit's API to scrape and process posts based on a given keyword, storing the data in a MinIO S3 bucket for sentiment analysis and most common words. 

# Run RStudio on Docker conatiner
Run the following on your local machine's terminal (for Mac users).
```
docker pull --platform linux/amd64 rocker/rstudio
docker run --rm -ti --platform linux/amd64 -e ROOT=true -e PASSWORD=yourpassword -p 8787:8787 rocker/rstudio
```
Then, point your browser to http://localhost:8787 and log in (username is rstudio and use the password you provided in the command above)
# Install FaaSr package and required dependences
## Clone Git repository
Run the following on your RStudio Console to get necessary files
```
system('git clone https://github.com/laurakuo1006/faasr_challenge.git')
```
Click on faasr_challenge on the lower right window, then
In the drop-down menu for More, select "Set as Working Directory"

## Source the script that sets up FaaSr and dependences
Run the following command. Fair warning: it will take a few minutes to install all dependences:
```
source('rocker_setup_script')
```
# Configurations
## Configure the FaaSr secrets file with your GitHub token
Open the file named faasr_env in the editor. You need to enter your GitHub token here: replace the string "GITHUB_PERSONAL_ACCESS_TOKEN" with your GitHub token, and save this file. 

## Configure the FaaSr JSON simple workflow template with your GitHub username and specify which keyword you would like to analyze 
Open the file reddit-sentiment.json  and setup your GitHub username. Set keyword argument to the necessary functions: scrape_and_parse and combine_summary. (Default is "keyboard")


# Register and invoke the simple workflow with GitHub Actions

```
faasr_tutorial <- faasr(json_path="reddit-sentiment.json", env="faasr_env")
faasr_tutorial$register_workflow()
faasr_tutorial$invoke_workflow()
```

