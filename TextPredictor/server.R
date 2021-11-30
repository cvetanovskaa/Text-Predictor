library(DT)
library(shiny)

fivegram_dt <<- readRDS("en_fivegram_dt.rds")
fougram_dt <<- readRDS("en_fourgram_dt.rds")
trigram_dt <<- readRDS("en_trigram_dt.rds")
bigram_dt <<- readRDS("en_bigram_dt.rds")
unigram_dt <<- readRDS("en_unigram_dt.rds")

source("./StupidBackOff.R")
source("./LaplaceAlgo.R")
source("./helperMethods.R")

shinyServer(function(input, output) {
    output$sbo <- renderDataTable({
        text <- input$text
        stupid_back_off_recommendations <- stupidBackOffAlgo(text)

        DT::datatable(
            stupid_back_off_recommendations,
            options = list(paging = FALSE)
        )
    })
    
    output$laplace <- renderDataTable({
        text <- input$text
        laplace_recommendations <- laplaceAlgo(text)
        
        DT::datatable(
            laplace_recommendations,
            options = list(paging = FALSE)
        )
    })
    
    output$markdown <- renderUI({
        HTML(markdown::markdownToHTML(knit('Documentation.Rmd', quiet = TRUE)))
    })
})
