#1. Exploring the housing data price column: Mean, Median, Mode
import pandas as pd

# Read in the dataset
data = pd.read_csv("C:\\Users\\alexi\\Desktop\\python project\\Housing_data.csv")

# Calculate the mean of the 'price' column
price_mean = data['price'].mean()

# Calculate the median of the 'price' column
price_median = data['price'].median()

# Calculate the mode of the 'price' column
price_mode = data['price'].mode()[0]

# Print the results
print("Mean price: {:.2f}".format(price_mean))
print("Median price: {:.2f}".format(price_median))
print("Mode price: {:.2f}".format(price_mode))



#2. Calculating the range, variance, and standard deviation
import numpy as np

# Convert data to numeric data type
data_numeric = pd.to_numeric(data["price"], errors="coerce")

# Calculate range, variance, and standard deviation
data_range = np.ptp(data_numeric)
data_range_int = int(data_range)
data_variance = np.var(data_numeric)
data_stdev = np.std(data_numeric)

print("Range:", data_range_int)
print("Variance:", data_variance)
print("Standard deviation:", data_stdev)

#What is the most expensive house?
print(max(data_numeric))

#What is the least expensive house?
print(min(data_numeric))



#3. Shape distribution of dataset 
from scipy.stats import skew, kurtosis 


# Calculate skewness and kurtosis
data_skewness = skew(data_numeric)
data_kurtosis = kurtosis(data_numeric)

# Print results
print("Skewness:", data_skewness)
print("Kurtosis:", data_kurtosis)






#4. Graphical Representation
import matplotlib.pyplot as plt 

price_data = data_numeric

print(data.columns)   # print column names
print(data.head())  

# Create a histogram of the housing prices to show frequency distribution
plt.hist(price_data, bins=50)
plt.xlabel("Price")
plt.ylabel("Frequency")
plt.title("Distribution of Housing Prices")
plt.show()

# Create a box plot of the housing prices
plt.boxplot(price_data)
plt.xlabel("Price")
plt.title("Box Plot of Housing Prices")
plt.show()

# Create a scatter plot of the living area vs price
plt.scatter(data["area"], price_data)
plt.xlabel("Living Area (sqft)")
plt.ylabel("Price")
plt.title("Scatter Plot of Living Area vs Price")
plt.show()



#5. Probability testing
from scipy.stats import f_oneway

#Note we use f_oneway to compare the means of the six groups 
# based on the number of bedrooms which are created by dividing 
# the dataset into six groups based on the number of bedrooms


# Convert "price" and "bedrooms" columns to numeric
price_num = pd.to_numeric(data["price"], errors="coerce")
bed_num = pd.to_numeric(data["bedrooms"], errors="coerce")

# Create groups based on the number of bedrooms
group1 = price_num.loc[bed_num == 1]
group2 = price_num.loc[bed_num == 2]
group3 = price_num.loc[bed_num == 3]
group4 = price_num.loc[bed_num == 4]
group5 = price_num.loc[bed_num == 5]
group6 = price_num.loc[bed_num == 6]

# Perform a one-way ANOVA test to compare the means of the six groups
f, p = f_oneway(group1, group2, group3, group4, group5, group6)

#Note: the f_oneway() function prints two values whoich are the f and p value hence why the code is written the way it is above



# Print the results
print("F-value: ", f)
print("p-value: ", p)



#6. Multiple regression for comparing price, bedrooms and area in square feet
import statsmodels.api as sm


# Select the predictor variables (bedrooms and area) and the response variable (price)
X = data[["bedrooms", "area"]]
y = data["price"]

# Add a constant to the predictor variables for the intercept term
X = sm.add_constant(X)

# Fit the multiple linear regression model
model = sm.OLS(y, X).fit()

# Print the model summary
print(model.summary())
