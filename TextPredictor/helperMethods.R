library(stringr)
library(tm)

cleanInput <- function(str) {
  str <- tolower(str)
  str <- removeNumbers(str)
  str <- removePunctuation(str)
  str <- str_trim(str)
  
  return(str)
}

# Calculate probabilities needed for Laplace Smoothing
setProbabilities <- function() {
  V <- nrow(unigram_dt)
  
  unigram_dt$probabilities <<- (unigram_dt$count + 1)/ (sum(unigram_dt$count) + V)
  bigram_dt$probabilities <<- (bigram_dt$count + 1)/ (unigram_dt[bigram_dt, on = 'word1']$count + V)
  trigram_dt$probabilities <<- (trigram_dt$count +1) / (bigram_dt[trigram_dt, on = .(word1, word2)]$count + V)
  fougram_dt$probabilities <<- (fougram_dt$count +1) / (trigram_dt[fougram_dt, on = .(word1, word2, word3)]$count + V)
  fivegram_dt$probabilities <<- (fivegram_dt$count +1) / (fougram_dt[fivegram_dt, on = .(word1, word2, word3, word4)]$count + V)
}
