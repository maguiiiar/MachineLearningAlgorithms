# MachineLearningAlgorithms
Algorithms for implementing statistical & ml models.

**RIDGE REGRESSION:**

 - It shrinks the parameters, therefore it is mostly used to prevent multicollinearity.
 - It reduces the model complexity by coefficient shrinkage.
 - It uses L2 regularization technique. (which I will discussed later in this article)

*elasticnet_model_with_imbalance.R* makes possible lasso, ridge and elastic net models being created and utilizes techniques to deal with imbalanced target databases, comparing models with different techniques. Also, the same structure can be applied to several other modelling methods (statistical or machine learning/AI ones), since it utilizes *caret* package to develop all structure.

There are two ways of develop lasso, ridge or elastic net models in R: using *glmnet* package or *caret* package.
*glmnet* package allows us to implement lasso, ridge or elastic net and has several interesting plots to follow modelling development.

*caret* package allows us to compare and tune models easely, even using different methods. It removes strucuture, input and output differences between functions from different packages, unifying it all in only one. *caret* does not differentiate *lambda 1 standard deviation* and "lambda minimum*.
