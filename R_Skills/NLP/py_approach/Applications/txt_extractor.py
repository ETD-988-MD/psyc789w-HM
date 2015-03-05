#Text Extractor Function to be Fed into R

def txt_extractor(text):
	import textract
	return textract.process(text)

