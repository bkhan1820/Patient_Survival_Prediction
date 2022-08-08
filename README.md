# Patient_Survival_Prediction


## About The Project

For this collaborative project conducted with Aleksandra Bundovska, Yang Bai, we decided to use the data set "Patient_survival_prediction" found on <ins>[Kaggle](https://www.kaggle.com/datasets/mitishaagarwal/patient)</ins>. This data is initially from MIT’s GOSSIS (Global Open Source Severity of Illness Score) initiative and was collected in USA, in 2021. It contains information about patients who were admitted to the intensive care unit (ICU).

This data set has 91713 observations and 85 variables.
There are various factors given, which are involved when a patient is hospitalized. We aim to analyse which factors have an influence on patient's survival rate during hospitalization. Moreover on the basis of these factors, we will try to predict patient survival during hospitalization.


In this article, the steps are followed as below:

1. Data preperation, you can find the R script <ins>[here](https://github.com/bkhan1820/Patient_Survival_Prediction/blob/main/Data%20Preperation%20Patient_Survival.R)</ins>
2. Data Visualisation, R script <ins>[here](https://github.com/bkhan1820/Patient_Survival_Prediction/blob/main/Data%20Visualisation%20Patient_Survival.R)</ins>
3. Model Fitting and Cross Validation
4. Logistic Regression
5. Support Vector Machine 
6. Neural networks

## Built With

This section list major R frameworks/libraries used to build this project:

- library(plyr)
- library(dplyr)
- library(ggplot2)
- library(tidyverse)
- library(gridExtra) 
- library(reshape2)
- require(magrittr)
- library(tidyr)
- library(explore)
- library(caret)
- library(mice)
- library(neuralnet)

## Some Interesting highlights from projects:

## Cross Validation

Cross-validation refers to a set of methods for measuring the performance of a given predictive model on new test data sets.

The basic idea, behind cross-validation techniques, consists of dividing the data into two sets:
- The training set, used to train (i.e. build) the model
- The testing set (or validation set), used to test (i.e. validate) the model by estimating the prediction error.

The different cross-validation methods for assessing model performance. We will look at the following approaches:
- Validation set approach (or data split)
- Leave One Out Cross Validation
- k-fold Cross Validation
- Repeated k-fold Cross Validation

## The Validation set Approach

The validation set approach consists of randomly splitting the data into two sets: one set is used to train the model and the remaining other set is used to test the model.

The process works as follow:

- Build (train) the model on the training data set
- Apply the model to the test data set to predict the outcome of new unseen observations
- Quantify the prediction error as the mean squared difference between the observed and the predicted outcome values.

The example below splits the patient_survival data set so that 80% is used for training a logistic regression model and 20% is used to evaluate the model performance.



## Contact

Bahram Khanlarov - bahram.khanlarov@stud.hslu.ch

Project Link: https://github.com/bkhan1820/Patient_Survival_Prediction
