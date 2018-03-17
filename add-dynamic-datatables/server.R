
library(shiny)
library(ggplot2)
library(DT) # need datatables package

server <- shinyServer(function(input, output, session) {
    
    output$mytabs <- renderUI({
        nTabs = length(input$decision)
        # create tabPanel with datatable in it
        myTabs = lapply(seq_len(nTabs), function(i) {
            tabPanel(paste0("dataset_",i),
                     DT::dataTableOutput(paste0("datatable_",i))       
            )
        })
        
        do.call(tabsetPanel, myTabs)
    })
    
    # create datatables
    observe(
        lapply(seq_len(length(input$decision)), function(i) {
            output[[paste0("datatable_",i)]] <- DT::renderDataTable({
                as.data.frame(get(input$decision[i]))
            })
        })  
    )  
})
