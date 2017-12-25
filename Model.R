# Libraries ---------------------------------------------------------------
library(keras)
library(densenet)
devtools::install_github("dfalbel/densenet")
#install.packages('densenet')
#library(tensorflow)
#install.packages("keras")

#install_keras(tensorflow = "gpu")
# Parameters --------------------------------------------------------------

batch_size <- 64
epochs <- 300

# Data Preparation --------------------------------------------------------

# see ?dataset_cifar10 for more info
cifar10 <- dataset_cifar10()

# Normalisation
for(i in 1:3){
  mea <- mean(cifar10$train$x[,,,i])
  sds <- sd(cifar10$train$x[,,,i])
  
  cifar10$train$x[,,,i] <- (cifar10$train$x[,,,i] - mea) / sds
  cifar10$test$x[,,,i] <- (cifar10$test$x[,,,i] - mea) / sds
}
x_train <- cifar10$train$x
x_test <- cifar10$test$x

y_train <- to_categorical(cifar10$train$y, num_classes = 10)
y_test <- to_categorical(cifar10$test$y, num_classes = 10)

# Model Definition -------------------------------------------------------
#DenseNet-40-12-for Cifar10

input_img <- layer_input(shape = c(32, 32, 3))
model <- application_densenet(include_top = TRUE, input_tensor = input_img, dropout_rate = 0.2)

opt <- optimizer_sgd(lr = 0.1, momentum = 0.9, nesterov = TRUE) #Stochastic Gradient Descent

model %>% compile(
  optimizer = opt,
  loss = "categorical_crossentropy",
  metrics = "accuracy"
)

# Model fitting -----------------------------------------------------------

# callbacks for weights and learning rate
lr_schedule <- function(epoch) {
  
  if(epoch <= 150) {
    0.1
  } else if(epoch > 150 && epoch <= 225){
    0.01
  } else {
    0.001
  }
  
}

lr_reducer <- callback_learning_rate_scheduler(lr_schedule)

history <- model %>% fit(
  x_train, y_train, 
  batch_size = batch_size, 
  epochs = epochs, 
  validation_data = list(x_test, y_test), 
  callbacks = list(
    lr_reducer
  )
)

densenet_history<-history
densenet_model<-model

save_model_hdf5(densenet_history, filepath = "C:")

save(file="project.RData")

plot(history)
evaluate(model, x_test, y_test)

save(densenet_model, file = "my_model.rda")
save(densenet_model, file = "my_model.Rdata")
save(densenet_model, file="my_model.RData")
saveRDS(densenet_model, "my_model.rds")

save("myobject", file = "myobject.RData")
load("myobject.RData")

saveRDS(model, "densenet_history.rds")
densenet_history <- readRDS('/tmp/test.rds')
load

?application_densenet
#th main.lua -netType densenet -dataset cifar10 -batchSize 64 
#               -nEpochs 300 -depth 100 -growthRate 12 -optMemory 4