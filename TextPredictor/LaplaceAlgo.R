source("./helperMethods.R")

laplaceAlgo <- function(str) {
  
  setProbabilities()
  
  wordList <- data.table(word = character(), score = numeric())
  str <- cleanInput(str)
  str_length <- wc(str)
  
  if (is.na(str_length)) { return(wordList) } 
  
  if (str_length > 4) { 
    words <- word(str, start = -4:-1)
  } else {
    words <- str_split(str, " ", simplify = TRUE)
  }
  
  if (str_length >= 4) {
    wordList <- fivegram_dt[word1 == words[1] & word2 == words[2] & word3 == words[3] & word4 == words[4]]
  } else if (str_length == 3) {
    wordList <- fougram_dt[word1 == words[1] & word2 == words[2] & word3 == words[3]]
  } else if (str_length == 2) {
    wordList <- trigram_dt[word1 == words[1] & word2 == words[2]]
  } else if (str_length == 1) {
    wordList <- bigram_dt[word1 == words[1]]
  } else {
    return(wordList)
  }
  
  max_length <- ifelse(nrow(wordList) > 5, 5, nrow(wordList))
  wordList <- wordList[order(wordList$probabilities, decreasing=TRUE),][1:max_length, ]
  
  return(wordList)
}