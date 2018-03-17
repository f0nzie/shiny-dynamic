
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
    titlePanel("Example"),
    sidebarLayout(
        sidebarPanel(
            selectInput("decision", label = "Choose Dataset", 
                        choices = list("mtcars" = "mtcars", 
                                       "iris" = "iris", 
                                       "precip" = "precip", 
                                       "quakes" = "quakes"), 
                        selected = NULL, multiple = TRUE)
        ),
        mainPanel(
            uiOutput('mytabs')
        )
    )
))
