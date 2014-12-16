#Steps to run through the R code:

##General ideas: 

Merge the training and testing data, and add feature names (column names) to the merged dataset. 
Then, extract a subset with only "mean()" and "std()" related columns (features) from the merged dataset, and add this subset with subject and activity variables. Finally, split the subset with two levels (subject and activity) to generate splits for each subject and each activity, compute column means in each split and save the results.  


### 1. load datasets into R

* training data: X_train.txt, loaded as a 7352-by-561 data frame, 7352 observations with 561 features (variables)

* testing data: X_test.txt, loaded as a 2947-by-561 data frame, 2947 observations with 561 features (variables)

* feature set: features.txt, loaded as a 561-by-2 data frame, it corresponds to the features (variables) in the training and testing data.

* activity labels: activity_labels.txt, loaded as a 6-by-2 data frame. 

* subject information: this is about who perform the activity for each sample. 

subject_test.txt, this corresponds to the testing data, and loaded as a 2947 by 1 data frame;

subject_train.txt, this correspond to the training data, and loaded 7352 by 1 data frame

*  activity information: this is about the activity for each sample. 

    - y_train.txt, this corresponds to the training data, and loaded as a 7352 by 1 data frame

    - y_test.txt, this corresponds to the test data, and loaded as a 2947  by 1 data frame

### 2. merge the training data and test data, subject information, and activity information for both training and testing data.

data<-rbind(train,test)

subject<-rbind(subjectTrain,subjectTest)

activity<-rbind(activityTrain,activityTest)

### 3. make a conversion, so that activity now uses descriptive activity names, but not "1", "2", "3", etc.

For example, replace activity=1 as activity="WALKING" or activity="6" as activity="LAYING"

activityName<-activityLabel[,2][match(activity[,1],activityLabel[,1])]

### 4. add descriptive feature names to the merged data, by using the feature names listed in "feature.txt"

names(data)<-feature[,2]


### 5. extract a subset with only the measurements on the mean and standard deviation for each measurement.

In practice, this is done by extract features (columns) that contains "-mean()" or "-std()" in the feature names (column names)

subset<-data[,grepl("-mean\\(\\)|-std\\(\\)", names(data))]

### 6. add the activity and subject information (as columns) to the extracted subset, and save the resulting subset

So far, requirements 1,2,3,and4 listed in the assignment are done!

subset$activity<-activityName

subset$subject<-as.factor(subject[,1])

write.table(subset,file="subset.txt",row.name=FALSE)

### 7. compute average of each variable ("mean", and "std" related features) for each activity and each subject.

In implementation, splitting on two levels (subject and activity) are applied first, followed by the lapply function to compute column means. 

s<-split(subset,list(subset$activity,subset$subject))

z<- lapply(s,function(x)colMeans(x[,1:66]))

### 8. organize the output "z" as a data frame ("result") and save the resulting data frame as "average.txt".

This is the dataset generated from the requriment 5 in the assignment. 
 
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
