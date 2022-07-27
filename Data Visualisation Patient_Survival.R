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


### Graphical Analysis

# Heat Map

p_survival_new_dropna_death_matrix <- data.matrix(p_survival_new_dropna_death)
p_survival_new_dropna_death_heatmap <- heatmap(p_survival_new_dropna_death_matrix, col = cm.colors(256), scale="column", margins=c(5,5))


#On this plot we can observe the total number of patients who survived
#respectively died during hospitalization. 76'456 patients survived and 6094 died. 


# number of survivals and non survivals

library(ggplot2)
ggplot(p_survival_new_dropna, aes(x = hospital_death)) +
  geom_bar(width=0.5, fill = "coral") +
  geom_text(stat='count', aes(label=stat(count)), vjust=-0.5) +
  theme_classic()


#We notice that among the survived patients 34'644 are Females and 41'812 Males.
#Among the ones that didn't survived 3'198 are Females and 3'706 Males.


## survival by gender

ggplot(p_survival_new_dropna, aes(x = hospital_death, fill=gender)) +
  geom_bar(position = position_dodge()) +
  geom_text(stat='count', 
            aes(label=stat(count)), 
            position = position_dodge(width=1), vjust=-0.5)+
  theme_classic()


#We can identify that there is a relationship between age and number of deaths.
#With increase in age we observe increased number of deaths.
#There is a decreasing trend after 80, since median age is around 80.


ggplot(p_survival_new_dropna_death, aes(x =age)) +
  geom_density(fill='coral')

# Here we have created a temporary attribute called Discretized.age which groups the ages with a span of 10 years.
# We discretize the age using the cut() function and specify the cuts in a vector.
# The temporary attribute it discarded after plotting.
# Most of the patients that died during hospitalization are in the age range from 70-80 years old.


#Discretize age to plot survival
p_survival_new_dropna_death$Discretized.age = cut(p_survival_new_dropna_death$age, c(0,10,20,30,40,50,60,70,80,100))
# Plot discretized age
ggplot(p_survival_new_dropna_death, aes(x = Discretized.age, fill=hospital_death)) +
  geom_bar(position = position_dodge()) +
  geom_text(stat='count', aes(label=stat(count)), position = position_dodge(width=1), vjust=-0.5)+
  theme_classic()
#data.frame$Discretized.age = NULL

#Calculating the mean weight of male and female


### Calculate the mean of each group
library(plyr)
mu <- ddply(p_survival_new_dropna_death, "gender", summarise, grp.mean=mean(weight))
head(mu)


#After checking the weight variable among non-survived patients, we could potentially assume positive relationship between weight and death rate.
#The average weight of male patients is higher than female patients and thus can lead to the assumption of increased number of deaths among male patients.


ggplot(p_survival_new_dropna_death, aes(x=weight, fill=gender)) +
  geom_density(alpha=0.4)+
  geom_vline(data=mu, aes(xintercept=grp.mean, color=gender),
             linetype="dashed")




ggplot(p_survival_new_dropna_death, aes(x=weight))+
  geom_density()+facet_grid(gender ~ .)+
  geom_vline(data=mu, aes(xintercept=grp.mean, color="red"),
             linetype="dashed")


#The height of male patients is still higher than female patients but it is hard to assume a relationship between height and death rate.


ggplot(p_survival_new_dropna_death, aes(x=height, color=gender, fill=gender)) + 
  geom_histogram(aes(y=..density..), alpha=0.5, 
                 position="identity")+
  geom_density(alpha=.2) 

# Among the patients that died respectively survived during hospitalization, Caucasian are the majority, 5'366 patients died and 58'685 survived.
# The lowest death respectively survival rate have the Native Americans, 67 died, 681 surrvived.


ggplot(p_survival_new_dropna, aes(x = hospital_death, fill=ethnicity)) +
  geom_bar(position = position_dodge()) +
  geom_text(stat='count', 
            aes(label=stat(count)), 
            position = position_dodge(width=1), 
            vjust=-0.5)+
  theme_classic()

# APACHE II ("Acute Physiology and Chronic Health Evaluation II") is a severity-of-disease classification system, one of several ICU scoring systems. 
# It is applied within 24 hours of admission of a patient to an intensive care unit (ICU). 
# The point score is calculated from 12 admission physiologic variables comprising the Acute Physiology Score, the patient's age, and **chronic health status**.

#Here we have an overview just of the **chronic health status** and its effect on death rate.

# The majority of the patients that died, suffered from cardiovascular diseases.




ggplot(p_survival_new_dropna_death, aes(x = hospital_death, fill=apache_2_bodysystem)) +
 geom_bar(position = position_dodge()) +
 geom_text(stat='count', 
           aes(label=stat(count)), 
           position = position_dodge(width=2), 
           vjust=-0.5)+
 theme_classic()


# We implement explore package.The explore package automatically checks if an attribute is categorical or numerical, chooses the best plot-type and handles outliers (auto scaling).

#Result shows that the majority of the male patients who died during hospitalization were Asian, 62.4%, for the female patients 
#of Asian origin the rate is 37.6%
#The majority of female patients who died during hospitalization were Native American, 49.3%, (male Native American 50.7%), 
#Not far behind are the African American women 49.2% (male African American 50.8%).

# death gender ethnicity}
library(explore)
p_survival_new_dropna_death %>% explore(gender, target = ethnicity)


#In total 6.9% of the non-survived patients had an elective surgery.


p_survival_new_dropna_death %>% explore(elective_surgery, target = hospital_death, split = TRUE)


#59.8% of the male patients and 40.2% of the female patients who died during hospitalization had cirrhosis
#(cirrhosis can be found in patients who have a history of heavy alcohol use with portal hypertension and varices).


# p_survival_new_dropna_death %>% explore(gender, target=cirrhosis)

# Diabetes also plays an important role, since 21.1% from the non-survived patients had it, among other factors.


p_survival_new_dropna_death %>% explore(diabetes_mellitus, target=hospital_death,split=TRUE)
