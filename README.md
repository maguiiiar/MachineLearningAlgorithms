# MachineLearningAlgorithms
Algorithms for implementing statistical & ml models.

# REGRESSION

Standard regression models performs poorly in a situation where you have a large multivariate data set containing a number of variables superior to the number of samples.

A better alternative is to use penalized regression, which allows the creation of a regression model that is penalized for having too many variables in the model, by adding a constraint in the equation (James et al, 2014; P. Bruce and Bruce, 2017). This is also known as shrinkage or regularization methods.

The consequence of imposing this penalty is to shrink the coefficient values towards zero. This allows the less contributive variables to have a coefficient close to zero or equal zero.

Note that the shrinkage requires the selection of a tuning parameter (lambda) that determines the amount of shrinkage.

*elasticnet_model_with_imbalance.R* makes possible lasso, ridge and elastic net models being created and utilizes techniques to deal with imbalanced target databases, comparing models with different techniques. Also, the same structure can be applied to several other modelling methods (statistical or machine learning/AI ones), since it utilizes *caret* package to develop all structure.

## PENALIZED REGRESSIONS

**RIDGE REGRESSION:**

 - It shrinks the parameters, therefore it is mostly used to prevent multicollinearity;
 - It reduces the model complexity by coefficient shrinkage;
 - It uses L2 regularization technique (α = 0 and λ is selected through cross validation).
 
 **LASSO REGRESSION**
 
 - It uses L1 regularization technique (α = 1 and λ is selected through cross validation).
 - It is generally used when we have more number of features, because it automatically does feature selection accordlying with λ parameter, which needs to be chosen/tuned by the cross-validation.
 
 **ELASTIC NET REGRESSION**
 
 - Elastic net is basically a combination of both L1 and L2 regularization, so you can implement both Ridge and Lasso by tuning the parameters α and λ simutaneously.

There are two ways of develop lasso, ridge or elastic net models in R: using *glmnet* package or *caret* package.
*glmnet* package allows us to implement lasso, ridge or elastic net and has several interesting plots to follow modelling development.

*caret* package allows us to compare and tune models easely, even using different methods. It removes structure, input and output differences between functions from different packages, unifying it all into only one package. A negative point for *caret* for penalized regression is that it does not differentiate *lambda 1 standard deviation* and *lambda minimum*. *bestTune* output from caret is equivalent to *lambda minimum*.
