# dynamic-dataframe-construction

#rm(list = ls())
library(shiny)

data <- data.frame(Category1 = rep(letters[1:3],each=15),
                   Info = paste("Text info",1:45),
                   Category2 = sample(letters[15:20],45,replace=T),
                   Size = sample(1:100, 45),
                   MoreStuff = paste("More Stuff",1:45))

ui <- fluidPage(
    
    titlePanel("Test Explorer"),
    sidebarLayout(
        sidebarPanel(
            uiOutput("category1"),
            uiOutput("category2"),
            uiOutput("sizeslider")
        ),
        mainPanel(
            tableOutput("table")
        )
    )
)

server <- function(input, output,session) {
    
    output$category1 <- renderUI({
        selectizeInput('cat1', 'Choose Cat 1', choices = c("All",sort(as.character(unique(data$Category1)))),selected = "All")
    })
    
    df_subset <- eventReactive(input$cat1,{
        if(input$cat1=="All") {df_subset <- data}
        else{df_subset <- data[data$Category1 == input$cat1,]}
    })
    
    df_subset1 <- reactive({
        if(is.null(input$cat2)){df_subset()} else {df_subset()[df_subset()$Category2 %in% input$cat2,]}
    })
    
    output$category2 <- renderUI({
        selectizeInput('cat2', 'Choose Cat 2 (optional):', choices = sort(as.character(unique(df_subset()$Category2))), multiple = TRUE,options=NULL)
    })
    
    output$sizeslider <- renderUI({
        sliderInput("size", label = "Size Range", min=min(df_subset1()$Size), max=max(df_subset1()$Size), value = c(min(df_subset1()$Size),max(df_subset1()$Size)))
    })
    
    df_subset2 <- reactive({
        if(is.null(input$size)){df_subset1()} else {df_subset1()[df_subset1()$Size >= input$size[1] & df_subset1()$Size <= input$size[2],]}
    })
    
    output$table <- renderTable({
        df_subset2()
    })
}

shinyApp(ui, server)