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
    
#    dataSet[,subject := data.table(read.table(paste("subject_", type, ".txt", sep="")))]
    dataSet[,activity := data.table(read.table(paste("y_", type, ".txt", sep="")))]
}

# Read the features information in, this file contains a reasonable label for each
# column in the dataset.
featuresTable <- read.table("features.txt", stringsAsFactors=F)

# Assumption:  mean is ONLY mean, not meanFreq.  Use the features file to determine
# which columns we care about -- specifically mean and std in this implementation but note
# that the getFetaureColumnsOfType will accept any set of patterns and or them.
desiredColumns <- getFeatureColumnsOfType(featuresTable, c("mean\\(", "std\\("))

# Load the test data set and then add the train data set to it...
combinedData <- loadDataSet("test", desiredColumns)
combinedData <- rbind(combinedData, loadDataSet("train", desiredColumns))

# Set the column names in the data table to the column names indicated by the features
# file, note the activity column which was added from the y_(test|train).txt file is left
# unchanged.
setnames(combinedData, 1:66, featuresTable[desiredColumns,][[2]])