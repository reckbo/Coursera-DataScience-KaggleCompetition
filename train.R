library(randomForest)


clean_data <- function (d) {
    soilvars <- paste0('Soil_Type', 1:40)
    areavars <- paste0('Wilderness_Area', 1:4)
    nonattributes <- c(soilvars, areavars, 'Id', 'Cover_Type')

    # Turn soil variables into a single factor variable
    soils <- mapply(`*`, d[,soilvars], 1:40)
    soil <- factor(Reduce(`+`, data.frame(soils)), levels=1:40)

    # Turn wilderness area variables into a single factor variable
    areas <- mapply(`*`, d[,areavars], 1:4)
    area <- factor(Reduce(`+`, data.frame(areas)), levels=1:4)

    #subset(d, select=-c(Id, Cover_Type, soilvars, areavars))
    atts <- subset(d, select=setdiff(names(d), nonattributes))
    cbind(atts, soil=soil, area=area)
}

clean_data2 <- function (d) {
    soilvars <- paste0('Soil_Type', 1:40)
    areavars <- paste0('Wilderness_Area', 1:4)
    hydrologyvars <- c('Horizontal_Distance_To_Hydrology', 
                       'Vertical_Distance_To_Hydrology')
    nonattributes <- c(hydrologyvars, soilvars, areavars, 'Id', 'Cover_Type')

    # Turn soil variables into a single factor variable
    soils <- mapply(`*`, d[,soilvars], 1:40)
    soil <- factor(Reduce(`+`, data.frame(soils)), levels=1:40)

    # Turn wilderness area variables into a single factor variable
    areas <- mapply(`*`, d[,areavars], 1:4)
    area <- factor(Reduce(`+`, data.frame(areas)), levels=1:4)

    # Turn hydrology variables into a single variable
    distance_to_hydrology <- mapply(function (x,y) { sqrt(x^2 + y^2) }, 
                                    d$Horizontal_Distance_To_Hydrology,
                                    d$Vertical_Distance_To_Hydrology)

    #subset(d, select=-c(Id, Cover_Type, soilvars, areavars))
    atts <- subset(d, select=setdiff(names(d), nonattributes))
    cbind(atts, soil=soil, area=area, distance_to_hydrology=distance_to_hydrology)
}

load_data <- function(csv, clean_fun) {
    d <- read.csv(csv)
    if('Cover_Type' %in% names(d)) cbind(clean_fun(d), cover=factor(d$Cover_Type))
    else clean_fun(d)
}

train <- function (trainingdata) {
    model <- randomForest(cover ~ ., data=trainingdata)
}

train_importance <- function (trainingdata) {
    model <- randomForest(cover ~ ., data=trainingdata, importance=T)
}

train_reduced <- function (trainingdata) {
    t <- subset(trainingdata, select=c(Elevation, 
                                       soil, 
                                       Horizontal_Distance_To_Roadways, 
                                       area, 
                                       Horizontal_Distance_To_Fire_Points,
                                       Horizontal_Distance_To_Hydrology,
                                       Vertical_Distance_To_Hydrology,
                                       Hillshade_9am,
                                       cover))
    model <- randomForest(cover ~ ., data=t)
}


predict_testdata <- function (model) {
    d <- read.csv('test.csv')
    testdata <- clean_data(d)
    pred <- predict(model, type='response', newdata=testdata)
    data.frame(Id=d$Id, Cover_Type=as.integer(pred))
}

write_prediction <- function (p, filename) {
    write.csv(p, file=filename, row.names=F)
}

accuracy <- function (model, data) {
    p <- predict(model, type='response', newdata=data)
    sum(data$cover==p) / length(p)
}


trainingdata <- load_data('train.csv', clean_data)

# Split into training and test data
set.seed(2); ind <- sample(2, nrow(data), replace = TRUE, prob=c(0.8, 0.2))

# Exploring
#m <- train(trainingdata[ind==1,])
#accuracy(model, trainingdata[ind==2,])

# Submitting
#m <- train(trainingdata)
#p <- predict_testdata(m)
#write_prediction(p, 'rf_submission3.csv')
