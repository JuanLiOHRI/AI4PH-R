library(yaml)
library(plumber)
library(tidymodels)

# plumber.R

#* Execute the model
#* 
#* @param gender Your gender, allowed value: F; M
#* @param age Your age, allowed range: 40-100
#* @param hypertension Do you have hypertension? Allowed value: No; Yes
#* @param heart_disease Do you have heart disease? Allowed range: No; Yes
#* @param ever_married Have you ever married? Allowed range: No;Yes
#* @param work_type What kind of work you are doing or have done? Allowed value: Self-employed; Private job; Government job
#* @param Residence_type The type of your residence, allowed range: Rural; Urban
#* @param avg_glucose_level Average glucose level, allowed range: 0-310
#* @param bmi Body mass index, allowed range: 9-73
#* @param smoking_status Smoking, allowed value: Never smoked; Formerly smoked; Currently smokes
#* @get /predict/values

function(gender, age, hypertension, heart_disease, ever_married, work_type, 
         Residence_type, avg_glucose_level, bmi, smoking_status) {
  
  # read in the saved workflow object
  workflow <- readRDS("stroke_lr_workflow.rds")
  
  # assemble the inputs into a data frame
  newdata <- data.frame(gender = factor(gender), 
                        age = as.numeric(age),
                        hypertension = factor(hypertension),
                        heart_disease = factor(heart_disease),
                        ever_married = factor(ever_married), 
                        work_type = factor(work_type), 
                        Residence_type = factor(Residence_type), 
                        avg_glucose_level = as.numeric(avg_glucose_level), 
                        bmi = as.numeric(bmi), 
                        smoking_status = factor(smoking_status)
  )
  
  # predict on the new data - class
  prediction_class <- workflow %>% 
    predict(new_data = newdata,
            type = 'class')
  
  # predict on the new data - probability
  prediction_prob <- workflow %>% 
    predict(new_data = newdata,
            type = 'prob')
  
  # report result
  print(paste("The predicted class is: ", prediction_class$.pred_class, ", where 0 = no stroke; 1 = stroke",
              ". The predicted probability for class 0 is: ", round(prediction_prob[1],3),
              ". The predicted probability for class 1 is: ", round(prediction_prob[2],3), sep = ""))
}