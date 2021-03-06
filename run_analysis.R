#Load the data.table library, the data will be loaded in a data table
library("data.table")
library("reshape2")

#---------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------
# Script Functions
#---------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------

# Takes a list of strings and a vector of text patterns.  Iterate through the text patterns
# and identifies which strings in the list contain any of the text patterns as a substring.
# Returns a logical vector identifying the matching strings.
GetFeatureColumnsOfType <- function (columnLabelsTable, disjunctiveFilters) {
    logicalFilterVector <- vector(mode="logical", length=nrow(columnLabelsTable))
    for (filter in disjunctiveFilters) {
        logicalFilterVector <- grepl(filter, columnLabelsTable[[2]]) | logicalFilterVector
    }

    logicalFilterVector
}

# Takes a parameter indicating which 'type' of data is being loaded -- really an append
# on file names indicating test or training data, and returns a data.table retrieved from
# the file the type resolves to.  The table will be pared to include only the columns
# indicated by the desiredColumns vector.  Additionally the activity and subject for a given
# row will be bound into the table from the subject_ and y_ files.
LoadDataSet <- function(type, desiredColumns) {
    dataSet <- data.table(read.table(paste(type, "\\X_", type, ".txt", sep="")))
    
    dataSet <- dataSet[,desiredColumns,with=FALSE]
    
    dataSet[,subject := data.table(read.table(paste(type, "\\subject_", type, ".txt", sep="")))]
    dataSet[,activity := data.table(read.table(paste(type,"\\y_", type, ".txt", sep="")))]
}

# Shortcut function to retrieve the textual activity associated with a numerical activity
# code passed in.
GetActivityText <- function(activityLabelsTable, numericActivity) {
    activityLabelsTable[numericActivity,2]
}

# Take a factor, a data table, and an accumulation function.  Split the data table by the factor
# and then apply the accumulation function to the grouped results.  Return the outcome of the
# accumulation function + sapply
getFactoredAccumulation <- function(factor, dataTable, accumulationFuction) {
    sapply(split(dataTable, factor),accumulationFuction)
}

#---------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------
# Script workflow
#---------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------

# Read the features.txt file in, this file contains a reasonable label for each
# column in the dataset.
columnLabelsTable <- read.table("features.txt", stringsAsFactors=F)

# The activity_labels file contains the textual representations of the activities which
# were part of the study.
activityLabelsTable <- read.table("activity_labels.txt", stringsAsFactors=F)

# Assumption:  mean is ONLY mean, not meanFreq.  Use the column labels to determine
# which columns we care about -- specifically mean and std in this implementation but note
# that the getFetaureColumnsOfType will accept any set of patterns and logically 'or' them.
desiredColumns <- GetFeatureColumnsOfType(columnLabelsTable, c("mean\\(", "std\\("))

# Load the test data set
combinedData <- LoadDataSet("test", desiredColumns)
# Load the train data set as well and append it to the data table.
combinedData <- rbind(combinedData, LoadDataSet("train", desiredColumns))

# Set the column names in the data table to the column names indicated by the features
# file, the activity and subject columns which were added from the y_(test|train).txt file are left
# unchanged.
# The combined gsub calls are stripping the non-alphanumerical characters ("-()") from the column
# names and capitalizing "mean" and "std" to make for more readable column names.
# I PREFER TO LEAVE MOST OF THE ORIGINAL CAPITALIZATION IN PLACE.  Capitalization makes varibles that 
# have a compound name read more naturally.
readableNames <- gsub("std", "Std", gsub("mean", "Mean", gsub("[-(\\()]", "", columnLabelsTable[desiredColumns,][[2]])))
setnames(combinedData, 1:66, readableNames)

# Take the numeric activity code in the activity column and replace it with the more
# human-friendly textual code which the activity_labels file contains.
combinedData[,activity := GetActivityText(activityLabelsTable,activity)]

# Break the data down using melt into {identifier, label, value} tuples
moltenData <- melt(combinedData, id.vars=c("subject", "activity"))

# Now use reshape2 dcast to calculate aggregate values on the broken down data.
tidyData <- dcast(moltenData, subject + activity ~ variable, fun.aggregate=mean)

tidyData