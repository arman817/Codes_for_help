library(glmnet)
library(datasets)
library(ggplot2)
library(caret)
library(ROCR)
data(iris)
summary(iris)
iris.small <- iris[iris$Species!="setosa",]
data <- iris.small
data$Species <- as.numeric(data$Species)
data$Species <- as.factor(data$Species)
smp_size <- floor(0.75 * nrow(data))
train_ind <- sample(seq_len(nrow(data)), size = smp_size)
train <- data[train_ind, ]
test <- data[-train_ind, ]
#Building a normal glm
model <- glm(train$Species ~ ., data = train , family ="binomial")
PredTrain <-  predict(model, newdata=train, type="response") 
table(train$Species, PredTrain > 0.5)

PredTest <- predict(model, newdata = test, type = "response")
table(test$Species, PredTest > 0.5)

#Building a glm using the caret package
train_Contr <- trainControl(method = "cv",number = 5)



#Building a glm using the L2 regression penalty
Features_Train <- subset(train, select = -c(Species))
Features_Test <- subset(test, select = -c(Species))

Output_Train <- subset(train, select = c(Species))
Output_Test <- subset(test, select = c(Species))

x <- model.matrix(Species~.,train)
#y <- ifelse(trainset$diabetes=="pos",1,0)
y <- train$Species
cv.out <- cv.glmnet(x,y,alpha=1,family="binomial",type.measure = "mse")
lambda_1se <- cv.out$lambda.1se
x_test <- model.matrix(Species~.,test)
lasso_prob <- predict(cv.out,newx = x_test,s=lambda_1se,type="response")
table(test$Species, lasso_prob > 0.5)
coef(cv.out,s=lambda_1se)



#Assessing the performance of the logistic regression using ROCR
library(ROCR)
pr <- prediction(PredTrain,train$Species)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)
auc <- performance(pr, measure = "auc")
auc <- auc@y.values[[1]]
auc


#Assessing the performance of logistic regression using pROC
library(pROC)
train$prob <- PredTrain
test$prob <- PredTest
ROC_Train <- roc(Species ~ prob, data = train)
plot(ROC_Train)

ROC_Test <- roc(Species ~ prob, data = test)
plot(ROC_Test)

AUC_Train <- auc(Species ~ prob, data = train)

AUC_Test <- auc(Species ~ prob, data = test)


claire <- train[ , "Species", drop = TRUE]

claire <- subset(train, select = -c(Species))




# glm.out <- glm(Species ~ Sepal.Width + Sepal.Length + Petal.Width + Petal.Length,
#                data = iris.small,
#                family = binomial)
# summary(glm.out)
# lr_data <- data.frame(predictor=glm.out$linear.predictors, prob=glm.out$fitted.values, Species=iris.small$Species)
# ggplot(lr_data, aes(x=predictor, y=prob, color=Species)) + geom_point()

