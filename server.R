suppressMessages(suppressWarnings(library(shiny)))
suppressMessages(suppressWarnings(library(dplyr)))
suppressMessages(suppressWarnings(library(data.table)))
suppressMessages(suppressWarnings(library(tm)))
suppressMessages(suppressWarnings(library(stringr)))
suppressMessages(suppressWarnings(library(stylo)))

ng1 <- readRDS("dictionary.Rds")
ng2 <- readRDS("2g.Rds")
ng3 <- readRDS("3g.Rds")
ng4 <- readRDS("4g.Rds")

textClean <- function(text){
        cleantext <- removeNumbers(text)
        cleantext <- removePunctuation(cleantext)
        cleantext <- tolower(cleantext)
        cleantext <- str_replace_all(cleantext, "[^[:alnum:]]", " ")
        cleantext <- stripWhitespace(cleantext)
        return(cleantext)
}

predictNextWord <- function(inputPhrase){
        wordsInput <- textClean(inputPhrase)
        wordsInput <- txt.to.words.ext(wordsInput, language = "English.all", preserve.case = TRUE)
        wordCount <- length(wordsInput)
        
        if(wordCount==1){
                findWordsNg2 <- filter(ng2, grepl(paste0("^", wordsInput, " "), Word)) %>% arrange(desc(Frequency))
                nextWord <- head(findWordsNg2$lastword)
        }else if(wordCount==2){
                findWordsNg3 <- filter(ng3, grepl(paste0("^", paste(wordsInput[1],wordsInput[2]), " "), Word)) %>% 
                        arrange(desc(Frequency)) %>% 
                        mutate(ratio = Frequency/sum(Frequency)) %>% 
                        select(lastword, ratio)
                findWordsNg2 <- filter(ng2, grepl(paste0("^", wordsInput[2], " "), Word)) %>% 
                        arrange(desc(Frequency)) %>% 
                        mutate(ratio = Frequency/sum(Frequency) * 0.4) %>%
                        select(lastword, ratio)
                findWords <- rbind(findWordsNg3, findWordsNg2) %>% 
                        group_by(lastword) %>% 
                        summarise(r = sum(ratio)) %>% 
                        arrange(desc(r))
                nextWord <- head(findWords$lastword)
        }else{
                findWordsNg4 <- filter(ng4, grepl(paste0("^", paste(wordsInput[wordCount-2],wordsInput[wordCount-1],wordsInput[wordCount]), " "), Word)) %>% 
                        arrange(desc(Frequency)) %>% 
                        mutate(ratio = Frequency/sum(Frequency)) %>%
                        select(lastword, ratio)
                findWordsNg3 <- filter(ng3, grepl(paste0("^", paste(wordsInput[wordCount-1],wordsInput[wordCount]), " "), Word)) %>% 
                        arrange(desc(Frequency)) %>% 
                        mutate(ratio = Frequency/sum(Frequency) * 0.4) %>% 
                        select(lastword, ratio)
                findWordsNg2 <- filter(ng2, grepl(paste0("^", wordsInput[wordCount], " "), Word)) %>% 
                        arrange(desc(Frequency)) %>% 
                        mutate(ratio = Frequency/sum(Frequency) * 0.4 * 0.4) %>% 
                        select(lastword, ratio)
                findWords <- rbind(findWordsNg4, findWordsNg3, findWordsNg2) %>% 
                        group_by(lastword) %>% 
                        summarise(r = sum(ratio)) %>% 
                        arrange(desc(r))
                nextWord <- head(findWords$lastword)
        }
        return(nextWord)
}

shinyServer(
        function(input, output){
                getPhrase <- eventReactive(input$go, {input$phrase})
                outputWord <- reactive({predictNextWord(getPhrase())})
                output$predict <- renderText({
                        outputWord()[1]
                })
                output$suggest <- renderText({
                        paste0(outputWord()[-1], sep=" | ")
                })
        }
)
