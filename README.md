# The challenge

Land management agencies record inventories of natural resources, and a key
part of this includes mapping the predominant species of tree througout their
forests.  Generally there are two ways of getting this forest cover type:
remote sensing, and sending personnel into the field to manually record it.
However, these options may be prohibitively time consuming, costly, or legally
impossible ([Blackard 98][]).  But what if we have cartographic information
available to us, such as elevation, slope, distance to water features, incident
sunlight - can we use this data to predict cover type?  This is the question we
explore in this challenge.


# The Data

The data comprises observations of 30m x 30m patches in four wilderness ares in
the Roosevelt National Forest of northern Colorado.  Twelve independent
variables were derived using data from the US Geological Survey and US Forest
Services ([Blackard 98][]):

* Elevation - Elevation in meters
* Aspect - Aspect in degrees azimuth
* Slope - Slope in degrees
* Horizontal_Distance_To_Hydrology - Horz Dist to nearest surface water features
* Vertical_Distance_To_Hydrology - Vert Dist to nearest surface water features
* Horizontal_Distance_To_Roadways - Horz Dist to nearest roadway
* Hillshade_9am (0 to 255 index) - Hillshade index at 9am, summer solstice
* Hillshade_Noon (0 to 255 index) - Hillshade index at noon, summer solstice
* Hillshade_3pm (0 to 255 index) - Hillshade index at 3pm, summer solstice
* Horizontal_Distance_To_Fire_Points - Horz Dist to nearest wildfire ignition points
* Wilderness_Area (4 binary columns, 0 = absence or 1 = presence) - Wilderness area designation
* Soil_Type (40 binary columns, 0 = absence or 1 = presence) - Soil Type designation (see [Kaggle][] for a qualitative description of each soil type)

From these varaiables, we want to predict the cover type:

* Cover_Type (integers 1 to 7)  
    1 - Spruce/Fir  
    2 - Lodgepole Pine  
    3 - Ponderosa Pine  
    4 - Cottonwood/Willow  
    5 - Aspen  
    6 - Douglas-fir  
    7 - Krummholz  

Kaggle provides a labeled training data set of 15,120 observations, and an
unlabeled test data set of 565,892 observations to be used for the submission.

* training set of 15,120 observations: https://www.kaggle.com/c/forest-cover-type-prediction/download/train.csv.zip
* test set of 565,892 observations: https://www.kaggle.com/c/forest-cover-type-prediction/download/test.csv.zip
* sample submission: https://www.kaggle.com/c/forest-cover-type-prediction/download/sampleSubmission.csv.zip

([Kaggle - Forest cover type prediction][Kaggle])


# Additional Information

The four wilderness areas are

* Rawah (area 1)
    - probably lodgepole pine (type 2) as their primary species, followed by spruce/fir (type 1) and aspen (type 5).
* Neota (area 2) 
    - probably has the highest mean elevational value of the 4 wilderness areas.  
    - would have spruce/fir (type 1)
* Comanche Peak (area 3) 
    - probably lodgepole pine (type 2) as their primary species, followed by spruce/fir (type 1) and aspen (type 5).
* Cache la Poudre (area 4) 
    - lowest mean elevational value
    - would tend to have Ponderosa pine (type 3), Douglas-fir (type 6), and cottonwood/willow (type 4). 

> "The Rawah (area 1) and Comanche Peak (area 3) areas would tend to be more
typical of the overall dataset than either the Neota (area 2) or Cache la
Poudre (area 4), due to their assortment of tree species and range of
predictive variable values (elevation, etc.) Cache la Poudre (area 4) would
probably be more unique than the others, due to its relatively low elevation
range and species composition."
([UCI MLR][])

# Method

First, I cleaned the data by collapsing the 40 individual soil columns into one
called 'soil', and the 4 individual wilderness area columns into one called
'area' (Prior to this I confirmed that they were mutually exclusive as
expected).  Next, I chose a random forest as my predictive model for three
reasons: 1)  I wanted to improve my intuition using this type of model, 2) The
data was evenly split between labels,  which would otherwise make this model a
bad choice, and 3) in general random forests perform well ([Caruana 06][]), and
I wanted to start with this as my baseline.  As my first attempt, I used all 12
variables.  For all experiments that follow, I randomly split the training data
into 80% training and 20% test, and evaluate the model on the 20% test set.
Once I am happy with the result, I train the model on 100% of the training
data, and apply it to the test submission data and upload the predictions to
Kaggle.

Initially I chose Haskell's HLearn library to implement the random forest, but,
it being a relatively young library, the classifier examples were not up to
date and I could not compile non-trivial examples.  After this I moved to R and
installed the `randomForest` package and subsequently used that.

My first random forest with no adjustments achieved an 81% accuracy on the 20%
test data set, and 73% accuracy on the test submission data set as reported by
Kaggle, and I think this was a good start.  Next I wanted to see if I could
improve it by dropping the least significant variables and tweaking the
model's parameters.

I tried 3 new approaches: 1) I trained a new model using only the top 5
variables as rated by the Gini purity score (in R this would be reported by
running `importance(model)` or `model$importance`), 2) I merged the horizontal
and vertical distances to water features into one euclidean distance feature,
and 3) I adjusted the random forest's `nodesize` parameter (sets the minimal
size of the tree's terminal nodes) and I toggled the `importance` flag (the
importance of predictors are assessed).

My first approach of using only the top 5 feature variables reduced the
training accuracy to 63%.  Even dropping one or two variables reduced accuracy
to around 68%.  My second approach of combining the two distance to water
variables had little effect, reducing accuracy by a couple of percent.  My
third approach reduced accuracy for all adjustments I made to the `nodesize`
parameter (5, 40, 100). However, setting `importance=TRUE` improved accuracy by
2%, so I decided to use this model for a new submission to Kaggle.
Unfortunately this did not improve my result and was 1.5% worse than my first
submission.


[UCI MLR]: https://archive.ics.uci.edu/ml/datasets/Covertype "UCI Machine Learning Repository"
[Blackard 98]: http://www.cs.ucdavis.edu/~matloff/matloff/public_html/132/Data/ForestCover/BlackardDean.pdf "Comparative accuracies of artificial neural networks and discriminant analysis in predicting forest cover types from cartographic variables"
[Kaggle]: https://www.kaggle.com/c/forest-cover-type-prediction/data "Kaggle competition page"
[Caruana 06]: http://www.cs.cornell.edu/~caruana/ctp/ct.papers/caruana.icml06.pdf "Empirical comparison of supervised learning algorithms"
