library(shiny)

shinyUI(fluidPage(
        titlePanel("Predict the Next Word"),
        h4("Coursera Data Science Capstone Project - Fan Wang", style="color:gray"),
        fluidRow(
                column(12,
                       br(),
                       h4("You can use this simple app to predict the next word after entering a phrase."),
                       h4("To use this app, simply type a phrase in the input box, and hit the Go button."),
                       h4("It will then output the word that appears most frequently in my N-gram Model as the predicted word."),
                       h4("It will also suggest other words that has lower probability than the above predicted word."),
                       h4("Now let's see how well this app can do with the small sample data."),
                       br()
                )
        ),
        
        fluidRow(
                column(10,
                       br(),
                       h1("Enter your phrase:", style="color: purple"),
                       p(
                               textInput("phrase", 
                                         label = "", 
                                         value = ""
                               )
                       ),
                       actionButton("go", "Go", style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
                       br(),
                       h4(textOutput("predict"), style="color:red"),
                       h4(textOutput("suggest"), style="color:blue")
                )    
        )
))