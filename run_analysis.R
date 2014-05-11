library("data.table")

loadDataSet <- function(type) {
    dataSet <- data.table(read.table(paste("X_", type, ".txt", sep="")))
    
    dataSet[,subject := data.table(read.table(paste("subject_", type, ".txt", sep="")))]
    dataSet[,activity := data.table(read.table(paste("y_", type, ".txt", sep="")))]
}

combinedData <- loadDataSet("test")
combinedData <- rbind(combinedData, loadDataSet("train"))
