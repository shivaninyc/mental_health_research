# mental_health_research
[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/shivaninyc/mental_health_research/blob/master/LICENSE)

Regression Research on Mental Health Data

## Purpose of this research
To better understand how we can improve the way we treat incarcerated women with PTSD and SUD to reduce total number of offenses.

## Goal of this regression study
To predict whether an incarcerated women with PTSD and SUD is likely to return to jail or not.

## Input Data Set
The study involves 29 females who are part of a controlled experiment of Incarcerated Women With Substance Use Disorder and Post-Traumatic Stress Disorder in Providence, Rhode Island

29 females are a combination of 3 groups
1. Women under medical treatment for PTSD and SUD
2. Control group (do not receive any medical treatment)
3. Non randomized-open trial

The data set contains 23 attributes and missing values are denoted by value 99 or 9.

## Steps I took
* Filled in missing values with the median value of rest of data pts
* Narrowed down to 23 attributes based on background knowledge of
psychology, PTSD, SUD and seeking safety
* Developed correlation matrix of 23 attributes and removed some variables
to get rid of multicollinearity
* Built the model using forward, backward and stepwise selection.
* Ran the Cook’s D and DFFITS with my final model to find and remove outliers

## Conclusion
Final Model:
PRISON = -1.71867*HOMEWORK - 0.06635*TOTALB

* Higher HOMEWORK and TOTALB indicate better mental health
* Negatively correlated with PRISON (higher PRISON means more likely to return to jail quickly)
* Mental health treatment is important to reduce total number of offenses
* Need to change prison system
