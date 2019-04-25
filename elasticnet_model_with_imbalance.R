require(caret)
require(dplyr)

###############################################
# several models applied to the same database #
###############################################

###################################################
# running model using caret package (awesome! <3) #
###################################################

# parameters to train database: method "repeatedcv" will rerun model utilizing repeated (3 times)
# cross validation (10 different folds). The final model accuracy is taken as the mean from the number of repeats.
control <- trainControl(method="repeatedcv",
                        classProbs = TRUE,
                        summaryFunction = twoClassSummary,
                        savePredictions = "all", number = 10, repeats = 3)

# running a logistic regression - LASSO model (glmnet with alpha = 1 and lambda between 0 and 1);
#                                 RIDGE model (glmnet with alpha between 0 and 1 and lambda = 1);
#                                 ELASTIC NET model (glmnet with alpha and lambda between 0 and 1).
set.seed(7)
model.caret <- caret::train(target ~ ., data = model_db,
                                  method = "glmnet", family = "binomial",
                                  trControl=control,
                                  tuneGrid = expand.grid(alpha = 1,
                                                         lambda = seq(0.001,1, length = 30)))

plot(model.caret, xvar = "lambda")

# levels(model_db$target) <- make.names(levels(factor(model_db$target)))

# adding different techniques that deal with imbalanced target distribution
sampling = c("smote", "rose", "up", "down")
model <- list()
for(i in 1:length(sampling)){
  control$sampling <- sampling[i]
  model[[i]] <- caret::train(target ~ ., data = model_db,
                             method = "glmnet", family = "binomial",
                             trControl=control,
                             tuneGrid = expand.grid(alpha = 1,
                                                    lambda = seq(0.001,1, length = 20)))
                            }

results <- caret::resamples(list(LASSO = model[[1]],
                                 ROSE = model[[2]],
                                 UP = model[[3]],
                                 DOWN = model[[4]]))

# summarise the distributions
summary(results)
bwplot(results, ncol = 2)

# other several methods can be applied in train function: https://rdrr.io/cran/caret/man/models.html.
# to compare models, just use `resamples` function.

######################################
# running same model using cv.glmnet #
######################################

# library to "unregister" a foreach backend, registering the sequential backend
registerDoSEQ() 

# column numbers which are to be forced entering in the model
pf = which(names(dbs$train_db_woe)[-1] %in% c("perc_parc_renda_woe", "perc_pg_finan_woe", "perc_entrada_financ_woe", "prazo_contrato_woe"))
penalty.factor=c(rep(1, ncol(dbs$train_db_woe)-1))

# change `penalty factor` to 0 of variables forced to enter the model
for(i in 1:length(pf)){
  penalty.factor[pf[i]] = 0}

# finding best lambda using cross-validation through auc
set.seed(123)
cv.lasso <- cv.glmnet(X, y, alpha = 1, family = "binomial",  type.measure = "auc") #, parallel = TRUE, penalty.factor = penalty.factor)

plot(cv.lasso)#, main = paste0(desired_model, " | ", segment, " | ", Sys.Date()))

# pushing forward variable selection
lambda = ifelse(variables <= 20, cv.lasso$lambda.1se, 
                cv.lasso$lambda.min + 2*(cv.lasso$lambda.1se - cv.lasso$lambda.min))

# running LASSO model
lasso.model <- glmnet(X, y, family = "binomial", lambda = lambda, alpha = 1)#, penalty.factor = penalty.factor)

################################
# performance model statistics #
################################

coefs <- tidy(lasso.model)
probabilities <- predict(lasso.model, newx = X.test, type="response", s = lambda)

# checking probabilities x target in test database
pred <- prediction(probabilities, dbs$test_db_woe$target)
# pred <- prediction(probabilities$badpayer, model_test$target)

acc.perf = ROCR::performance(pred, "sens", "spec")
plot(acc.perf)

# find probabilities cutoff with greater sum of specificity and sensitivity
cutoff <<- acc.perf@alpha.values[[1]][which.max(acc.perf@x.values[[1]]+acc.perf@y.values[[1]])]

predicted.classes <- ifelse(probabilities > cutoff, "badpayer", "goodpayer")
observed.classes <- ifelse(dbs$test_db_woe$target == "bad", "badpayer", "goodpayer")

observed.classes.num <- ifelse(observed.classes == "badpayer", 1, 0)
predicted.classes.num <- ifelse(predicted.classes == "badpayer", 1, 0)

# calculating KS, auc, gini
evaluation <- scorecard::perf_eva(label = observed.classes.num, pred = probabilities, show_plot = TRUE)
evaluation$confusion_matrix
df <- melt(data.frame(evaluation$binomial_metric$dat))
names(df) <- c("Statistic", "Value")

# calculating features importance
imp = caret::varImp(lasso.model, lambda = lambda) %>% tibble::rownames_to_column("variable") %>% arrange(desc(Overall)) %>% dplyr::rename("importance" = "Overall") %>% filter(!importance == 0)

# creating dataframe with probabilities
probs_by_contract <<- data.frame(select(dbs$test_db, selected_var), bad_payer_prob = c(probabilities), predicted_target = predicted.classes)

# creating confusion matrix
conf.matrix <<- caret::confusionMatrix(as.factor(predicted.classes),
                                       as.factor(observed.classes), positive = "badpayer")

# results printing on console
paste0("Results from lasso model for", " ", names(cv.lasso)[10],"\n\n") %>% cat()
paste0("The cutoff probability point that produces greater sensibility+specificity: ", round(cutoff,4), "\n\n") %>% cat()

print(tidy(lasso.model))
"######################################################\n\n" %>% cat()
print(imp)
"######################################################\n\n" %>% cat()
print(evaluation)
"######################################################\n\n" %>% cat()
print(conf.matrix)
"######################################################\n\n" %>% cat()
