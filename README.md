# GetCleanDataAssignment
Processed Human Activity Dataset
README document for Human Activity Recognition Using Smartphones Dataset
 Processing

The aim is to clean a dataset:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

for easier downstream analysis. 

The data are from the following study...
==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Universit� degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================


The data describe the movements of a person as measured by gyroscope and accelerometer from a smartphone. Each subject performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone on their waist. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 
Technical details of data collection can be found within the original dataset's README document. 


For each record they provide:
======================================
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.


Specific aims for the data set are:

====================================== 
1. Merge training and test datasets.  
2. Extract mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set. 
4. Appropriately labels the data set with descriptive variable names.
5. From step 4 dataset, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
	“Report mean for each activity for all subjects, “total”, and each subject”. 









Original dataset files to be included with reasoning for tidying decisions :
=========================================

- 'features.txt': List of all measurements.
	Used to name columns in measurement data sets
	Columns with names containing “mean” and “std” will be collected. 
	As there are no corresponding std values for “meanFreq” and “gravity”, these data will be removed. 

	
- 'activity_labels.txt': Links the numeric labels with their activity name.

- 'train/X_train.txt': Training measurement data set.
 
	Some variables will include two factors such as tBodyAcc-mean() and X, Y, or Z which goes against basic tidy rules. However, combining direction data X, Y, and Z would introduce many NAs for other observations which would greatly complicate downstream analysis. More detailed thoughts on this decision can be found here: https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/. Therefore, these dual variables labels were kept intact and the resulting processed dataset was left rather wide. 
	Non-letter symbols such as -, _, and (), were removed from data labels for improved readability and easier downstream processing. 

- 'train/y_train.txt': Numeric ids of activity. They will be converted to the more descriptive activity labels, given a header “activity”, and bound to train data. 


- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample.

Files similar to the three train files above exist for the test data set and will be handled similarly. Specific aims 1-4 will be handled in non-sequential order to best ensure the order of the train and test data sets are maintained. 

-Inertial signals data do not contain the mean and std data required to meet aims and will not be included. 


The dataset includes the following files:
=========================================

- 'README.txt'

- 'movement_mean_std.csv': Summary file of mean and std measurements with subject and activity included. 

- 'movement_mean_by_activity_subject.csv': Summary file of means of measurements reported in 'movement_mean_std.csv' for each activity. Each activity is reported for the total of all subjects, “total”, and for each individual subject. 


Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.
- For more information about this dataset contact: activityrecognition@smartlab.ws

License:
========
Use of this dataset in is acknowledged by referencing the following publication 
	Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012. 

