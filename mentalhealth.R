#import libraries 
library(foreign)
library(calibrate)
library(anchors)

#import data set
mySASData <- read.xport('mentalhealth.xpt')

sink("mentalhealth.txt") ### SENDING THE OUTPUT TO FILE IN THE DIRECTORY 

#clean data set 
cat("replace 9/99/9.9999 values with NA\n\n")
mySASData = replace.value(mySASData, c("ABSTINEN","RESOURCE","COPING","SUPPORT","HOMEWORK","COPING","THERAP1","HANDOUT1","QUOTAT1","EXERCIS1","SEXUAL","PHYSICAL","REPEATED","GROUP","RELAPSE3"), from=9, to=NA, verbose = FALSE)
mySASData = replace.value(mySASData, c("TOTALA","TOTALB","TOTALC","TRAGE"), from=99, to=NA, verbose = FALSE)
mySASData = replace.value(mySASData, c("T2ETOH","T2DRUG","T3ETOH","T3DRUG"), from=9.9999, to=NA, verbose = FALSE)

#replace missing values with median values
cat("replace NA with median\n\n")
for (i in colnames(mySASData)){
  median_value = lapply(mySASData[i], median, na.rm = TRUE)
  mySASData = replace.value(mySASData, i, from=NA, to=median_value, verbose = FALSE)
}

#limit working data set columns to those of interest
my_data <- mySASData[, c("PRISON","ABSTINEN", "RESOURCE", "COPING", "SUPPORT" , "HOMEWORK" , "THERAP1" , "HANDOUT1" , "QUOTAT1" , "EXERCIS1" , "TOTALA" , "TOTALB" , "TOTALC" , "TRAGE" , "SEXUAL" , "PHYSICAL", "REPEATED" , "GROUP" , "RELAPSE3" , "T2ETOH" , "T2DRUG" , "T3ETOH" , "T3DRUG")]
# print the first 6 rows
#head(my_data, 6)



cat("correlation matrix \n\n")
res <- cor(my_data)
round(res, 2)

cat("take out: multicollinear variables - one in each pair of variables with high correlation\n\n")
cat("this way model will make more sense with background knowledge of psychology\n\n")
cat("and will not violate assumptions of linear regression\n\n")

cat("full model\n\n")
full=lm(PRISON~ RESOURCE + SUPPORT + HOMEWORK +TOTALB  + SEXUAL + T2ETOH, data=mySASData)
summary(full)

null=lm(PRISON~ 1, data=mySASData)

cat("forward selection \n\n")
step(null, scope=list(lower=null, upper=full), direction="forward")

forward = lm(PRISON ~ SUPPORT + TOTALB + HOMEWORK, data = mySASData)
cat("summary of forward\n\n")
summary(forward)

cat("backward selection\n\n")
step(full, scope=list(lower=null, upper=full), direction="backward")

cat("stepwise \n\n")
step(null, scope = list(upper=full), data=mySASData, direction="both")

backward_and_step = lm(PRISON ~ HOMEWORK + TOTALB, data = mySASData)

cat("summary of backward and step (both return same model)\n\n")
summary(backward_and_step)


cat("used factors from backwards selection to run Cook's d and DFFITS\n\n")
out <- lm(PRISON ~ HOMEWORK + TOTALB, data = mySASData)



cat("Cook's dd\n\n")
ck_ds<-cooks.distance(out)
ck_ds
plot(ck_ds,ylab="Cooks Distance",main = "Cooks D Plot")
top<-head(sort(ck_ds,decreasing = TRUE),2)
ck_ds_x<-as.numeric(names(top))
ck_ds_y<-top
min(top)
points(ck_ds_x,ck_ds_y,col='red')
textxy(ck_ds_x,ck_ds_y,ck_ds_x,cex=0.75)

cat("DFFITS\n\n")
library(olsrr)
ols_plot_dffits(out)

cat("removed points 14 and 26 - outliers\n\n")
mySASDataFinal = mySASData[-c(14,26), ]
cat("final model without ouliers\n\n")
finalModel <- lm(formula = PRISON ~ HOMEWORK + TOTALB, data = mySASDataFinal)
summary(finalModel)

sink()