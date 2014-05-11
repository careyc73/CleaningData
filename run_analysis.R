library("data.table")

getFeatureColumnsOfType <- function (featuresTable, disjunctiveFilters) {
    filterVector <- vector(mode="logical", length=nrow(featuresTable))
    for (filter in disjunctiveFilters) {
        filterVector <- grepl(filter, featuresTable[[2]]) | filterVector
    }

    filterVector
}

loadDataSet <- function(type, desiredColumns) {
    dataSet <- data.table(read.table(paste("X_", type, ".txt", sep="")))
    
    dataSet <- dataSet[,desiredColumns,with=FALSE]
    
    dataSet[,subject := data.table(read.table(paste("subject_", type, ".txt", sep="")))]
    dataSet[,activity := data.table(read.table(paste("y_", type, ".txt", sep="")))]
}

featuresTable <- read.table("features.txt")

# Assumption:  mean is ONLY mean, not meanFreq
desiredColumns <- getFeatureColumnsOfType(featuresTable, c("mean()", "std()"))

combinedData <- loadDataSet("test", desiredColumns)
combinedData <- rbind(combinedData, loadDataSet("train", desiredColumns))
