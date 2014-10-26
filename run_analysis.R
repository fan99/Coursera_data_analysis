
# 1.Merges the training and the test sets to create one data set.
test<-read.table('./UCI HAR Dataset/test/X_test.txt', header=FALSE)
train<-read.table('./UCI HAR Dataset/train/X_train.txt', header=FALSE)
features<-read.table('./UCI HAR Dataset/features.txt', header=FALSE, row.names=NULL)
features<-as.vector(features[,2])
measures<-rbind(test,train)

subject_test<-as.numeric(unlist(read.table('./UCI HAR Dataset/test/subject_test.txt', header=FALSE)))
subject_train<-as.numeric(unlist(read.table('./UCI HAR Dataset/train/subject_train.txt', header=FALSE)))
ytest<-read.table('./UCI HAR Dataset/test/Y_test.txt', header=FALSE)
ytrain<-read.table('./UCI HAR Dataset/train/Y_train.txt', header=FALSE)
activity<-unlist(rbind(ytest,ytrain))
activity_labels<-read.table('./UCI HAR Dataset/activity_labels.txt', header=FALSE, row.names=NULL)
subject<-c(subject_test,subject_train)
measures<-cbind(measures,subject,activity)
# 2.Extracts only the measurements on the mean and standard deviation for each measurement.
# I only consider the entries that include mean() and std() at the end.
measures<-measures[,unique(c(grep('mean()',features),grep('std()',features)))]
# 3.Uses descriptive activity names to name the activities in the data set
measures<-cbind(measures,subject,activity)
for (i in 1:nrow(activity_labels)){
  measures[which(activity==activity_labels[i,1]),length(measures)]<-as.character(activity_labels[i,2])
}
# 4.Appropriately labels the data set with descriptive variable names.
features<-features[unique(c(grep('mean()',features),grep('std()',features)))]
features<-gsub("-","",features)
features<-gsub("\\(","",features)
features<-gsub("\\)","",features)
colnames(measures)<-c(features, 'subjects', 'activities')

# 5.From the data set in step 4, creates a second, independent tidy data set with
# the average of each variable for each activity and each subject.
table2_activity<-aggregate(x=measures[,1:(length(measures)-2)], by=list(factor(measures$activities)), "mean")
table2_subject<-aggregate(x=measures[,1:(length(measures)-2)], by=list(factor(measures$subjects)), FUN="mean")
table2<-rbind(table2_activity, table2_subject)
table2<-table2[,-1]
people<-as.vector(NULL)
for(i in 1:length(levels(factor(measures$subjects)))){
  people[i]=sprintf("subject_%d", i)
}
colnames(table2)=paste(features, " average")
rownames(table2)<-c(as.character(activity_labels[,2]), people)
write.table(table2, row.names=FALSE, file='tidy_set.txt')