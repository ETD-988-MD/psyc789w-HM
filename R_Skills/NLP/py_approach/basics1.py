import nltk
sentence = "Vladimir Putin is an asshole in Russia. But Barack Obama is okay."
tokens = nltk.word_tokenize(sentence)
tagged = nltk.pos_tag(tokens)
print tagged #Here we are breaking up main features of the sentence into their appropriate forms. 

#We can take this further
entities = nltk.chunk.ne_chunk(tagged)
#print entities #This can be presented as a "parsed tree"

print nltk.chunk.tree2conlltags(entities)

#Extracting the proper nouns from the sentence.
#for i in range(0,len(tagged)):
	#if tagged[i][1] == "NNP":
		#print tagged[i][0]

#Using the parsing approach for specificity
for i in range(0,len(entities)):
	parsed = nltk.chunk.tree2conlltags(entities)
	if parsed[i][2] == "B-PERSON" and parsed[i+1][2] == "B-PERSON":
		print parsed[i][0] + " " + parsed[i+1][0]
	elif parsed[i][2] == "B-PERSON" and parsed[i+1][2] == "I-PERSON":
		print parsed[i][0] + " " + parsed[i+1][0]
	elif parsed[i][2] == "I-PERSON" and parsed[i+1][2] == "I-PERSON":
		print parsed[i][0] + " " + parsed[i+1][0]
	elif parsed[i][2] == "I-PERSON" and parsed[i+1][2] == "B-PERSON":
		print parsed[i][0] + " " + parsed[i+1][0]
#Success
#-----------------------------------------

test1 = "Vladimir Putin had a telephone conversation with Federal Chancellor of Germany Angela Merkel, President of the French Republic Francois Hollande and President of Ukraine Petro Poroshenko. This was where Vladimir lived."
#More testing
#sent = nltk.sent_tokenize(test1) #The sentence distinction appears unnecessary 
tokens = nltk.word_tokenize(test1)
tagged = nltk.pos_tag(tokens)
entities = nltk.ne_chunk(tagged)
parsed = nltk.chunk.tree2conlltags(entities)
print parsed


nltk.sem.extract('ORG', 'LOC', test1,corpus='ieer')
	print nltk.sem.rtuple(rel)


















