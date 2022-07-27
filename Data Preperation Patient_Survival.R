# Patient_Survival_Prediction


# Data Preparation

### Basic understanding of the data

# reading csv file
getwd()
p_survival <- read.csv("Patient_survival_prediction.csv", header = TRUE, 
                       stringsAsFactors = TRUE)


#There are 91713 observations of 85 variables.


str(p_survival)

levels(p_survival$gender)


# We noticed that gender factor has 3 level but we want to have only 'F' and 'M',therefore we replace first empty factor with NA to drop it later.

p_survival[p_survival$gender=="",]<-NA


#For the purpose of this project we will not use all of the variables given. We select the columns we need for further data analysis and create new data set called p_survival_new. For this project we will only use 20 variables.


library("magrittr") 
library("dplyr")
p_survival_new <- p_survival %>% select(hospital_id,age,bmi,elective_surgery,ethnicity, gender,height,
                                        pre_icu_los_days, weight,apache_2_diagnosis, cirrhosis,
                                        diabetes_mellitus, hepatic_failure, immunosuppression,   leukemia,lymphoma,solid_tumor_with_metastasis, apache_3j_bodysystem,apache_2_bodysystem,hospital_death)

head(p_survival_new)
summary(p_survival_new)


#Our new data set has 91713 obs. of 20 variables

#Looking for NAs

apply(p_survival_new, MARGIN = 2, FUN = anyNA)


#We can already spot out columns with NAs.(all TRUE values)


library("mice")
missing_pattern <- md.pattern(p_survival_new, rotate.names = TRUE)


#The next line shows us exactly how much values are missing in each column.

# total NAs
apply(p_survival_new, MARGIN = 2, FUN = function(x) {sum(is.na(x))})


#Since NAs could have an impact on analysis, it is decided that rows containing NAs will be dropped.
#The script will dropout any row that has missing data on it remaining with only the untouched rows and save them
#into another object called p_survival_new_dropna.
#This way we can keep both the original dataset and also the modified dataset in the working environment.
#Later on, we separate the survivor and non survivor data from the modified dataset.

# Drop NAs

p_survival_new_dropna <- p_survival_new[rowSums(is.na(p_survival_new)) <=0,]

#Since categorical variables enter into statistical models differently than continuous variables, storing data as factors insures that the modeling functions will treat such data correctly.Choose some columns to coerce to factors:
  
 
#as factor}

cols <- c('gender','elective_surgery', 'ethnicity','cirrhosis','diabetes_mellitus','hepatic_failure',  'immunosuppression','leukemia',
          'lymphoma','solid_tumor_with_metastasis','apache_3j_bodysystem','apache_2_bodysystem','hospital_death')

p_survival_new_dropna[cols] <- lapply(p_survival_new_dropna[cols],factor)

# Check the result

sapply(p_survival_new_dropna, class)




#We can observe that 6904 patients died during hospitalization and 76465 survived.


unique(p_survival_new_dropna$hospital_death)

sum(p_survival_new_dropna$hospital_death==1)
sum(p_survival_new_dropna$hospital_death==0)


# We separate the patients based on survival/death in two datasets.

p_survival_new_dropna_death <- p_survival_new_dropna[p_survival_new_dropna$hospital_death==1,]
p_survival_new_dropna_non_death <- p_survival_new_dropna[p_survival_new_dropna$hospital_death==0,]
