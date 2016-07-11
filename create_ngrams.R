setwd("C:/Users/frankwang/Desktop/Data Science/Capstone/ShinyApp/WordPrediction/")
conn_tokendata <- file("C:/Users/frankwang/Desktop/Data Science/Capstone/newsample/tokendata.txt", open = "r")
tokenData <- readLines(conn_tokendata)
close(conn_tokendata)
library(RWeka)
library(tm)
bigrams <- NGramTokenizer(tokenData, Weka_control(min = 2, max = 2))
df_bigrams <- data.frame(table(bigrams))
sort_bigrams <- df_bigrams[order(df_bigrams$Freq, decreasing = TRUE), ]
colnames(sort_bigrams) <- c("Word", "Frequency")
sort_bigrams$Word <- as.character(sort_bigrams$Word)
sort_bigrams$lastword <- sapply(strsplit(sort_bigrams$Word, " "), function(x) x[[2]])
saveRDS(sort_bigrams, "2g.Rds")

trigrams <- NGramTokenizer(tokenData, Weka_control(min = 3, max = 3))
df_trigrams <- data.frame(table(trigrams))
sort_trigrams <- df_trigrams[order(df_trigrams$Freq, decreasing = TRUE), ]
colnames(sort_trigrams) <- c("Word", "Frequency")
sort_trigrams$Word <- as.character(sort_trigrams$Word)
sort_trigrams$lastword <- sapply(strsplit(sort_trigrams$Word, " "), function(x) x[[3]])
saveRDS(sort_trigrams, "3g.Rds")

quadgrams <- NGramTokenizer(tokenData, Weka_control(min = 4, max = 4))
df_quadgrams <- data.frame(table(quadgrams))
sort_quadgrams <- df_quadgrams[order(df_quadgrams$Freq, decreasing = TRUE), ]
colnames(sort_quadgrams) <- c("Word", "Frequency")
sort_quadgrams$Word <- as.character(sort_quadgrams$Word)
sort_quadgrams$lastword <- sapply(strsplit(sort_quadgrams$Word, " "), function(x) x[[4]])
saveRDS(sort_quadgrams, "4g.Rds")

