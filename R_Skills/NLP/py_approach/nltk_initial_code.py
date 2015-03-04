from nltk.book import *
#this imports relevant texts

#### The nltk package uses `NumPy` and `Matplotlib`... both ofwhich need to be downloaded.


######## Basics ##############

#Here are a few basic features of the code
text1.concordance("monstrous") #Searches the text for a particular word and its surrounding features

text1.similar("monstrous") #searches for words used in a similar context. 

#There are analytical features that can also be utilized.
text4.dispersion_plot(["citizens", "democracy", "freedom", "duties", "America"]) #Such as a dispersion plot.

