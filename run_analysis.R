library(dplyr)
##setwd("C:\\Coursera\\3) Getting and Cleaning Data\\Week 4\\Project")
##read train data
train <- read.csv(".\\UCI HAR Dataset\\train\\X_train.txt", header =  FALSE, sep = "")
activity <- readLines(".\\UCI HAR Dataset\\train\\y_train.txt")
subject <- readLines(".\\UCI HAR Dataset\\train\\subject_train.txt")
train <- cbind(train,activity,subject)

##read test data
test <- read.csv(".\\UCI HAR Dataset\\test\\X_test.txt", header =  FALSE, sep = "")
activity <- readLines(".\\UCI HAR Dataset\\test\\y_test.txt")
subject <- readLines(".\\UCI HAR Dataset\\test\\subject_test.txt")
test <- cbind(test,activity,subject)

##merge data
merged <- rbind(train,test)
col_name <-  readLines(".\\UCI HAR Dataset\\features.txt")
col_name <- c(col_name,"act_id","subject")

##name headers
names(merged) <- col_name

##select mean and standard deviation fields
mean_std_col <- grep("[Mm][Ee][Aa][Nn]\\(\\)|[Ss][Tt][Dd]\\(\\)",col_name,value = TRUE)
tidy_data<-select(merged,c(mean_std_col,"act_id","subject"))

##rename fields as descriptive activity names 
names(tidy_data) <- gsub("-","_",names(tidy_data))
names(tidy_data) <- gsub("\\d","",names(tidy_data))
names(tidy_data) <- gsub("\\s","",names(tidy_data))
names(tidy_data) <- gsub("\\(\\)","",names(tidy_data))
names(tidy_data) <- sub("^t","Time_",names(tidy_data))
names(tidy_data) <- sub("^f","Frequence_",names(tidy_data))

##read activity label table
activity <- read.csv(".\\UCI HAR Dataset\\activity_labels.txt", header =  FALSE, sep = "", col.names = c("act_id","act_label"))

##join activity label table and the main data set
tidy_sub_set <- merge(tidy_data, activity, by = "act_id")

##write merged data set into the file
write.table(tidy_sub_set,"merged_data.txt",row.names = FALSE)

##save summarised results into independent data set 
final_result <- tidy_sub_set %>%
  group_by(act_id,act_label,subject) %>%
  summarise_all(mean)

##write final data set into the file
write.table(final_result,"independent_tidy_data.txt",row.names = FALSE)