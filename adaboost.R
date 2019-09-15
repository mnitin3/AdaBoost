rm(list = ls())
cat("\014")
set.seed(7)
source('func_adaboost.R')
library(rpart)

raw <- read.csv("data/adult.csv", strip.white=TRUE)
names(raw) <- c( 'age', 'workclass', 'fnlwgt', 'education', 'education-num',
                 'marital-status', 'occupation', 'relationship', 'race', 'sex', 
                 'capital-gain', 'capital-loss', 'hours-per-week', 'native-country',
                 'sal')

summary(raw)
row.names(raw) <- NULL
raw <- raw[raw$workclass != '?',]
raw <- raw[raw$`native-country` != '?',]
write.csv(raw, "data/adult_cleaned.csv", row.names = F)

raw$sal <- ifelse(raw$sal ==">50K",1,-1)

#train test Split
ind <- sample(1:nrow(raw), size = 0.8*nrow(raw),replace = F)
train <- raw[ind,]
test  <- raw[-ind,]

x_train <- train[,-15]
y_train <- train$sal
x_test  <- test[,-15]
y_test  <- test$sal

## fitting Base classifier
clf_tree <- rpart(y_train ~ ., data=x_train, control = rpart.control(maxdepth = 1), 
                  method = "class")

pre_train <- predict(clf_tree,x_train,type = "class")
pre_test  <- predict(clf_tree,x_test,type = "class")

err_train <- sum(pre_train != y_train)/nrow(train)
err_test <- sum(pre_test != y_test)/nrow(test)
print(paste0("Base model: Train Error % --> ",err_train));
print(paste0("Base model: Test Error % --> ",err_test ));

# Fit Adaboost classifier using a decision tree as base estimator
# Test with different number of iterations
iter <- c(100)
for(i in iter){
  pred_ada <- adaboost_clf(x_train,y_train, x_test,y_test,i,clf_tree)
}
plot(pred_ada$errTrain, type = 'l', col="red", 
    main= "AdaBoost: Error per iterations", xlab="# of Iterations", ylab="Error (in %)") + 
    lines(pred_ada$errTest,col="blue") 
