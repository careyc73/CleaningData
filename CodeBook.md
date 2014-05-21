# Original data source
The data set presented in this process is derived from another data set and so
the codebook from that data set is heavily used to describe the variables
returned by the run_analysis.R script.

The description for data collection from the original data source follows:

## Original descriptions
The features selected for this database come from the accelerometer and 
gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals
(prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then 
they were filtered using a median filter and a 3rd order low pass Butterworth
filter with a corner frequency of 20 Hz to remove noise. Similarly, the 
acceleration signal was then separated into body and gravity acceleration
signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth
filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in
time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the
magnitude of these three-dimensional signals were calculated using the 
Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag,
tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals 
producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, 
fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain 
signals). 

These signals were used to estimate variables of the feature vector for each
pattern: '-XYZ' is used to denote 3-axial signals in the X, Y and Z 
directions.

## Notes regarding transformations of data from the original data set
The data used in this script are a subset of the data from the raw sets,
specifically the variables of type "mean" and "std" have been retained and the
rest discarded.

Nonetheless there are some additional items to note of the data set returned
by this script.

All variables from the original set are real numbers, ie., decimal values,
save the following two.

	Subject - This variable records the individual wearing the devices when
	recordings were performed.  The variable is an integral value between 1 and
	30 preserving the anonymity of the test individual.
	
	Activity - Originally a numerical code from 1 to 6 the variable in the
	data set produced by run_analysis has been transformed into the readable
	text indicated by the activity_labels file in the original data set.
	
# Transformation of original data
The data table returned by run_analysis contains, as noted, only a subset of
the variables in the original data set.

Additionally the values returned are an aggregate of the original values.

Specifically the observations from the original data set constitute individual
samples of a given variable for a given {subject, activity} pair.  The rows
in the data set returned by run_analysis are the mean of all samples for each
{subject, activity} pair.

For instance in the original data set there may be 8 samples of all the
variables for {subject "1", activity "walking"}.  The data set returned by
run_analysis contains one row for {subject "1", activity "walking"}.  This
row contains the mean value for each of the retained variables.