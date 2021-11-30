library(data.table)
library(sqldf)
library(stringr)
library(qdap)

source("./helperMethods.R")

stupidBackOffAlgo <- function(str) {
  wordList <- data.table(word = character(), score = numeric())
  
  str <- cleanInput(str)
  str_length <- wc(str)
  
  if (is.na(str_length)) { return(wordList) } 
  
  if (str_length > 4) { 
    words <- word(str, start = -4:-1)
  } else {
    words <- str_split(str, " ", simplify = TRUE)
  }
  
  wordCount <- length(words)
  wordList <- data.table(word = character(), score = numeric())
  
  exp <- wordCount
  
  for (i in wordCount:1) {
    matches <- getNgramResults(words, i, predict = TRUE)
    
    if (nrow(matches) > 0) {
      count = 1
      res <- getNgramResults(words, i, predict = FALSE)
      
      while(count <= nrow(matches)) {
        score <- (.4^exp * matches[count,]$count) / res$count

        word <- matches[count,][i+1]$word
        wordList <- rbind(wordList, list(word, score))
        count <- count + 1
      }
    }
    
    exp <- exp + 1
  }
  
  if (nrow(wordList) == 0) {
    return(wordList)
  }
  
  wordList <- aggregate(. ~ word, data=wordList, FUN=sum)
  max_length <- ifelse(nrow(wordList) > 5, 5, nrow(wordList))
  wordList <- wordList[order(wordList$score, decreasing=TRUE),][1:max_length, ]
  
  return(wordList)
}

getNgramResults <- function(text, n, predict = TRUE) {
  matches <- vector();
  
  if (n == 4) {
    db <- ifelse(predict, 'fivegram_dt', 'fougram_dt')
    matches <- sqldf(
      sprintf(
        "select * from '%s' where word1= '%s' and word2 = '%s' and word3 = '%s' and word4 = '%s'",
        db,text[1], text[2], text[3], text[4]
      )
    )
  } else if (n == 3) {
    db <- ifelse(predict, 'fougram_dt', 'trigram_dt')
    matches <- sqldf(
      sprintf(
        "select * from '%s' where word1= '%s' and word2 = '%s' and word3 = '%s'",
        db, text[length(text) - 2], text[length(text) - 1], text[length(text)]
      )
    )
  } else if (n == 2) {
    db <- ifelse(predict, 'trigram_dt', 'bigram_dt')
    matches <- sqldf(
      sprintf(
        "select * from '%s' where word1= '%s' and word2 = '%s'",
        db, text[length(text) - 1], text[length(text)]
      )
    )
  } else if (n == 1) {
    db <- ifelse(predict, 'bigram_dt', 'unigram_dt')
    matches <- sqldf(
      sprintf(
        "select * from '%s' where word1= '%s'",
        db, text[length(text)]
      )
    )
  }
  
  max_value <- ifelse(length(matches) > 3, 3, length(matches))
  
  if (predict && nrow(matches)) {
    return(matches[1:max_value, ])
  }
  
  return (matches)
}