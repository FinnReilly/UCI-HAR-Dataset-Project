analysis<-function(){
  
  traintable<-read.table("~/UCI HAR Dataset/train/X_train.txt")
  testtable<-read.table("~/UCI HAR Dataset/test/X_test.txt")
  
  featvector<-c(1:6,41:46,81:86,121:126,161:166,201:202,214:215,227:228,240:241,253:254,266:271,345:350,424:429,503:504,516:517,529:530,542:543)
  workingtable<-rbind(traintable, testtable)
  workingtable<-workingtable[,featvector]
  
  trainAref<-read.table("~/UCI HAR Dataset/train/y_train.txt")
  testAref<-read.table("~/UCI HAR Dataset/test/y_test.txt")
  workingAref<-rbind(trainAref,testAref)
  activityset<-read.table("~/UCI HAR Dataset/activity_labels.txt")
  workingAref[,1]<-activityset[workingAref[,1],2]
  
  trainSref<-read.table("~/UCI HAR Dataset/train/subject_train.txt")
  testSref<-read.table("~/UCI HAR Dataset/test/subject_test.txt")
  workingSref<-rbind(trainSref,testSref)
  
  featureset<-read.table("~/UCI HAR Dataset/features.txt")[featvector,2]
  
  nsubjects<-length(unique(workingSref[,1]))
  nactivities<-nrow(activityset)
  nfeatures<-length(featureset)
  nrowsfintable<-nactivities*nsubjects*nfeatures ##calculates size of tidy output for next step
  
  ##creates empty table from predicted dimensions to avoid repeated rbind operations
  finalTable<-data.frame(num=rep(NA,nrowsfintable),txt=rep("",nrowsfintable),txt=rep("",nrowsfintable),num=rep(NA,nrowsfintable),stringsAsFactors=FALSE)
  colnames(finalTable)<-c("Subject","Activity","Measurement","Mean_of_Obs")
  
  workingtable<-cbind(workingSref[,1],workingAref[,1],workingtable)
  colnames(workingtable)<-c(c("Subject", "Activity"),as.character(featureset))
  ##write.table(workingtable, file="workingtable.txt")  ## used to test script in earlier stages
  
  ##create two empty 'subset' tables for intermediate stages in creating tidy output
  subsetL1rows<-nactivities*nfeatures
  subsetL1<-data.frame(num=rep(NA,subsetL1rows),txt=rep("",subsetL1rows),txt=rep("",subsetL1rows),num=rep(NA,subsetL1rows), stringsAsFactors=FALSE)
  subsetL2<-data.frame(num=rep(NA,nfeatures),txt=rep("",nfeatures),txt=rep("",nfeatures),num=rep(NA,nfeatures),stringsAsFactors=FALSE)
  
  ##iterate through subjects and activities, filling intermediate tables and writing in blocks to final
  ##output table.
  for(i in 1:nsubjects){
    workingsubset<-workingtable[workingtable$Subject==i,]
    for(i2 in 1:nactivities){
      nextworkingsubset<-workingsubset[workingsubset$Activity==activityset[i2,2],]
      for(i3 in 1:nfeatures){                                 ##adds individual rows for each feature to activity
        subsetL2[i3,1]<-i                                     ##for subject
        subsetL2[i3,2]<-as.character(activityset[i2,2])
        subsetL2[i3,3]<-as.character(featureset[i3])
        subsetL2[i3,4]<-mean(nextworkingsubset[,i3+2])
      }
      startbottom<-((i2-1)*nfeatures)+1
      endbottom<-i2*nfeatures
      subsetL1[startbottom:endbottom,1:4]<-subsetL2           ##block of feature rows for activity added to subject
    }
    starttop<-((i-1)*(nrow(subsetL1)))+1
    endtop<-i*nrow(subsetL1)
    finalTable[starttop:endtop,1:4]<-subsetL1                 ##block of activity data for subject added to output
  }
  write.table(finalTable, "finalTable.txt", row.name=FALSE)
}

analysis()