#### Human Name Parser ####
def name_parser(text):
	from nameparser import HumanName
	name = HumanName(text)
	output = [name.first,name.middle,name.last]
	return output
#Debugging test
#print name_parser("Jack Riley Jordan Christopher Scott")