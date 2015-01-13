#Eric Dunford - PSYC 789W - DAY 2 Homework
    rm(list=ls(all=T)) #Clearing the working space
    setwd("~/Dropbox/Coursework/Winter 2015/PSYC798W -R_Programming") 
    
# Complete all of the items below
# Use comments where you're having trouble or questions

# 1. Read your data set into R
    library(foreign)
    data = read.dta("Data/NAVCO_2.0.dta")
    #write.csv(data,"Data/NAVCO_2.0.csv") - better  format to share with Dr. J
    
# 2. Peek at the top few rows
    head(data)

# 3. Peek at the top few rows for only a few columns
    head(data)[1:4]
    
# 4. How many rows does your data have?
    length(data[[1]]) #1726
    #Another way to get this is to look at the # of obs in the data.frame

# 5. Get a summary for every column
    summary(data)

# 6. Get a summary for one column
    summary(data[2])
    #or
    summary(data$year)
    #Both get at the same thing

# 7. Are any of the columns giving you unexpected values?
#    - missing values? (NA)
    #Yes - there are a large majority of columns with missing values (NAs)
    #Other than that the Variables appear to have the appropriate class given what they measure
    #i.e. factor var are factors, numeric vars are numeric, etc. 

# 8. Select a few key columns, make a vector of the column names
    x = colnames(data)[c(2,3,4,10,12,13)]
    class(x) #Character Vector

# 9. Create a new data.frame with just that subset of columns
#    from #7  (DID YOU MEAN #8?)
#    - do this in at least TWO different ways
    sub = data[c(2,3,4,10,12,13)]
    #or
    sub = subset(data,select=x) #using the character vector assigned above
    #or
    sub = data[c("year","campaign","location","camp_size","camp_conf_intensity","rad_flank")]
    #Third way is the least efficient - and prone to typos!

# 10. Create a new data.frame that is just the first 10 rows
#     and the last 10 rows of the data from #8
    #I'm interpreting this as the head and tail of the subset I made in #9
    #but I will do it also for the larger data.frame
    
    #heads and tails of the subset
    sub.h = head(sub,10)
    sub.t = tail(sub,10)
    sub.ht = rbind(sub.h,sub.t)
    #A more efficient way of doing the same thing would be:
    sub.ht2 = sub[c(1:10,1717:1726),]
    
    #same for the larger data.frame
    data[c(1:10,1717:1726),] 
    
# 11. Create a new data.frame that is a random sample of half of the rows.
    1726/2 #863 == half of the DF
    sample = data[sample(nrow(data),863),] 
    #Random selection of half of the rows from the larger DF

# 12. Find a comparison in your data that is interesting to make
#     (comparing two sets of numbers)
#     - run a t.test for that comparison
#     - decide whether you need a non-default test
#       (e.g., Student's, paired)
#     - run the t.test with BOTH the formula and "vector"
#       formats, if possible
#     - if one is NOT possible, say why you can't do it
    
    #comparing whether a violent movement campaign is more likely to receiving external state support than non-violent ones
        #Vars: prim_method (use of violence of as a dominant strategy == 0, 1 otherwise); camp_support (1 if campaign
        # received external state support, 0 otherwise)
    t.test1 = t.test(data$camp_support,y=data$prim_method) #diff in means is stat. sig. at p-value < 2.2e-16
    #we need to run a paired t.test here, mainly because a diffenece in means between to the two variables
    #isn't sufficient. We want to compare the difference in means between the two groups.
    #That said, running a paired test isn't the best approach here...but I'll do it for the assignment's sake.
    t.test2 = t.test(data$camp_support,y=data$prim_method,paired=T)
    #The difference is stat. sign. at conventional levels (.05) when running a two-tailed test.
    
    #The best approach -- 
    #Comparing the difference in means between the two groups (violent vs. non-violent campaigns)
    t.test3 = t.test(data$camp_support[data$prim_method==0],data$camp_support[data$prim_method==1])
    #Another way to run the same thing using the "formula" approach
    t.test4 = t.test(camp_support~prim_method,data=data) 
    
    #putting the results of the test into a data.frame for easy comparison. 
    results = as.data.frame(rbind(t.test1,t.test2,t.test3,t.test4))
    
    
# 13. Repeat #10 for TWO more comparisons
#     - ALTERNATIVELY, if correlations are more interesting,
#       do those instead of t-tests (and try both Spearman and
#       Pearson correlations)
    
    #Here I'll choose correlations over t.tests - more interesting given the data I have.
    #Examining the correlation of the relationship in #12
    x1 = cor.test(data$camp_support,data$prim_method,method="pearson") #cor == -.195 (p-value = 1.909e-15)
    x2 = cor.test(data$camp_support,data$prim_method,method="spearman") #rho == -.195 (p-value = 1.909e-15)
    
    #Looking at a different relationship
    #is there a positive correlation between campaigns that have a social media presence (i.e. able to get the word out
    #about their cause) and the campaign's ability to attract NGO support?
    x3 = cor.test(data$pi_newmedia,data$ingo_support,method="pearson") #cor = 0.1299823 (p-value = 8.041e-06)
    x4 = cor.test(data$pi_newmedia,data$ingo_support,method="spearman") # rho = 0.1299823 (p-value = 8.041e-06)
    
    #Saving the results as a data.frame
    results.pearson = as.data.frame(rbind(x1,x3))
    results.spearman = as.data.frame(rbind(x2,x4))
    

# 14. Save all results from #12 and #13 in an .RData file
    #Here are the data.frames of the results along with the individual objects (i.e. the output of each test)
    save(results,results.pearson,results.spearman,
         t.test1,t.test2,t.test3,t.test4,x1,x2,x3,x4,file="Dunford_HM2_Results.Rdata")
    #Make sure everythign went through okay
    load("/Users/Ericdunford/Dropbox/Coursework/Winter 2015/PSYC798W -R_Programming/Dunford_HM2_Results.Rdata")
    #Good

# 15. Email me your version of this script, PLUS the .RData
#     file from #14
