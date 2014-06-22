## a function that takes the data a folder in directory as named and writes out a csv file
## of tidied data.
## In this context, tidied means that data from several files is read in and merged into a single 
## data.frame named "data". From this frame, columns that measure a  mean or std are selected
## and the mean for each subject, activity pair is computed and stored. 
## The stored data is written out to "tidiedData.csv" 
tidyDataOne <- function(directory) {
	## first move to the directory that contains the data
	## Save current directory so we can return there at the end
	currWD <- getwd()
	setwd(directory)
	## then read in the data
	## the first three are the test data
	dtX_test<- read.table("./UCI HAR Dataset/test/X_test.txt")
	dty_test<- read.table("./UCI HAR Dataset/test/y_test.txt")
	dtsubject_test<- read.table("./UCI HAR Dataset/test/subject_test.txt")
	## merge these columnwise subject, activity, results 
	dt_test <- cbind(dtsubject_test, dty_test, dtX_test)
	## the next three are the training data
	dtX_train<- read.table("./UCI HAR Dataset/train/X_train.txt")
	dty_train<- read.table("./UCI HAR Dataset/train/y_train.txt")
	dtsubject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
	## then merge these columnwise subject, activity, results 
	dt_train <- cbind(dtsubject_train, dty_train, dtX_train)
	
	## read in feature names 
	features <- read.table("./UCI HAR Dataset/features.txt")
	
	## merge row-wise the test and traing data
	data <- rbind(dt_test, dt_train)
	
	## extract the names of the columns we want, ie those with "mean" or "std"
	names(data) <- c("subject", "activity", as.vector(features[,2]))
	preNames <- data.frame(as.vector(features[,2]))
	names(preNames) <- c("name")
	msNames.df <- subset(preNames, grepl("mean", name) | grepl("std", name))
	msNames <- as.vector(msNames.df[["name"]])
	## store names of data set we wish to use
	useNames <- c("subject", "activity", msNames)
	## select out the columns from the data that we will compute on
	useData <- subset(data, select = useNames)

	## flag for creation of output store
	start <- TRUE

	max_sub <- max(useData[,1])		## approx number of subjects
	max_act <- max(useData[,2])		## approx number of activities
	subjects <- 1:max_sub			## for looping
	activities <- 1:max_act
	
	for (i in subjects) {
	    for (j in activities) {
			## for each subject, activity pair extract the data.frame that refers only to that pair and compute means of all columns
	        pdt_ij <- subset(useData, subject==i, select = c("activity", useNames))
			dt_ij <- subset(pdt_ij, activity==j, select = useNames)
			if (nrow(dt_ij) > 0) {	## test that we have a non-trivial row, no point in taking a mean of something that doesn't exist
				## DEBUG CODE: print("nrow greater than zero")
		        rij <- list(subject=i, activity=j)	## store for this subject, activity. Initialised with current pair
				for (k in names(dt_ij)){					## compute and store all means 
		            rij[k] <- mean(dt_ij[[k]])
				}
	        
				if (start == TRUE) {	## create the final store on the first round
					store <- data.frame(rij)	## store row of means
					start <- FALSE
					names(store) <- useNames	## make sure we have the same names 
				} else {
					store <- rbind(store, rij)	## store the row of means
				}
			}
	    }
	}

	write.csv(store, "tidiedData.csv")	## write out the tidied data set
	setwd(currWD)
}