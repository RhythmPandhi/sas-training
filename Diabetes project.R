
"
***********************
HEA 1035 Assignment Final Project
Author: Rhythm Pandhi
Student Number: A00262775
***********************

##################################################

"

###################################################
############# PART B here ##################
###################################################


#2. Load the recommended libraries (and install any packages)library(tidyr)
library(dplyr)
library(rpart)
library(rpart.plot)
library(ggplot2) #visualization
library(randomForest)
library(e1071)


#1 Read the file into R  
diabetes_df <- read.csv("diabetes.csv", header = TRUE)


#3. Examine the dimensions of the dataset
dim(diabetes_df) # 253682 rows and 15 columns

#4: Examine the structure of the dataset
str(diabetes_df)

#4a.Briefly describe the information provided
## All the columns are integer and can be converted to the factors. DB is the dependent variable and rest all are independent variables

#5. Examine the summary of the dataset
summary(diabetes_df)

#a.b.Briefly describe the information provided. which variables do you think will be more significant predictors 
## of diabetes based on the summary of the dataset?
####

## As we can see, all the summary statistics of the diabetes dataset are shown. It shows Min, 1st Q, Median, Mean, 3rd Q and Max values. 
##  following variables might be significant predictors of diabetes:
### BMI : Being overweight or obese is a known risk factor for developing diabetes.  
### PhyAct : Regular physical activity can help prevent and manage diabetes, so it is possible that this variable might be a significant predictor.
### Age :  Age is a well-known risk factor for developing diabetes
### HighBP , HighChol: High BP and Cholestrol are not directly the cause of Diabetes but it could be correlated.


#6: Examine the first five rows of data and the last five rows of data in the dataset
head(diabetes_df, 5 )
tail(diabetes_df, 5 )

## We can examine the 1st five and last 5 rows by using head and tail functions.

 
#################### Q - 7 ###################
###### Data Preprocessing and Cleaning ######
#############################################

#7a. Examine four categories for unique and duplicate variables


unique_vars <- lapply(diabetes_df, function(x) length(unique(x)))
unique_vars
dup_vars <- lapply(diabetes_df, function(x) sum(duplicated(x)))
dup_vars
cat_vars <- data.frame(Unique=unique_vars, Duplicate=dup_vars)
print(cat_vars)

 
#7b. Examine the dataset for duplicate rows and remove any duplicate rows that are present



dup_rows <- duplicated(diabetes_df)
duplicated_rows <- which(dup_rows)
print(paste0("Number of duplicated rows: ", length(duplicated_rows)))
diabetes_df <- diabetes_df[!dup_rows,]

## Number of duplicated rows: 76088

#7c. Check for the entire dataset for missing values (both NAs and blank entries)

 
missing_vars <- colSums(is.na(diabetes_df))
print(missing_vars)
## There are no missing variables.

#7d. Do any variables require typecasting? If so, typecast the variables. If not, explain why?
## yes, based on the data fields description provided, all columns except for BMI, Mental Health, Physical health can considered as factors,
diabetes_df[c("DB","HighBP","HighChol","Smk","Str","HD","PhyAct","Fr","Vg","GenHlth","Gender","Age")] <- lapply(diabetes_df[c("DB","HighBP","HighChol","Smk","Str","HD","PhyAct","Fr","Vg","GenHlth","Gender","Age")] ,factor )


#7e. Rename columns for clarity
colnames(diabetes_df) <- c("Diabetes", "HighBP", "HighCholesterol", "BMI", "HasSmoked", "HasStroke", "HasHeartDisease", "PhysicalActivity", "FruitConsumption", "VegetableConsumption", "GeneralHealth", "MentalHealthDays", "PhysicalHealthDays", "Gender", "Age")

# 7f. Create a new column for DB with variables in categorical/character form to use for visualizations
diabetes_df$Diabetes_Status <- ifelse(diabetes_df$Diabetes == 1, "Diabetes", "No Diabetes")



#################### Q -  8 #################
###### Visual Exploratory Analysis ##########
#############################################


## 8a Create a visualization for DB based on HighBP

ggplot(diabetes_df, aes(x = factor(HighBP), fill = Diabetes_Status)) +
  geom_bar() +
  labs(x = "High Blood Pressure", y = "Number of Individuals", fill = "Diabetes Status", 
       title = "Distribution of Diabetes Status Based on High Blood Pressure")

## i. Interpret this visualization (1 marks)
##  The visualization suggests that individuals with high blood pressure have 
##   a higher likelihood of having diabetes compared to those without high blood pressure.



## b. Create a visualization for DB based on HighChol (2 marks)

# Create a bar plot of Diabetes status based on HighCholesterol
ggplot(diabetes_df, aes(x = factor(HighCholesterol), fill = Diabetes_Status)) +
  geom_bar() +
  labs(x = "High Cholesterol", y = "Count", fill = "Diabetes Status", 
       title = "Distribution of Diabetes Status Based on High Cholesterol")

## i. Interpret this visualization (1 marks)
##  The visualization suggests that individuals with high cholesterol have 
##   a higher likelihood of having diabetes compared to those without high cholesterol.



## c. Create a visualization for DB based on BMI (2 marks)

  # Create a density plot of BMI based on Diabetes status
  ggplot(diabetes_df, aes(x = BMI, fill = Diabetes_Status)) +
    geom_density(alpha = 0.7) +
    scale_fill_manual(values = c("pink", "lightblue"), 
                      name = "Diabetes Status") +
    labs(x = "Body Mass Index (BMI)", y = "Density", 
         title = "Distribution of BMI Based on Diabetes Status")

## i. Interpret this visualization (1 marks)
  ## The output is a density plot showing the distribution of Body Mass Index (BMI) among individuals with and without diabetes. It definitely provides some insights
  ## that higher BMIs have diabetes as compared to the ones with diabetes
  
  
## d. Create a visualization for DB based on PhyAct (2 marks)

 
  # Create a percentage bar plot of Diabetes_Status based on PhysicalActivity
  ggplot(diabetes_df, aes(x = factor(PhysicalActivity), fill = Diabetes_Status)) +
    geom_bar(position = "fill") +
    labs(x = "Physical Activity in past 30 days", y = "Percentage of individuals", 
         title = "Percentage Distribution of Diabetes Status Based on Physical Activity")
  
   
## i. Interpret this visualization (1 marks)
  
  ## No conculsion can be drawn from this as both show similar levels of diabetes
## e. Create a visualization for DB based on Fr and Vg (2 marks)
 
  
  
  # Calculate the percentages of each Diabetes_Status group for each combination of FruitConsumption and VegetableConsumption
  df_percent <- diabetes_df %>%
    group_by(FruitConsumption, VegetableConsumption, Diabetes_Status) %>%
    summarise(n = n()) %>%
    group_by(FruitConsumption, VegetableConsumption) %>%
    mutate(percentage = n/sum(n)*100)
  
  # Create a stacked bar chart of the percentages
  ggplot(df_percent, aes(x = FruitConsumption, y = percentage, fill = Diabetes_Status)) +
    geom_col(position = "fill") +
    facet_wrap(vars(VegetableConsumption)) +
    labs(x = "Fruit Consumption", y = "Percentage of Individuals",
         title = "Distribution of Diabetes Based on Fruit and Vegetable Consumption",
         fill = "Diabetes Status") +
    scale_x_discrete(labels = c("No", "Yes")) +
    scale_fill_manual(values = c("#CC79A7", "#0072B2")) +
    theme_classic()
  
  
   
## i. Interpret this visualization (1 marks)
  ## There is no correlation here as all of them have similar percentages for veg and fruit consumption for diabetes and non-diabetes. 

## f. Create a visualization for DB based on Gender (2 marks)
  
  ggplot(diabetes_df, aes(x = Gender, fill = Diabetes_Status)) +
    geom_bar(position = "fill") +
    labs(x = "Gender", y = "Proportion of Individuals", 
         title = "Distribution of Diabetes Based on Gender",
         fill = "Diabetes Status") +
    scale_x_discrete(labels = c("Female", "Male")) +
    scale_fill_manual(values = c("#FFC0CB", "#6495ED")) +
    theme_classic()
  
## i. Interpret this visualization (1 marks)
  ## There is no correlation here as all of them have similar percentages for gender for diabetes and non-diabetes. 
  
## g. Create a visualization for Outcome based on Age (2 marks)
  
  # Create a stacked bar plot of Outcome based on Age
  ggplot(diabetes_df, aes(x = factor(Age), fill = factor(Diabetes_Status))) +
    geom_bar(position = "stack") +
    labs(x = "Age Group", y = "Count",
         title = "Diabetes by Age Group",
         fill = "Diabetes Status") +
    scale_x_discrete(labels = c("18-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", "75-79", "80+")) +
    theme_classic() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1))
  
## i. Interpret this visualization (1 marks)
  
  ## From the above plot, we can see that the mid 50s and above have higher counts of diabetic individuals.
  
## h. Create two additional visualizations to explore the relationship between any of the variables not completed above (4 marks)
## I am taking Heart Disease and Stroke
  
  ## Heart disease viz
    ggplot(diabetes_df, aes(x = HasHeartDisease, fill = Diabetes_Status)) +
    geom_bar(position = "fill") +
    labs(x = "Has Heart Disease", y = "Proportion of Individuals",
         title = "Distribution of Diabetes Status Based on Heart Disease",
         fill = "Diabetes Status") +
    scale_x_discrete(labels = c("No", "Yes")) +
    scale_fill_manual(values = c("#5F9EA0", "#FFA07A")) +
    theme_classic()
  
    ## Stroke viz
    ggplot(diabetes_df, aes(x = HasStroke, fill = Diabetes_Status)) +
      geom_bar(position = "fill") +
      labs(x = "Stroke Status", y = "Proportion", 
           title = "Distribution of Diabetes Based on Stroke Status",
           fill = "Diabetes Status") +
      scale_fill_manual(values = c("#1b9e77", "#d95f02")) +
      theme_classic()
    
  
## i. Interpret these visualizations (2 marks)
  ## we can see that both Heart disease and stroke column have some correlation with Diabetic but not too much
## i. BONUS: Create a single visualization displaying a histogram for all numeric/integer variables (2 marks)
  numeric_df <- diabetes_df[, c("BMI","MentalHealthDays","PhysicalHealthDays")]
  
  # Melt the data into long format for plotting
  melt_df <- reshape2::melt(numeric_df)
  
  # Create a histogram of the values, colored by variable
  ggplot(melt_df, aes(x = value, fill = variable)) +
    geom_histogram(binwidth = 1, position = "dodge", alpha = 0.8) +
    labs(title = "Histogram of Numeric Variables", x = "Value", y = "Count") +
    scale_fill_manual(values = c("blue", "red", "green")) +
    theme_classic()
  
## i. Interpret the visualization (1 mark)
  ## Histogram is shown in 1 viz. For better visibility, it is recommended to scale the values and use these in separate visualization
  
## j. BONUS: Create a correlation plot to explore the correlation between all numeric/integer variables (2 marks)

  corr <- cor(numeric_df)
  library(corrplot)
  corrplot(corr, type = "upper", order = "hclust", tl.col = "black", tl.srt = 45)

  ## There is some relationship between the mental health days and physical health days but not with BMI at all
  

## Removing diabetes status column with yes/no as it is no longer needed for further analysis
  diabetes_df$Diabetes_Status <- NULL
  

  #################### Q - 9 ##################
  ############## Data Partitioning ############
  #############################################
  
  
  
### Q9a. Based on the visuals, which variables from the dataset do you believe will contribute to the prediction of diabetes and why ? 
  
  ## Based on the visuals, it appears that variables such as BMI, Age, high BP and Cholesterol may contribute to the diabetes prediction. 
  # This is because there is a clear difference in the distribution of diabetes status based on these variables. Further, Heart disease and Stroke variables
  ## look important as well. However, it is important to note that further analysis is necessary to confirm these observations 
  ## and determine the actual predictive power of each variable.
  
### Q9a.i. Should any columns (variables) be removed from the dataset prior to analysis?
   ### There is no need to remove any variable prior to analysis but I will say that the Gender, Fruits and Veggies consumption, Mental Health and Physical Health 
   ### Physical activity in past 30 days have not shown much correlation  with the diabetes.


### Q9 b. Partition the dataset into training and validation sets
  set.seed(123)
  n =nrow(diabetes_df)
  trainIndex = sample(1:n, round(0.70*n),replace = FALSE)
  train = diabetes_df[trainIndex,]
  test = diabetes_df[-trainIndex,]
  
### Q9 b.i. Examine the dimensions
  
   dim(train)
  dim(test)
  
  
  #################### Q - 10 #################
  ############## Logistic Regression ##########
  #############################################
 
## a. Run the logistic regression model (1 mark)
  log_reg_model <- glm(Diabetes ~ ., data = train, family = binomial)

  
## i. Create a summary (output) after running the logistic regression model (1 mark)
  summary(log_reg_model)
## ii. Interpret the summary of the model to indicate which variables indicate higher probabilities of missing an appointment and lower probabilities of missing an appointment (2 marks)
 ## From the above summary, except for Age2, all the other variables indicate higher prob of diabetes.  
## b. Compute the predicted probabilities using the validation dataset (2 marks)
  predicted_probabilities = predict(log_reg_model, newdata = test, type = "response")
  
## i. Interpret the first five actual and predicted records (2 marks)
head(predicted_probabilities)
## Predicted prob and actual value are shown below respectively. It looks like the threshold is above 0.3.
##  0.06650793 0.13961974 0.18406802 0.20712746 0.19505198 0.28387522
##  0          0          0          0          0          0 

## ii. What does this indicate about your model? (1 mark)
### This indicates that the threshold is around 0.5 and we will keep that here.

## iii. What is the accuracy of the model? (1 mark)
predicted_classes = ifelse(predicted_probabilities > 0.5, 1, 0)
actual_classes = test$Diabetes
log_accuracy = sum(predicted_classes == actual_classes) / length(actual_classes)
log_accuracy

## Accuracy is 81.8% 


## iv. Create and interpret a confusion matrix (2 marks)  
conf_matrix_log = table(predicted_classes, actual_classes)
conf_matrix_log
 
TP = conf_matrix_log[2, 2]
TN = conf_matrix_log[1, 1]
FP = conf_matrix_log[1, 2]
FN = conf_matrix_log[2, 1]

## based on the above confusion matrix we can calculate the following: 
log_sensitivity = TP / (TP + FN)  
log_specificity = TN / (TN + FP)  
log_precision = TP / (TP + FP)    

cat("LR Sensitivity:", log_sensitivity, "\n")
cat("LR Specificity:", log_specificity, "\n")
cat("LR Precision:", log_precision, "\n")
cat("LR Accuracy:", log_accuracy, "\n")


## In this case, the model has relatively high accuracy (81.8%) but low precision (13.77%) and moderate specificity (56.12%). 
#  This means that the model is good at correctly identifying true negatives, but is not very good at identifying true positives. 
# This could indicate that the model has a tendency to predict false negatives (i.e., cases where the person actually has diabetes but the model predicts that they do not).



#################### Q - 11 #################
############## Decision Tree      ##########
#############################################





# a. Fit a classification tree model to training set (1 marks)
dt_fit <- rpart(Diabetes ~ HighBP + HighCholesterol + BMI + HasSmoked + HasStroke + HasHeartDisease   + GeneralHealth  +MentalHealthDays +PhysicalHealthDays + Age  , data = train, method = "class", control=rpart.control(minsplit=10))


## i. Visualize the classification tree (1 marks)
rpart.plot(dt_fit, extra = 4, main = "Classification Tree for Diabetes")

## ii. Interpret the classification tree (1 marks)
summary(dt_fit)
# b. Predict the validation set results (1 marks)
dt_predicted_classes <- predict(dt_fit, newdata = test, type = "class")
dt_actual_classes <- test$Diabetes
## i. What is the accuracy of the model? (1 marks)
dt_accuracy <- sum(dt_predicted_classes == dt_actual_classes) / length(dt_actual_classes)
dt_accuracy
## 81.31%
## ii. Create and interpret a confusion matrix? (2 marks)

conf_matrix_dt = table(dt_predicted_classes, dt_actual_classes)
conf_matrix_dt

TP = conf_matrix_dt[2, 2]
TN = conf_matrix_dt[1, 1]
FP = conf_matrix_dt[1, 2]
FN = conf_matrix_dt[2, 1]

## based on the above confusion matrix we can calculate the following: 
dt_sensitivity = TP / (TP + FN)   
dt_specificity = TN / (TN + FP)  
dt_precision = TP / (TP + FP)     


cat("Decision Tree Sensitivity:", dt_sensitivity, "\n")
cat("Decision Tree Specificity:", dt_specificity, "\n")
cat("Decision Tree Precision:", dt_precision, "\n")
cat("Decision Tree Accuracy:", dt_accuracy, "\n")

## We are discarding this model as it predicted everything as 0. There was no accurate plot as well. I am not sure if I made a mistake but I used the similar code
## used in the lecture and also tried to google but didnt help at all. 



#################### Q - 12 #################
############## Random Forests ###############
#############################################


# a. Fit random forest model to the training set (1 marks)
set.seed(111)
rf_model <- randomForest(Diabetes ~ ., data = train, importance = TRUE)

# b. Predict the validation set results (1 marks)
predicted_rf <- predict(rf_model, newdata = test)

# i. What is the accuracy of the model? (1 marks)
accuracy_rf <- sum(predicted_rf == test$Diabetes) / nrow(test)
accuracy_rf
# ii. Create and interpret a confusion matrix (2 marks)
conf_matrix_rf <- table(predicted_rf, test$Diabetes)
conf_matrix_rf

# Calculate the sensitivity, specificity, and precision
rf_sensitivity <- conf_matrix_rf[2,2] / sum(conf_matrix_rf[2,]) 
rf_specificity <- conf_matrix_rf[1,1] / sum(conf_matrix_rf[1,]) 
rf_precision <- conf_matrix_rf[2,2] / sum(conf_matrix_rf[,2])   

# Print the sensitivity, specificity, and precision
cat("Random Forest Sensitivity:", rf_sensitivity, "\n")
cat("Random Forest Specificity:", rf_specificity, "\n")
cat("Random Forest Precision:", rf_precision, "\n")
cat("Random Forest Accuracy:", accuracy_rf, "\n")



# 13 Naïve Bayes
# a. Fit the naïve bayes model to the training set (1 marks)
#nb_model <- naiveBayes(Diabetes ~ HighBP + HighCholesterol + BMI + HasSmoked + HasStroke + HasHeartDisease   + GeneralHealth  +MentalHealthDays +PhysicalHealthDays + Age, data = train)
nb_model <- naiveBayes(Diabetes ~ ., data = train)

# b. Predict the validation set results (1 marks)
nb_pred <- predict(nb_model, newdata = test)
# i. What is the accuracy of the model? (1 marks)
nb_acc <- sum(nb_pred == test$Diabetes) / length(test$Diabetes)
nb_acc 
# ii. Create and interpret a confusion matrix? (1 marks)
nb_conf <- table(nb_pred, test$Diabetes)
nb_conf

# Calculate the sensitivity, specificity, and precision
nb_sensitivity <- nb_conf[2,2] / sum(nb_conf[2,])
nb_specificity <- nb_conf[1,1] / sum(nb_conf[1,])
nb_precision <- nb_conf[2,2] / sum(nb_conf[,2])

# Print the sensitivity, specificity, and precision
cat("Naive Bayes' Sensitivity:", nb_sensitivity, "\n")
cat("Naive Bayes' Specificity:", nb_specificity, "\n")
cat("Naive Bayes' Precision:", nb_precision, "\n")
cat("Naive Bayes' Accuracy:", nb_acc, "\n")




## 14 Compare the prediction models
### a. How do the accuracy and confusion matrices of the models compare? (2 marks)
### We didnt get good results from the Decision tree since it predicted 0 for everything. Hence, I am removing it from the comparison.
##### Based on the accuracy and confusion matrices of the three models, the Naive Bayes model has the lowest accuracy and the Logistic Regression and Random Forest models have similar accuracy.
##### However, looking at the precision and sensitivity metrics, the Logistic Regression model has the highest sensitivity and precision values,
##### indicating that it is better at correctly identifying true positives and minimizing false positives. The Naive Bayes model has the highest 
##### specificity value, indicating that it is better at correctly identifying true negatives and minimizing false negatives.


###b. Which model would you select for classification and why? (2 marks)
# Since we care more about false positives as it can lead to unnecessary medical interventions/treatments for diabetes, 
## the best model would be the one with the highest specificity. 
# Based on the specificity values for each model, the Naive Bayes model has the highest specificity of 0.8626, 
# followed by the Logistic Regression model with a specificity of 0.8314 and the Random Forest model with a specificity of 0.8287. 
# Therefore, the Naive Bayes model would be the best choice for this classification problem.


### 14 c . Create a data frame in R to display the accuracy comparison of all prediction models

# Create a data frame for model comparison
models <- c("Logistic Regression", "Random Forest", "Naive Bayes")
accuracy <- c(log_accuracy, accuracy_rf, nb_acc)
sensitivity <- c(log_sensitivity, rf_sensitivity, nb_sensitivity)
specificity <- c(log_specificity, rf_specificity, nb_specificity)
precision <- c(log_precision, rf_precision, nb_precision)

model_comparison <- data.frame(models, accuracy, sensitivity, specificity, precision)
model_comparison

## Above data frame shows accuracy and other statistics for the three models.

## THANKS! THE END