
https://www.kaggle.com/c/forest-cover-type-prediction/download/train.csv.zip
https://www.kaggle.com/c/forest-cover-type-prediction/download/sampleSubmission.csv.zip
https://www.kaggle.com/c/forest-cover-type-prediction/download/test.csv.zip

# The challenge

Land management agencies keep inventories of natural resources, and as part of
this they want to know the forest cover type of their forests.  Generally,
there are two ways of getting this information: via remote sensing, and sending
personnel into the field to manually record the cover type.  However, these
options may be unavailable due to being be prohibitively time consuming,
costly, or legally impossible ([Blackard 98][2]).  But what if we have
cartographic information available to us, such as elevation, slope, distance to
water features, incident sunlight - can we use this data to predict cover type?
This is the question we explore in this challenge.


# The Data

The data comprises observations of 30m x 30m patches in four wilderness ares in
the Roosevelt National Forest of northern Colorado.  Twelve independent
variables were derived using data from the US Geological Survey and US Forest
Services ([Blackard 98][2]):

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
* Soil_Type (40 binary columns, 0 = absence or 1 = presence) - Soil Type designation

We want to predict the cover type:

* Cover_Type (integers 1 to 7) - Forest Cover Type designation

    1. Spruce/Fir
    2. Lodgepole Pine
    3. Ponderosa Pine
    4. Cottonwood/Willow
    5. Aspen
    6. Douglas-fir
    7. Krummholz


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

([UCI MLR][1])



[1]: https://archive.ics.uci.edu/ml/datasets/Covertype
[2]: http://www.cs.ucdavis.edu/~matloff/matloff/public_html/132/Data/ForestCover/BlackardDean.pdf


