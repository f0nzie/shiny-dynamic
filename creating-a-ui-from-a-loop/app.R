#
# the original application is located here:
# 
# http://shiny.rstudio.com/gallery/creating-a-ui-from-a-loop.html

# Creates widgets dynamically. The original application had a fixed number of 5. 
# I changed it to two integer objects: one for the comboboxes (selectInput) 
# and the second for the text (uiOutput).

library(shiny)

max_widgets.A <- 7
max_widgets.B <- 15

# Define UI for application that draws a histogram
ui <- fluidPage(
   
    title = 'Creating a UI from a loop',
    
    sidebarLayout(
        sidebarPanel(
            # create some select inputs
            lapply(1:max_widgets.A, function(i) {
                selectInput(paste0('a', i), paste0('SelectA', i),
                            choices = sample(LETTERS, max_widgets.A))
            })
        ),
        
        mainPanel(
            verbatimTextOutput('a_out'),
            
            # UI output
            lapply(1:max_widgets.B, function(i) {
                uiOutput(paste0('b', i))
            })
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
   
    # note we use the syntax input[['foo']] instead of input$foo, because we have
    # to construct the id as a character string, then use it to access the value;
    # same thing applies to the output object below
    output$a_out <- renderPrint({
        res <- lapply(1:max_widgets.A, function(i) input[[paste0('a', i)]])
        str(setNames(res, paste0('a', 1:max_widgets.A)))
    })
    
    lapply(1:max_widgets.B, function(i) {
        output[[paste0('b', i)]] <- renderUI({
            strong(paste0('Hi, this is output B#', i))
        })
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

