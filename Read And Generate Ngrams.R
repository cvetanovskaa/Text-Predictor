library(dplyr)
library(quanteda)

# Generate 1,2,3,4 & 5-grams from a portion of the data we have available in
# English. Firstly, we sample 10% of the data, since there is a significant 
# amount, then, we tokenize and clean it, and finally generate the n-grams which 
# are stored in easily-accessible files

generateNgrams() {
  conTwitter <- file("en_US/en_US.twitter.txt", "r")
  conBlog <- file("en_US/en_US.blogs.txt", "r")
  conNews <- file("en_US/en_US.news.txt", "r")
  
  twitter <- data.frame("text" = readLines(conTwitter, skipNul=TRUE))
  blogs <- data.frame("text" = readLines(conBlog, skipNul=TRUE))
  news <- data.frame("text" = readLines(conNews, skipNul=TRUE))
  
  close(conTwitter)
  close(conBlog)
  close(conNews)
  
  combined_dataset <- rbind(
    sample_n(twitter, nrow(twitter)*.10),
    sample_n(blogs, nrow(blogs)*.10),
    sample_n(news, nrow(news)*.10)
  )
  
  my_corp <- corpus(combined_dataset)
  en_tokens <- tokens(
    tolower(my_corp),
    remove_punct = TRUE,
    remove_symbols = TRUE,
    remove_numbers = TRUE
  ) %>% tokens_wordstem()
  
  five_dfm <- createDfm(5)
  four_dfm <- createDfm(4)
  tri_dfm <- createDfm(3)
  bi_dfm <- createDfm(2)
  uni_dfm <- createDfm(1)
  
  save(five_dfm, file = 'en_fivegram_dfm.RData')
  save(four_dfm, file = 'en_fourgram_dfm.RData')
  save(tri_dfm, file = 'en_trigram_dfm.RData')
  save(bi_dfm, file = 'en_bigram_dfm.RData')
  save(uni_dfm, file = 'en_unigram_dfm.RData')
  
  sorted_unigram_sums <- sortDfm(uni_dfm)
  sorted_bigram_sums <- sortDfm(bi_dfm)
  sorted_trigram_sums <- sortDfm(tri_dfm)
  sorted_fourgram_sums <- sortDfm(four_dfm)
  sorted_fivegram_sums <- sortDfm(five_dfm)
  
  save(sorted_unigram_sums, file = 'en_sorted_unigram_sums.RData')
  save(sorted_bigram_sums, file = 'en_sorted_bigram_sums.RData')
  save(sorted_trigram_sums, file = 'en_sorted_trigram_sums.RData')
  save(sorted_fourgram_sums, file = 'en_sorted_fourgram_sums.RData')
  save(sorted_fivegram_sums, file = 'en_sorted_fivegram_sums.RData')
  
  unigram_dt <- data.table(
    word1 = names(sorted_unigram_sums),
    count = sorted_unigram_sums
  )
  bigram_dt <- data.table(
    word1 = sapply(strsplit(names(sorted_bigram_sums), " "), `[`, 1),
    word2 = sapply(strsplit(names(sorted_bigram_sums), " "), `[`, 2),
    count = sorted_bigram_sums
  )
  trigram_dt <- data.table(
    word1 = sapply(strsplit(names(sorted_trigram_sums), " "), `[`, 1),
    word2 = sapply(strsplit(names(sorted_trigram_sums), " "), `[`, 2),
    word3 = sapply(strsplit(names(sorted_trigram_sums), " "), `[`, 3),
    count = sorted_trigram_sums
  )
  fougram_dt <- data.table(
    word1 = sapply(strsplit(names(sorted_fourgram_sums), " "), `[`, 1),
    word2 = sapply(strsplit(names(sorted_fourgram_sums), " "), `[`, 2),
    word3 = sapply(strsplit(names(sorted_fourgram_sums), " "), `[`, 3),
    word4 = sapply(strsplit(names(sorted_fourgram_sums), " "), `[`, 4),
    count = sorted_fourgram_sums
  )
  fivegram_dt <- data.table(
    word1 = sapply(strsplit(names(sorted_fivegram_sums), " "), `[`, 1),
    word2 = sapply(strsplit(names(sorted_fivegram_sums), " "), `[`, 2),
    word3 = sapply(strsplit(names(sorted_fivegram_sums), " "), `[`, 3),
    word4 = sapply(strsplit(names(sorted_fivegram_sums), " "), `[`, 4),
    word5 = sapply(strsplit(names(sorted_fivegram_sums), " "), `[`, 5),
    count = sorted_fivegram_sums
  )
  
  save(unigram_dt, file = 'en_unigram_dt.rds')
  save(bigram_dt, file = 'en_bigram_dt.rds')
  save(trigram_dt, file = 'en_trigram_dt.rds')
  save(fougram_dt, file = 'en_fougram_dt.rds')
  save(fivegram_dt, file = 'en_fivegram_dt.rds')
}

createDfm <- function(n) {
  return(dfm(tokens_ngrams(toks, n = n, concatenator = " ")))
}

sortDfm <- function(ngram_dfm, n = 3) {
  return(sort(colSums(ngram_dfm[,colSums(ngram_dfm) > n]), decreasing = TRUE))
}