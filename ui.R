library(shiny)


shinyUI(fluidPage(
    
    
    titlePanel("Laboratorio 2"),
    
    tabsetPanel(
        tabPanel('Interactive plots - Shiny',
                 plotOutput('plot_click_options',
                            click = 'clk',
                            dblclick = 'dclk',
                            hover = 'mhover',
                            brush = 'mbrush'
                 ),
                 DT::dataTableOutput('table_output')
        )
    )
    
))