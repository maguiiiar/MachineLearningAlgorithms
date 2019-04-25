# MachineLearningAlgorithms
Algorithms for implementing statistical & ml models.

**RIDGE REGRESSION:**

 - It shrinks the parameters, therefore it is mostly used to prevent multicollinearity;
 - It reduces the model complexity by coefficient shrinkage;
 - It uses L2 regularization technique (α = 0 and λ is selected through cross validation).
 
 **LASSO REGRESSION**
 
 - It uses L1 regularization technique (α = 1 and λ is selected through cross validation).
 - It is generally used when we have more number of features, because it automatically does feature selection accordlying with λ parameter, which needs to be chosen/tuned by the cross-validation.
 
 **ELASTIC NET REGRESSION**
 
 Elastic net is basically a combination of both L1 and L2 regularization. So if you know elastic net, you can implement both Ridge and Lasso by tuning the parameters α and λ.

*elasticnet_model_with_imbalance.R* makes possible lasso, ridge and elastic net models being created and utilizes techniques to deal with imbalanced target databases, comparing models with different techniques. Also, the same structure can be applied to several other modelling methods (statistical or machine learning/AI ones), since it utilizes *caret* package to develop all structure.

There are two ways of develop lasso, ridge or elastic net models in R: using *glmnet* package or *caret* package.
*glmnet* package allows us to implement lasso, ridge or elastic net and has several interesting plots to follow modelling development.

*caret* package allows us to compare and tune models easely, even using different methods. It removes strucuture, input and output differences between functions from different packages, unifying it all in only one. *caret* does not differentiate *lambda 1 standard deviation* and *lambda minimum*.
