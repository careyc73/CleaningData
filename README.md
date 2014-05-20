-------------------------------------------------------------------------------
# General
-------------------------------------------------------------------------------
The R script run_analysis.R transforms data describing the forces acting upon
wearable devices into a more friendly format in the following ways:

	1) Labels have been simplified for ease of reading and descriptive clarity
	2) A numerical activity code has been replaced with the textual description
	   of the activity.
	3) The data, partitioned between "test" and "training" data sets has been
	   recombined to allow for faster appreciation of data trends.
	4) Many of the original variables have been removed.  Though the script
	   hard codes which columns remain (more under assumptions) the removal
       is performed by a parametized function such that selection of
       different functions would be straightforward.
    5) Finally the script outputs a data set (in the form of a data table)
	   containing the mean value for each variable grouped by activity and
	   test subject.  Ie., the mean value for each sample of "Walking" taken
	   on subject #1.
	  
-------------------------------------------------------------------------------
Assumptions
-------------------------------------------------------------------------------
Location of Files:
The script assumes that the directory structure contained within the
UCI HAR Dataset has been preserved.  In other words the following file
structure is assumed:

	activityLabels.txt
	features.txt
	features_info.txt
	test
		X_test.txt
		subest_test.txt
	train
		X_train.txt
		subject_train.txt
	
Only files utilized by the script are shown.  The script assumes it is
running from the directory containing 'activityLabels.txt'.

Culling of Variables:
A subset of the original data is processed by the script.  Variables containing
the text 'mean()' and 'std()' have been retained, the rest have been removed.
Note this does mean that variables named 'meanFreq()' have been removed.

-------------------------------------------------------------------------------
Script Operation and Layout
-------------------------------------------------------------------------------
The script is laid out in two distinct sections.  The beginning of the script
contains functions utilized by the main body of the script.  The following
methods have been defined:

	Utility Functions
	---------------------------------------------------------------------------
	getFeatureColumnsOfType: 
	This function takes a vector of column labels (strings) and a second vector
	of strings.  It returns a logical vector indicating which labels matched
	positive against any of the strings in the second vector.  I.e., this 
	method "Or's" against the 2nd string vector.  Modifying the second vector
	argument would quickly and easily alter the	behavior of the overall script
	to summarize a different set of columns.
	
	loadDataSet:
	Given a parameter indicating the type of data to load (test or train) this
	method will read the appropriate file into a data table (eg., X_train.txt).
	The method additionally takes a vector of logicals indicating of the
	columns read in whether or not they should be a part of the returned data
	table.  The assumption is that the logical returned by 
	getFeatureColumnsOfType will be passed along as the argument.  Finally this
	function will read in the subject_(train|test) and y_(train|test) files and
	attach the rows in those files to the returned data table.  This attaches
	activity and subject information to the returned data table.
	
	getActivityText:
	This simple method takes a table of activity labels and a numerical index.
	It returns the textual activity represented by that row in the activity
	labels table.
	
	General script workflow
	---------------------------------------------------------------------------
	The script performs a fairly straight forward sequence of operations.
	
	1) The column labels are read in from the features.txt file and stored in a
	data table.
	2) The activity labels are read in from the activity_labels.txt file and
	stored in a data table.
	3) The logical vector indicating the columns the script wishes to process is
	determined using getFeatureColumnsOfType.  "mean()" and "std()" are passed
	in as the textual filters to match against.
	4) The test data is read in using loadDataSet, the train data set is then
	read in using loadDataSet as well.  "rbind" pastes the two data tables
	together.
	5) A series of gsub commands takes the column labels read in at step 1 and
	transforms them for improved read ability.  
		- Parens ('()') are removed.  
		- Dashes ('-') are removed.
		- The lower case 'm' in 'mean' and 's' in 'std' are moved to upper case 
		(to produce 'Mean' for example.
		Example:  'tBodyAcc-mean()-X' will be transformed into 'tBodyAccMeanX'
		This format preserves the textual "layout" of the variable without some
		of the unnecessary visual clutter.
	6) The column names in the combined data set returned at step 4 are set to
	the names produced by step 5.
	7) The data table ':=' functionality is used to quickly transform the
	numerical activity codes into their textual equivalent in the data table
	returned at step 4.
	8) 'melt' and 'dcast' from the reshape2 package are used in succession to
	concisely create a data table consisting of the mean value for each
	variable grouped by the {subject, activity} as an identifier.  This
	data table is returned as the result of the script.