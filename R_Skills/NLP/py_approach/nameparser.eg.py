#Name Parser
#See https://github.com/derek73/python-nameparser
	#first download the module via `pip install nameparser` in the command line
from nameparser import HumanName
name = HumanName("Jack Riley Scott")
print name.last 
print name.as_dict()

#Attempting a more complex sentence
sent = "Vladimir Putin is an asshole in Russia. But Barak Obama is okay."
names = HumanName(sent)
print names.as_dict() #As you can see...this is only for names, not for extracting.
