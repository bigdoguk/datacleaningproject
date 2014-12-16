
##1. load the datasets
train<-read.table("UCIDataset\\train\\X_train.txt") #7352 by 561 data frame, 7352 observations with 561 features (variables)
test<-read.table("UCIDataset\\test\\X_test.txt") #2947 by 561 data frame, 2947 observations with 561 features (variables)
feature<-read.table("UCIDataset\\features.txt") #561 by 2 data frame ( No|feature name)
activityLabel<-read.table("UCIDataset\\activity_labels.txt") # 6 by 2 data frame (No|activity name)
subjectTest<-read.table("UCIDataset\\test\\subject_test.txt") #2947 by 1 data frame (subject No in the range of 1 to 30)
subjectTrain<-read.table("UCIDataset\\train\\subject_train.txt") #7352 by 1 data frame (subject No in the range of 1 to 30)
activityTrain<-read.table("UCIDataset\\train\\y_train.txt") # 7352 by 1 data frame (activity label in the range of 1 to 6)
activityTest<-read.table("UCIDataset\\test\\y_test.txt") #2947 by 1 data frame (activity label in the range of 1 to 6)

## 2. merge training and testing data, and the corresponding subject and activity data. 
data<-rbind(train,test)
subject<-rbind(subjectTrain,subjectTest)
activity<-rbind(activityTrain,activityTest)

### 3. make a conversion, so that activity now uses descriptive activity names, but not "1", "2", "3", etc.
activityName<-activityLabel[,2][match(activity[,1],activityLabel[,1])]
### 4. add descriptive feature names to the merged data
names(data)<-feature[,2]


### 5. extract a subset with only the measurements on the mean and standard deviation for each measurement.
### In practice, this is done by extract features (columns) that contains "-mean()" or "-std()" in the feature names (column names)
subset<-data[,grepl("-mean\\(\\)|-std\\(\\)", names(data))]

### 6. add the activity and subject information (as columns) to the extracted subset
subset$activity<-activityName
subset$subject<-as.factor(subject[,1])

### 7. save the resulting subset
write.table(subset,file="subset.txt",row.name=FALSE)

### 8. compute average of each variable ("mean", and "std" related features) for each activity and each subject.
s<-split(subset,list(subset$activity,subset$subject))
z<- lapply(s,function(x)colMeans(x[,1:66]))

### 9. organize the output "z" as a data frame ("result") and save the resulting data frame
result<- data.frame(matrix(ncol = length(names(subset)), nrow = 0))
names(result)<-names(subset)
for (i in 1:length(z)){
x<-names(z[i])
y<-strsplit(x,"\\.")
act<-y[[1]][1]
subj<-y[[1]][2]
d<-data.frame(t(z[[i]]),act,subj)
names(d)<-names(subset)
result<-rbind(result,d)
}
write.table(result,file="average.txt",row.name=FALSE)

# if you want to load the dataset ("average.txt") into R, you can use the following command.
# note that argument check.name=FALSE will make sure the column names that contain
#brackets ("()") or hyphen ("-") will not be replaced with dot (".")
# x<-read.table("average.txt",header=TRUE,check.name=FALSE)