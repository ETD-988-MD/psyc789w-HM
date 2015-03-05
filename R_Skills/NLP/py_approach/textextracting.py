#Text Extract???
	#see http://datascopeanalytics.com/what-we-think/2014/07/27/extract-text-from-any-document-no-muss-no-fuss
#This appears to be an integrated text miner capable of extracting a large range of textual materials.
import textract
text = textract.process("/Users/Ericdunford/Desktop/Expanding.pdf")
print text[0:100] #This is pretty powerful!

#Let's try something else
pdf = textract.process("/Users/Ericdunford/Desktop/psyc789w-HM/test.pdf")
print pdf

help(textract)


pdf = pdf.replace('.','') #removing the unneeded punctuation
import nltk
words = nltk.word_tokenize(pdf)
print len(words)
print nltk.chunk.ne_chunk(nltk.pos_tag(words[0:100])) #Still a work in progress...2.5.15