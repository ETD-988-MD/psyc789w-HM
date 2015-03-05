#Proper Noun Extractor to be Read into R
#def pn_extractor(text):
#	import nltk
#	tokens = nltk.word_tokenize(text)
#	tagged = nltk.pos_tag(tokens)
#	entities = nltk.chunk.ne_chunk(tagged)
#	parsed = nltk.chunk.tree2conlltags(entities)
#	#Extracting the proper nouns from the sentence.
#	for i in range(0,len(parsed)):
#		parsed = nltk.chunk.tree2conlltags(entities)
#		if parsed[i][2] == "B-PERSON" and parsed[i+1][2] == "B-PERSON":
#			return parsed[i][0] + " " + parsed[i+1][0]
#		elif parsed[i][2] == "B-PERSON" and parsed[i+1][2] == "I-PERSON":
#			return parsed[i][0] + " " + parsed[i+1][0]
#		elif parsed[i][2] == "I-PERSON" and parsed[i+1][2] == "I-PERSON":
#			return parsed[i][0] + " " + parsed[i+1][0]
#		elif parsed[i][2] == "I-PERSON" and parsed[i+1][2] == "B-PERSON":
#			return parsed[i][0] + " " + parsed[i+1][0]

test1 = "Vladimir Putin had a telephone conversation with Federal Chancellor of Germany Angela Merkel, President of the French Republic Francois Hollande and President of Ukraine Petro Poroshenko."

#names = pn_extractor(test1)
#print names


#debugging --- but still in progress
import nltk
text = test1
output = []
tokens = nltk.word_tokenize(text)
tagged = nltk.pos_tag(tokens)
for i in range(0,len(tagged)):
	if tagged[i][1] == "NNP":
		temp = tagged[i][0]	
		output.append(temp)
entities = nltk.chunk.ne_chunk(nltk.pos_tag(output))
parsed = nltk.chunk.tree2conlltags(entities)
print parsed


