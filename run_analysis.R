# Assignment - Getting and Cleaning Data 

#Downloading the zip file
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
newfile <- "UCI_HAR_dataset.zip"
if (!file.exists(newfile)){
  download.file(url,"UCI_HAR_dataset.zip")
}
#unzip the file
unzip(newfile)

