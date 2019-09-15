adaboost_clf <- function(x_train,y_train, x_test,y_test,iteration,clf){
  
len_train <- nrow(x_train)
len_test  <- nrow(x_test)

#initialize weights
w <- rep(1,len_train)/len_train
pred_train <- rep(0,len_train)
pred_test <- rep(0,len_test)
err_train_i <- vector();
err_test_i <- vector();
for(i in 1:iteration){
  cat(paste("\n\n run:",i," ::: "))
  fit <- rpart( y_train ~ ., data=x_train,control = rpart.control(maxdepth = 1),
                method = "class", weights = w)
 
  pred_train_i <- predict(fit,x_train, type="class")
  pred_test_i  <- predict(fit,x_test, type="class")
 
  #indicator function
  miss = ifelse(pred_train_i != y_train,1,0)

  #Error
  err_m <- w%*%miss
  #print(paste("wt Error: ",round(err_m*100,3)))

  #Alpha
  alpha_m <- as.numeric(0.5*log((1-err_m)/err_m))
  
  # New weights
  miss_wt <- ifelse(miss == 0,1, -1)
  w1  <- w*(exp(-1*miss_wt*alpha_m))
  w2 <- w1/sum(w1)
  w  <- w2
  
  #converting the sign 
  pred_tr_i <- ifelse(pred_train_i == -1,-1,1)
  pred_te_i <- ifelse(pred_test_i  == -1,-1,1)
   
  # Add to prediction
  pred_train <- pred_train + (alpha_m*(pred_tr_i))
  pred_test  <- pred_test  + (alpha_m*(pred_te_i))

  pred_train_res <- sign(pred_train)
  pred_test_res <- sign(pred_test)
  
  #store errors
  err_train_i[i] <-  sum(pred_train_res != y_train)/length(y_train)
  err_test_i[i] <-  sum(pred_test_res != y_test)/length(y_test)
  
  cat(paste("\tTrain Error:", round(err_train_i[i],5)*100))
  cat(paste("\tTest Error:", round(err_test_i[i],5)*100))
}
  pred<- list(predTrain = pred_train_res, predTest = pred_train_res,
              errTrain = err_train_i, errTest= err_test_i)
  return(pred)
}