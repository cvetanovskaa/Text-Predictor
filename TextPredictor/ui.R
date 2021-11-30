library(DT)
library(shiny)
library(shinymaterial)
library(shinythemes)
library(knitr)

shinyUI(fluidPage(theme = shinytheme("spacelab"),
                  titlePanel("Data Science Capstone Project - Word Prediction"),
                  
                  sidebarLayout(
                      sidebarPanel(
                          textInput(
                              "text",
                              "Enter Text:",
                              placeholder = "Please enter some text"
                          )
                      ),
                      mainPanel(
                          tabsetPanel(type = "tabs",
                                      tabPanel(
                                          "Stupid Back-Off Algorithm", 
                                           br(),
                                           dataTableOutput('sbo')
                                      ),
                                      tabPanel(
                                          "Laplace Algorithm", 
                                           br(),
                                           dataTableOutput('laplace')
                                      ),
                                      tabPanel(
                                          "About",
                                           br(),
                                          uiOutput('markdown')
                                      )
                          )
                      )
                  )
))
