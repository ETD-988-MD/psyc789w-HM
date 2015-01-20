#######   MAPS  ########

install.packages("ggmap")
require(ggmap)
exeratio <- read.csv("exe_access_ratio.csv", sep=",", header=T)
View(exeratio)
install.packages("rworldmap")
require(rworldmap)
#To view inside the function: mapCountryData()

map1 <- joinCountryData2Map(exeratio,
                            joinCode = "NAME", 
                            nameJoinColumn = "country",
                            verbose=T)
par(mai=c(0,0,0.2,0),xaxs="i",yaxs="i")
mapParams <- mapCountryData(map1, 
                            nameColumnToPlot="incl.ratio",
                            mapTitle='Worldwide Group Access to Central Government',
                            #aspect=1,
                            addLegend=FALSE )
do.call( addMapLegend, c(mapParams, legendWidth=0.5, legendMar = 2))


#install.packages("RColorBrewer")
require(RColorBrewer)
Purple <- brewer.pal(6, "Purples")

#Another shot at a regional display
#Eurasia
par(mai=c(0,0,0.2,0),xaxs="i",yaxs="i")
eurasia <-mapCountryData( map1,
                nameColumnToPlot='incl.ratio',
                catMethod='pretty',
                mapTitle='Group Access to Central Government in Europe',
                colourPalette=Purple,
                oceanCol='white',
                missingCountryCol='white',
                mapRegion='Eurasia',
                borderCol='black',
                lwd=.5,
                addLegend=F)
do.call( addMapLegend, c(eurasia, legendWidth=0.5, legendMar = 2, horizontal=T))

######Colors for the maps#####
OrRd <- brewer.pal(4, "OrRd")
Oranges <- brewer.pal(3, "Oranges")
BuGn <- brewer.pal(2,"BuGn")
Greens <- brewer.pal(5,"Greens")

#Africa - grey
par(mai=c(0,0,0.2,0),xaxs="i",yaxs="i")
africa <- mapCountryData( map1,
                          nameColumnToPlot='incl.ratio',
                          catMethod='pretty',
                          mapTitle='Group Access to Central Government in Africa',
                          colourPalette= 'white2Black', #Oranges,
                          oceanCol='white',
                          missingCountryCol='white',
                          mapRegion='Africa',
                          borderCol='black',
                          lwd=.5,
                          addLegend=F,
                          add=F)
do.call( addMapLegend, c(africa, legendWidth=0.5, legendMar = 2, horizontal=T))

#More Maps
socrelmap <- mapCountryData(map1, 
                            nameColumnToPlot='total.no.groups',
                            mapTitle='Number of Socially Relevant Groups',
                            catMethod='pretty',
                            colourPalette=Oranges, 
                            oceanCol='white',
                            missingCountryCol='white',
                            aspect=1,
                            addLegend=F )

#Inclusion by quartile
qworld <- mapCountryData(map1, 
                         nameColumnToPlot="incl.quartile",
                         mapTitle='Worldwide Group Access to Central Government',
                         catMethod='categorical',
                         colourPalette=Oranges,
                         addLegend=F )
qworld$legendText <- c('0-25%','26-50%',
                          '51-75%',
                          '76-100%') 
do.call( addMapLegendBoxes, c(qworld,x='bottomleft',title="Inclusion into the Executive",
                              cex=.75, pt.cex=1, horiz=F))

barplotCountryData( exeratio
                    , nameColumnToPlot = "total.no.groups"
                    , nameCountryColumn = "NAME"                   
                    , numPanels = 4  
                    , scaleSameInPanels = FALSE
                    , main="nameColumnToPlot"
                    , numCats = 5  
                    , catMethod="quantiles"                             
                    , colourPalette= "heat"
                    , addLegend=TRUE
                    , toPDF = FALSE
                    , outFile = ""
                    , decreasing = TRUE
                    , na.last = TRUE
                    , cex = 0.7)   
mapBubbles(map1, nameZSize="grgdpch",nameZColour="grgdpch"
           ,colourPalette='topo',numCats=5,catMethod="quantiles")

##### MAPS with GGMAPS #####
map.world <- map_data(map = "world")
str(map.world)
length(unique(map.world$region))
length(unique(map.world$group))

p1 <- ggplot(map.world)
p1 <- p1 + geom_polygon(aes(x=long, y=lat, group=group, fill=country), 
                         data = exeratio, colour="grey30", alpha=.75, size=.2) 
p1 <- p1 + geom_path(aes(x=incl.ratio, y=group=country), data=exeratio, color='black')
p1 <- p1 + labs(title = "World, plain") + theme_bw()
print(p1)

ggworld <- ggplot(map.world, aes(x = long, y = lat, group = group, 
                                 fill=region)) + geom_polygon() + 
                                theme(legend.position="none") + 
                                labs(title = "World, filled regions") + theme_bw()
ggworld

p <- get_map(location="world", zoom=4, maptype="toner", source='stamen')



########################
######### Plots ####
########################

#Graph looking at GDP growth
g1 <- ggplot(exeratio, aes(x=incl.ratio, y=grgdpch, size=total.no.groups,label=""),guide=T)+
  geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
  scale_y_continuous(name="2009 Growth GDP", limits=c(-25,25))+
  geom_text(size=4)+
  theme_bw()  + labs(title = "GDP Growth")
g1

#Similar graph to the one above looking at HDI
g2 <- ggplot(exeratio, aes(x=incl.ratio, y=IHDI.2012, size=total.no.groups,label=""),guide=T)+
  geom_point(colour="white", fill="darkblue", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
  scale_y_continuous(name="IHDI 2012", limits=c(0,1))+
  geom_text(size=4)+
  theme_bw() + labs(title = "Human Development Index (Adjusted)")
g2

#Graph only accounting for more authoritarian regimes
g3 <- ggplot(auth, aes(x=incl.ratio, y=grgdpch, size=total.no.groups,label=""),guide=T)+
  geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
  scale_y_continuous(name="2009 Growth GDP", limits=c(-25,25))+
  geom_text(size=4)+
  theme_bw() + labs(title = "GDP Growth (Only Authoritarian Regimes)")
g3

#same but with IHDI
g4 <- ggplot(auth, aes(x=incl.ratio, y=IHDI.2012, size=total.no.groups,label=""),guide=T)+
  geom_point(colour="white", fill="darkblue", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
  scale_y_continuous(name="IHDI 2012", limits=c(0,1))+
  geom_text(size=4)+
  theme_bw() + labs(title = "Human Development Index (Only Authoritarin Regimes)")
g4

#Graph only accounting for more Democratic regimes
g5 <- ggplot(democ, aes(x=incl.ratio, y=grgdpch, size=total.no.groups,label=""),guide=T)+
  geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
  scale_y_continuous(name="2009 Growth GDP", limits=c(-25,25))+
  geom_text(size=4)+
  theme_bw() + labs(title = "GDP Growth (Only Democratic Regimes)")
g5

#same but with IHDI
g6 <- ggplot(democ, aes(x=incl.ratio, y=IHDI.2012, size=total.no.groups,label=""),guide=T)+
  geom_point(colour="white", fill="darkblue", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
  scale_y_continuous(name="IHDI 2012", limits=c(0,1))+
  geom_text(size=4)+
  theme_bw() + labs(title = "Human Development Index (Only Democratic Regimes)")
g6

require(gridExtra)
plots <- grid.arrange(g1, g2, g3, g4, g5, g6, ncol=2, main="Findings Thus Far Utilizing GRGDPCH (2009) and the IHDI (2012) Variables to Measure Development")
plots

###########################
#### ANALYSIS #####
###########################

#Plot of inclusion ratio given the total no. of socially relevant groups there are.
qplot(exeratio$total.no.groups,exeratio$incl.ratio) + theme_bw() + 
  labs(x="Total Number of Groups In Country", y="Executive Inclusion Proportion", title = "Access to the Executive Given Group Size")
#As the number of groups (as one might expect) the inclusion ratio decreases. 

#Penn World Data
install.packages("pwt")
require(pwt)
data("pwt7.0")
penn <- subset(pwt7.0, year==2009,select = c(country,isocode,year,pop,grgdpch))
View(penn)
write.csv(penn,"pwt7.0.csv")

#I've grafted the relevant variable on my working dataset.
exeratio <- read.csv("exe_access_ratio.csv", sep=",", header=T)
View(exeratio)

#quick OLS reg to see if there is even a statistically significant relationship
summary(lm(exeratio$grgdpch~exeratio$incl.ratio+exeratio$total.no.groups+exeratio$polity.2009))
summary(lm(exeratio$IHDI.2012~exeratio$incl.ratio+exeratio$total.no.groups+exeratio$polity.2009))

  #For only authoritarian, we lose statistical significance
  summary(lm(auth$grgdpch~auth$incl.ratio+auth$total.no.groups))
  #For only democracies, inclusion ratio is only stat sig at .1 level
  summary(lm(democ$grgdpch~democ$incl.ratio+democ$total.no.groups))

#xy visualization
qplot(exeratio$incl.ratio, exeratio$grgdpch)
qplot(exeratio$incl.ratio, exeratio$IHDI.2012)

#Authoritarian Regime subset (using polity iv data)
auth <- subset(exeratio, polity.2009 <= 0, select=c("country", "incl.ratio", "incl.quartile", "total.no.groups", 
                                                    "grgdpch", "HDI.2012",
                                                    "IHDI.2012"))
View(auth)

#Democratic Regime subset (using polity iv data)
democ <- subset(exeratio, polity.2009 >= 1, select=c("country", "incl.ratio", "incl.quartile", "total.no.groups", 
                                                     "grgdpch", "HDI.2012",
                                                     "IHDI.2012"))
View(democ)

#Simple xy graphs for auth using development indicators
qplot(auth$incl.ratio, auth$grgdpch) + geom_abline() + theme_bw() 
qplot(auth$incl.ratio, auth$IHDI.2012) + geom_abline() + theme_bw() 

#simple xy graphs for democ using development indicators
qplot(democ$incl.ratio, democ$grgdpch) + geom_abline() + theme_bw() 
qplot(democ$incl.ratio, democ$HDI.2012) + geom_abline() + theme_bw() 


#There is nothing really here. 

##################################
##### DAY 2 - Making the maps work
##################################
require(plyr)

wmap <- map1
wmap <- fortify(wmap)
wmap <- ddply(wmap, exeratio)

x <- ggplot(map1)
x <- x + geom_polygon(colour = "grey30", size = 3.0)
x <- x + stat_bin2d(
  aes(x = long, y = lat, colour = "grey30", fill = total.no.groups),
  size = .5, bins = 30, alpha = 1/2,
  data = exeratio
)
x

fuck <- ggplot(map1) + geom_polygon(aes(x=long,y=lat,group=group), fill='grey30') + theme_bw() 
fuck


world <- get_map("world", zoom=2)
world2 <- ggmap(world, extent="device", legend="bottomleft")
world2

############################
#######  After B.'s Email ##
############################

#First, Let's load up the pen data to create growth averages using the grgdpch variable.
require(pwt)
data("pwt7.0")
View(pwt7.0)
attach(pwt7.0)
penn2 <- data.frame(country,isocode,year,pop,grgdpch)
View(penn2)
detach(pwt7.0)
#Average Growth from 1950-2010
meangrowth <- aggregate(grgdpch~country, data=penn2, FUN=function(penn2) c(mean=mean(penn2), count=length(penn2)))
View(meangrowth) 

#Merging this to the existing dataset
exeratio2 <- merge(meangrowth[,2], exeratio, by =exeratio[,1])
View(exeratio2)     
meangrowth[,2]
exeratio[,1]     
exeratio2 <- merge(exeratio,meangrowth, by="country", sort=F)
#Alas, we can't just merge these data frames due to the inconsistency in how the countries are labeled. 
#So---we have to do this the hard way.
rm(exeratio2)
write.csv(meangrowth,"grgdpch_mean.csv")        

#The values were manually compared. Also, regions were added to the exeratio dataset.
#Loading revised dataset
exeratio <- read.csv("exe_access_ratio.csv", sep=",", header=T)
View(exeratio)

########### NEW PLOTS W/ MEAN GRGDPCH VARIABLE #########

#Graph looking at GDP growth
#Aggregate
ggplot(exeratio, aes(x=incl.ratio, y=grgdpch.mean, size=total.no.groups,label=""),guide=T)+
  geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
  scale_y_continuous(name="Mean Growth GDP (grgdpch)", limits=c(-10,10))+
  geom_text(size=4)+
  theme_bw()  + labs(title = "GDP Growth")

#Only Authoritarian
ggplot(auth, aes(x=incl.ratio, y=grgdpch.mean, size=total.no.groups,label=""),guide=T)+
  geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
  scale_y_continuous(name="Mean Growth GDP (grgdpch)", limits=c(-10,10))+
  geom_text(size=4)+
  theme_bw() + labs(title = "GDP Growth (Only Authoritarian Regimes)")

#Only Democratic
ggplot(democ, aes(x=incl.ratio, y=grgdpch.mean, size=total.no.groups,label=""),guide=T)+
  geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
  scale_y_continuous(name="Mean Growth GDP (grgdpch)", limits=c(-10,10))+
  geom_text(size=4)+
  theme_bw() + labs(title = "GDP Growth (Only Democratic Regimes)")

#Still, the effect isn't there. Let's focus on *just* non-OECD countries
#Manually entered the new values for OECD countries...see other Do_File

#Graph of Non-OECD countires GDP growth
ggplot(nonOECD, aes(x=incl.ratio, y=grgdpch.mean, size=total.no.groups,label=""),guide=T)+
  geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
  scale_y_continuous(name="Mean Growth GDP (grgdpch)", limits=c(-5,10))+
  geom_text(size=4)+
  theme_bw() + labs(title = "GDP Growth (Non-OECD Countries)")

#Graph of Non-OECD countires HDI 2012
ggplot(nonOECD, aes(x=incl.ratio, y=HDI.2012, size=total.no.groups,label=""),guide=T)+
  geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
  scale_y_continuous(name="IHDI 2012", limits=c(0,1))+
  geom_text(size=4)+
  theme_bw() + labs(title = "Human Development Index")

#Graph of Non-OECD countires IHDI 2012
ggplot(nonOECD, aes(x=incl.ratio, y=IHDI.2012, size=total.no.groups,label=""),guide=T)+
  geom_point(colour="white", fill="darkblue", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
  scale_y_continuous(name="IHDI 2012", limits=c(0,1))+
  geom_text(size=4)+
  theme_bw() + labs(title = "Human Development Index (Adjusted)")

#Graph looking at growth given total # of groups
ggplot(nonOECD, aes(x=total.no.groups, y=grgdpch.mean, size=incl.ratio,label=""),guide=T)+
  geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Total Number of Groups", limits=c(0,40))+
  scale_y_continuous(name="Mean Growth GDP (grgdpch)", limits=c(-5,10))+
  geom_text(size=4)+
  theme_bw() + labs(title = "GDP Growth (Non-OECD Countries)")

#Graph looking at IHDI 2012 given total # of groups
ggplot(nonOECD, aes(x=total.no.groups, y=IHDI.2012, size=incl.ratio,label=""),guide=T)+
  geom_point(colour="white", fill="darkblue", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Total Number of Groups", limits=c(0,40))+
  scale_y_continuous(name="IHDI 2012", limits=c(0,1))+
  geom_text(size=4)+
  theme_bw() + labs(title = "Human Development Index (Adjusted)")

#None of these graphs are too informative... hmmm... one more thing:

#Graph y=ratio x=total.no.groups size=growth
ggplot(nonOECD, aes(y=incl.ratio, x=total.no.groups, size=grgdpch.mean,label=""),guide=T)+
  geom_point(colour="white", fill="darkgreen", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Total Number of Groups", limits=c(0,40))+
  scale_y_continuous(name="Inclusion Proportion", limits=c(0,1))+
  geom_text(size=4)+
  theme_bw() + labs(title = "GDP Growth (Non-OECD Countries)")

#Graph y=ratio x=total.no.groups size=IHDI
ggplot(nonOECD, aes(y=incl.ratio, x=total.no.groups, size=IHDI.2012,label=""),guide=T)+
  geom_point(colour="white", fill="darkgreen", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Total Number of Groups", limits=c(0,40))+
  scale_y_continuous(name="Inclusion Proportion", limits=c(0,1))+
  geom_text(size=4)+
  theme_bw() + labs(title = "GDP Growth (Non-OECD Countries)")

#Well, that's still uninformative.

#Graph that only looks at non-OECD countries with the largest population of socially relevant groups
    #First, Create the subset
     groups <- subset(nonOECD, total.no.groups >= 5, select=c("country", "incl.ratio", "incl.quartile", "total.no.groups", 
                                        "grgdpch", "HDI.2012", "polity.2009",
                                        "IHDI.2012", "grgdpch.mean","grgdpch.count", "region"))

ggplot(groups, aes(x=incl.ratio, y=grgdpch.mean, label=""),guide=T)+
  geom_point(colour="white", fill="black", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
  scale_y_continuous(name="Mean Growth GDP (grgdpch)", limits=c(-5,10))+
  geom_text(size=4)+
  theme_bw() + labs(title = "GDP Growth (Non-OECD Countries that have more than 5 groups)")

#Maybe *by region*?
    #New subset
    africa <- subset(exeratio, region=="SSAfrica", select=c("country", "incl.ratio", "incl.quartile", "total.no.groups", 
                                        "grgdpch", "HDI.2012", "polity.2009",
                                        "IHDI.2012", "grgdpch.mean","grgdpch.count", "region"))
    
      asia <- subset(exeratio, region=="Asia", select=c("country", "incl.ratio", "incl.quartile", "total.no.groups", 
                                                        "grgdpch", "HDI.2012", "polity.2009",
                                                        "IHDI.2012", "grgdpch.mean","grgdpch.count", "region"))

#Africa
ggplot(africa, aes(x=incl.ratio, y=grgdpch.mean, size=total.no.groups,label=""),guide=T)+
  geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
  scale_y_continuous(name="Mean Growth GDP (grgdpch)", limits=c(-10,10))+
  geom_text(size=4)+
  theme_bw()  + labs(title = "GDP Growth (Africa Only)")

ggplot(africa, aes(x=incl.ratio, y=IHDI.2012, size=total.no.groups,label=""),guide=T)+
  geom_point(colour="white", fill="darkblue", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
  scale_y_continuous(name="IHDI 2012", limits=c(0,1))+
  geom_text(size=4)+
  theme_bw() + labs(title = "Inequality Human Development Index (Africa Only)")

#Asia
ggplot(asia, aes(x=incl.ratio, y=grgdpch.mean, size=total.no.groups,label=""),guide=T)+
  geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
  scale_y_continuous(name="Mean Growth GDP (grgdpch)", limits=c(-10,10))+
  geom_text(size=4)+
  theme_bw()  + labs(title = "GDP Growth (Asia Only)")

ggplot(asia, aes(x=incl.ratio, y=IHDI.2012, size=total.no.groups,label=""),guide=T)+
  geom_point(colour="white", fill="darkblue", shape=21)+ scale_area(range=c(1,25))+
  scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
  scale_y_continuous(name="IHDI 2012", limits=c(0,1))+
  geom_text(size=4)+
  theme_bw() + labs(title = "Inequality Human Development Index (Asia Only)")

#############
###### Different Measures #####
#############

#Let's focus on "averages" of HDI over a decades span. 
#Manual inclusion of these variables
exeratio <- read.csv("exe_access_ratio.csv", sep=",", header=T)
View(exeratio)

#Aggregate glance -- 
          #Aggregate - HDI Growth Ave 1980-1990
          ggplot(exeratio, aes(x=incl.ratio, y=HDI.ave.8090, size=total.no.groups,label=""),guide=T)+
            geom_point(colour="white", fill="darkblue", shape=21)+ scale_area(range=c(1,25))+
            scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
            scale_y_continuous(name="HDI Average '80-'90", limits=c(0,5))+
            geom_text(size=4)+
            theme_bw() + labs(title = "Average Human Development Index (1980-1990)")
          
          #Aggregate - HDI Growth Ave 1980-1990 (non-OECD)
          ggplot(nonOECD, aes(x=incl.ratio, y=HDI.ave.8090, size=total.no.groups,label=country),guide=T)+
            geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
            scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
            scale_y_continuous(name="HDI Average '80-'90", limits=c(0,5))+
            geom_text(size=4)+
            theme_bw() + labs(title = "Average Human Development Index (1980-1990) - Non-OECD Only")
          
          #Aggregate - HDI Growth Ave 1990-2000
          ggplot(exeratio, aes(x=incl.ratio, y=HDI.ave.9000, size=total.no.groups,label=""),guide=T)+
            geom_point(colour="white", fill="darkblue", shape=21)+ scale_area(range=c(1,25))+
            scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
            scale_y_continuous(name="HDI Average '80-'90", limits=c(0,5))+
            geom_text(size=4)+
            theme_bw() + labs(title = "Average Human Development Index (1990-2000)")
          
          #Aggregate - HDI Growth Ave 1990-2000 (non-OECD)
          ggplot(nonOECD, aes(x=incl.ratio, y=HDI.ave.9000, size=total.no.groups,label=country),guide=T)+
            geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
            scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
            scale_y_continuous(name="HDI Average '80-'90", limits=c(0,5))+
            geom_text(size=4)+
            theme_bw() + labs(title = "Average Human Development Index (1990-2000) - Non-OECD Only")
          
          #Aggregate - HDI Growth Ave 2000-2012 (non-OECD)
          ggplot(nonOECD, aes(x=incl.ratio, y=HDI.ave.0012, size=total.no.groups,label=country),guide=T)+
            geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
            scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
            scale_y_continuous(name="HDI Average '80-'90", limits=c(0,5))+
            geom_text(size=4)+
            theme_bw() + labs(title = "Average Human Development Index (1990-2000) - Non-OECD Only")

#Regional Glances

#Africa
        #Africa - HDI Growth Ave 1980-1990
         ggplot(africa, aes(x=incl.ratio, y=HDI.ave.8090, size=total.no.groups,label=country),guide=T)+
          geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
          scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
          scale_y_continuous(name="HDI Average '80-'90", limits=c(0,4))+
          geom_text(size=4)+
          theme_bw() + labs(title = "Average Human Development Index (1980-1990) - Africa Only") 
        
        #Africa - HDI Growth Ave 1990-2000
        ggplot(africa, aes(x=incl.ratio, y=HDI.ave.9000, size=total.no.groups,label=country),guide=T)+
          geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
          scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
          scale_y_continuous(name="HDI Average '80-'90", limits=c(0,4))+
          geom_text(size=4)+
          theme_bw() + labs(title = "Average Human Development Index (1990-2000) - Africa Only")
        
        #Africa - HDI Growth Ave 2000-2012
        ggplot(africa, aes(x=incl.ratio, y=HDI.ave.0012, size=total.no.groups,label=country),guide=T)+
          geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
          scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
          scale_y_continuous(name="HDI Average '80-'90", limits=c(0,5))+
          geom_text(size=4)+
          theme_bw() + labs(title = "Average Human Development Index (1990-2000) - Africa Only")

        #Test - Africa (3 decades stacked)
        ggplot(africa, aes(x=incl.ratio, y=HDI.ave.8090, size=total.no.groups,label=""),guide=T)+
          geom_point(colour="white", fill="lightgrey", shape=21) + geom_point(data=africa, aes(x=incl.ratio, y=HDI.ave.9000, size=total.no.groups), colour="white", fill="grey", shape=21)+
          geom_point(data=africa, aes(x=incl.ratio, y=HDI.ave.0012, size=total.no.groups, label=country), colour="white", fill="darkgrey", shape=21)+scale_area(range=c(1,25))+
          scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
          scale_y_continuous(name="HDI Average 1980-2012", limits=c(0,4))+
          geom_text(size=4)+
          theme_bw() + labs(title = "Average Human Development Index (1980-1990) - Africa Only") 

#Asia

          #Asia - HDI Growth Ave 1980-1990
          ggplot(asia, aes(x=incl.ratio, y=HDI.ave.8090, size=total.no.groups,label=country),guide=T)+
            geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
            scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
            scale_y_continuous(name="HDI Average '80-'90", limits=c(0,4))+
            geom_text(size=4)+
            theme_bw() + labs(title = "Average Human Development Index (1980-1990) - Asia Only") 
          
          #Asia - HDI Growth Ave 1990-2000
          ggplot(asia, aes(x=incl.ratio, y=HDI.ave.9000, size=total.no.groups,label=country),guide=T)+
            geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
            scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
            scale_y_continuous(name="HDI Average '80-'90", limits=c(0,4))+
            geom_text(size=4)+
            theme_bw() + labs(title = "Average Human Development Index (1990-2000) - Asia Only")
          
          #Asia - HDI Growth Ave 2000-2012
          ggplot(asia, aes(x=incl.ratio, y=HDI.ave.0012, size=total.no.groups,label=country),guide=T)+
            geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
            scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
            scale_y_continuous(name="HDI Average '80-'90", limits=c(0,5))+
            geom_text(size=4)+
            theme_bw() + labs(title = "Average Human Development Index (1990-2000) - Asia Only")

#Middle East

        #ME - HDI Growth Ave 1980-1990
        ggplot(Meast, aes(x=incl.ratio, y=HDI.ave.8090, size=total.no.groups,label=country),guide=T)+
          geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
          scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
          scale_y_continuous(name="HDI Average '80-'90", limits=c(0,4))+
          geom_text(size=4)+
          theme_bw() + labs(title = "Average Human Development Index (1980-1990) - Middle East Only") 
        
        #ME - HDI Growth Ave 1990-2000
        ggplot(Meast, aes(x=incl.ratio, y=HDI.ave.9000, size=total.no.groups,label=country),guide=T)+
          geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
          scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
          scale_y_continuous(name="HDI Average '80-'90", limits=c(0,4))+
          geom_text(size=4)+
          theme_bw() + labs(title = "Average Human Development Index (1990-2000) - Middle East Only")
        
        #ME - HDI Growth Ave 2000-2012
        ggplot(Meast, aes(x=incl.ratio, y=HDI.ave.0012, size=total.no.groups,label=country),guide=T)+
          geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
          scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
          scale_y_continuous(name="HDI Average '80-'90", limits=c(0,5))+
          geom_text(size=4)+
          theme_bw() + labs(title = "Average Human Development Index (2000-2012) - Middle East Only")

#Okay focusing on Africa might be the way to go. 

#Let's combine Northern Africa and Southern Africa
Allafrica <- rbind(africa, Meast)
View(Allafrica)
write.csv(Allafrica, "Allafrica.csv")
Allafrica <- read.csv("Allafrica.csv", sep=",", header=T)
Allafrica <- subset(Allafrica, Allafrica==1, select=(all=T))
View(Allafrica)

#All of Africa
      #Africa - HDI Growth Ave 1980-1990
      ggplot(Allafrica, aes(x=incl.ratio, y=HDI.ave.8090, size=total.no.groups,label=country),guide=T)+
        geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
        scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
        scale_y_continuous(name="HDI Average '80-'90", limits=c(0,4))+
        geom_text(size=4)+
        theme_bw() + labs(title = "Average Human Development Index (1980-1990) - Africa Only") 
      
      #Africa - HDI Growth Ave 1990-2000
      ggplot(Allafrica, aes(x=incl.ratio, y=HDI.ave.9000, size=total.no.groups,label=country),guide=T)+
        geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
        scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
        scale_y_continuous(name="HDI Average '80-'90", limits=c(0,4))+
        geom_text(size=4)+
        theme_bw() + labs(title = "Average Human Development Index (1990-2000) - Africa Only")
      
      #Africa - HDI Growth Ave 2000-2012
      ggplot(Allafrica, aes(x=incl.ratio, y=HDI.ave.0012, size=total.no.groups,label=country),guide=T)+
        geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
        scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
        scale_y_continuous(name="HDI Average '80-'90", limits=c(0,5))+
        geom_text(size=4)+
        theme_bw() + labs(title = "Average Human Development Index (1990-2000) - Africa Only")

#For GDP growth, let's do it by 10yr averages from 1980-2012
        Grw <- subset(penn2, year >= 1980 & year <= 1990, select=(all=T))
        Grw <- aggregate(grgdpch~country, data=Grw, FUN=function(Grw) c(mean=mean(Grw), count=length(Grw)))
        View(Grw) #GDP growth from 1980 - 1990
        Grw2 <- subset(penn2, year >= 1990 & year <= 2000, select=(all=T))
        Grw2 <- aggregate(grgdpch~country, data=Grw2, FUN=function(Grw2) c(mean=mean(Grw2), count=length(Grw2)))
        View(Grw2) #GDP growth from 1990 - 2000
        Grw3 <- subset(penn2, year >= 2000 & year <= 2012, select=(all=T))
        Grw3 <- aggregate(grgdpch~country, data=Grw3, FUN=function(Grw3) c(mean=mean(Grw3), count=length(Grw3)))
        View(Grw3) #GDP growth from 2000- 2012
        
        write.csv(Grw, "growth_by_decade_1980_1990.csv")
        write.csv(Grw2, "growth_by_decade_1990_2000.csv")
        write.csv(Grw3, "growth_by_decade_2000_2012.csv")
        
        #Growth by decade average has been incorporated into the csv.
        exeratio <- read.csv("exe_access_ratio.csv", sep=",", header=T)
        View(exeratio)

####Graphs of growth with decage average GRGDPCH

#SSAfrica
        ggplot(africa, aes(x=incl.ratio, y=grgdpch.mean.8090, size=total.no.groups,label=country),guide=T)+
          geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
          scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
          scale_y_continuous(name="GDP Growth Average '80-'90", limits=c(-10,10))+
          geom_text(size=4)+
          theme_bw() + labs(title = "GDP Growth (1980-1990) - Africa Only") 
        
        ggplot(africa, aes(x=incl.ratio, y=grgdpch.mean.9000, size=total.no.groups,label=country),guide=T)+
          geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
          scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
          scale_y_continuous(name="GDP Growth Average '90-'00", limits=c(-10,10))+
          geom_text(size=4)+
          theme_bw() + labs(title = "GDP Growth (1990-2000) - Africa Only") 
        
        ggplot(africa, aes(x=incl.ratio, y=grgdpch.mean.0012, size=total.no.groups,label=country),guide=T)+
          geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
          scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
          scale_y_continuous(name="GDP Growth Average '00-'12", limits=c(-10,10))+
          geom_text(size=4)+
          theme_bw() + labs(title = "GDP Growth (2000-2012) - Africa Only") 

#Asia
          ggplot(asia, aes(x=incl.ratio, y=grgdpch.mean.8090, size=total.no.groups,label=country),guide=T)+
            geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
            scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
            scale_y_continuous(name="GDP Growth Average '80-'90", limits=c(-10,10))+
            geom_text(size=4)+
            theme_bw() + labs(title = "GDP Growth (1980-1990) - Asia Only") 
          
          ggplot(asia, aes(x=incl.ratio, y=grgdpch.mean.9000, size=total.no.groups,label=country),guide=T)+
            geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
            scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
            scale_y_continuous(name="GDP Growth Average '90-'00", limits=c(-10,10))+
            geom_text(size=4)+
            theme_bw() + labs(title = "GDP Growth (1990-2000) - Asia Only") 
          
          ggplot(asia, aes(x=incl.ratio, y=grgdpch.mean.0012, size=total.no.groups,label=country),guide=T)+
            geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
            scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
            scale_y_continuous(name="GDP Growth Average '00-'12", limits=c(-10,10))+
            geom_text(size=4)+
            theme_bw() + labs(title = "GDP Growth (2000-2012) - Asia Only") 
          
#Middle East
          ggplot(Meast, aes(x=incl.ratio, y=grgdpch.mean.0012, size=total.no.groups,label=country),guide=T)+
            geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
            scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
            scale_y_continuous(name="GDP Growth Average '00-'12", limits=c(-10,10))+
            geom_text(size=4)+
            theme_bw() + labs(title = "GDP Growth (2000-2012) - Middle East Only")

#Latin America
          ggplot(LA, aes(x=incl.ratio, y=grgdpch.mean.0012, size=total.no.groups,label=country),guide=T)+
            geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
            scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
            scale_y_continuous(name="GDP Growth Average '00-'12", limits=c(-10,10))+
            geom_text(size=4)+
            theme_bw() + labs(title = "GDP Growth (2000-2012) - Latin America Only")

#Growth just isn't that useful of an indicator. Let's stick with HDI and see what B. says from there. 

#Let's average all the yearly averages of HDI to see if there is any effect.
                    AV <- aggregate(HDI.ave.8090+HDI.ave.9000+HDI.ave.0012~country, data=exeratio, FUN=mean)
                    View(AV)
                    names(AV)
                    
                    colnames(AV)[2] <- "ave"
                    View(AV)
                    AV$ave <- AV$ave/3
                    Poop <- merge(exeratio,AV, by="country")
                    View(Poop)
                    
                    #Is there anything here?
                    ggplot(Poop, aes(x=incl.ratio, y=ave, size=total.no.groups,label=country),guide=T)+
                      geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
                      scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
                      scale_y_continuous(name="HDI Average '80-'90", limits=c(0,4))+
                      geom_text(size=4)+
                      theme_bw() + labs(title = "Average Human Development Index") 
                    #Nope...Africa Only?
                    Poop <- subset(Poop, region=="SSAfrica", select=(all=T))
                    ggplot(Poop, aes(x=incl.ratio, y=ave, size=total.no.groups,label=country),guide=T)+
                      geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
                      scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
                      scale_y_continuous(name="HDI Average '80-'90", limits=c(0,2.5))+
                      geom_text(size=4)+
                      theme_bw() + labs(title = "Average Human Development Index - Africa Only") 
                    
                    #Maybe let's simplify this and only look at the 1990 >=
                    AV <- aggregate(HDI.ave.9000+HDI.ave.0012~country, data=exeratio, FUN=mean)
                    View(AV)
                    names(AV)
                    
                    colnames(AV)[2] <- "ave"
                    View(AV)
                    AV$ave <- AV$ave/2
                    Poop <- merge(exeratio,AV, by="country")
                    View(Poop)
                    
                    #First...
                    ggplot(Poop, aes(x=incl.ratio, y=ave, size=total.no.groups,label=country),guide=T)+
                      geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
                      scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
                      scale_y_continuous(name="HDI Average '80-'90", limits=c(0,4))+
                      geom_text(size=4)+
                      theme_bw() + labs(title = "Average Human Development Index") 
                    #Africa only...
                    Poop <- subset(Poop, region=="SSAfrica", select=(all=T))
                    ggplot(Poop, aes(x=incl.ratio, y=ave, size=total.no.groups,label=country),guide=T)+
                      geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
                      scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
                      scale_y_continuous(name="HDI Average '80-'90", limits=c(0,4))+
                      geom_text(size=4)+
                      theme_bw() + labs(title = "Average Human Development Index - Africa Only") 
                    #ME
                    Poop <- subset(Poop, region=="Middle_East", select=(all=T))
                    ggplot(Poop, aes(x=incl.ratio, y=ave, size=total.no.groups,label=country),guide=T)+
                      geom_point(colour="white", fill="red", shape=21)+ scale_area(range=c(1,25))+
                      scale_x_continuous(name="Inclusion Proportion", limits=c(0,1))+
                      scale_y_continuous(name="HDI Average '80-'90", limits=c(0,4))+
                      geom_text(size=4)+
                      theme_bw() + labs(title = "Average Human Development Index - Asia Only") 
                    
                    #Nothing here....at least looking at it from this angle. 
                    rm(AV)
                    rm(Poop)


        #only looking at groups where inclusion mostly likely matters the most
        poop1 <- subset(exeratio, total.no.groups>=10, select=(all=T))
        poop2 <- subset(poop1, exclude==0, select=(all=T))
        poop2 <- subset(poop2, OECD.dummy==0, select=(all=T))
        View(poop2)
        
        ggplot(poop2, aes(x=incl.ratio, y=grgdpch.mean, label=""),guide=T)+
          geom_point(colour="white", fill="red", size=4, shape=21)+ scale_area(range=c(1,25))+
          scale_x_continuous(name="", limits=c(0,1))+
          scale_y_continuous(name="", limits=c(-10,10))+
          geom_text(size=4) + #geom_smooth(method=lm) +
          theme_bw() + labs(title = "")
#Still nothing...

ggplot(auth, aes(x=polity.2009, y=incl.ratio)) + geom_point()
# nothing

testdata <- exeratio
testdata$regime.type[testdata$polity.2009 <= -6] <- "1very.auth"
testdata$regime.type[testdata$polity.2009 <=0 & testdata$polity.2009 >=-5] <- "2somewhat.auth"
testdata$regime.type[testdata$polity.2009 >=1 & testdata$polity.2009 <= 5] <- "3somewhat.demo"
testdata$regime.type[testdata$polity.2009 >= 6] <- "4very.dem"
testdata$regime.type[testdata$polity.2009 == "NA"] <- NA

ggplot(na.omit(testdata), aes(x=regime.type, y=incl.ratio, colour=regime.type, size=total.no.groups)) + geom_point(position = position_jitter(w = 0.1)) +
  theme_bw() +scale_size_area()

#### New GPD Measure
peek <- read.csv("wb_GDPgrowth_80_12.csv")
newlook <- exeratio
newlook <- merge(newlook,peek, by="country.code")
View(newlook) #Shitty second Country column--remove later
rm(peek) #remove GDP upload to reduce object clutter
#Again with SSA data
SSAnewlook <- SSAdata #Some cases have been excluded. 
SSAnewlook <- merge(SSAnewlook,peek, by="country.code")
View(SSAnewlook) #close enough 40 out of 41 ... check later for the difference. 
rm(peek) #remove GDP upload to reduce object clutter


ggplot(SSAnewlook, aes(x=incl.ratio.y, y=X2012)) + geom_point()

t(peek)
peek <- data.frame(peek)
View(peek)
peek <- ts(SSAnewlook, start=c("X1980"), end=c("X2013"), frequency=1)

q()
y









