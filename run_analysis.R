
    # Merge training and testing files
    train = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
    train[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
    train[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)
    
    test = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
    test[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
    test[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)
    
    activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
    
    # Gather features and clarify the names
    features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
    features[,2] = gsub('-mean', 'Mean', features[,2])
    features[,2] = gsub('-std', 'Std', features[,2])
    features[,2] = gsub('[-()]', '', features[,2])
    
    # Merge train and test files
    mergedData = rbind(train, test)
    
    # Grab mean and standard deviation data
    meanSTD <- grep(".*Mean.*|.*Std.*", features[,2])
    # Simplify features table
    features <- features[meanSTD,]
    # Add the subject and activity columns
    meanSTD <- c(meanSTD, 562, 563)
    # Remove unnessecary columns from mergedData
    mergedData <- mergedData[,meanSTD]
    # Add clarified column names
    colnames(mergedData) <- c(features$V2, "Activity", "Subject")
    colnames(mergedData) <- tolower(colnames(mergedData))
    
    currentActivity = 1
    for (currentActivityLabel in activityLabels$V2) {
      mergedData$activity <- gsub(currentActivity, currentActivityLabel, mergedData$activity)
      currentActivity <- currentActivity + 1
    }
    
    mergedData$activity <- as.factor(mergedData$activity)
    mergedData$subject <- as.factor(mergedData$subject)
    
    tidyTable = aggregate(mergedData, by=list(activity = mergedData$activity, subject=mergedData$subject), mean)
    # Remove the subject and activity column
    tidyTable[,90] = NULL
    tidyTable[,89] = NULL
    write.table(tidyTable, "tidyTable.txt", sep="\t", row.name=FALSE)
