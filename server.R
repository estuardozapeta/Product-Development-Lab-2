library(shiny)
library(ggplot2)
library(dplyr)

shinyServer(function(input, output) {
    
    output$plot_click_options <- renderPlot({
        
        plot(mtcars$wt,mtcars$mpg,xlab="wt",ylab="mpg", cex=2)
        color_point()
        
        if(!is.null(click_output)){
            points(click_output[,1],click_output[,2], col='#227225', pch=16, cex=2)
        }
        if(!is.null(d_click_output)){
            points(d_click_output[,1],d_click_output[,2], col='#000000', pch=1, cex=2)
        }
        if(!is.null(hover_output)){
            points(hover_output[,1],hover_output[,2], col='#7A7878', pch=16, cex=2)
        }
        
    })
    
    color_point <- reactive({
        
        if(!is.null(input$clk$x)){
            df<-nearPoints(mtcars,input$clk,xvar='wt',yvar='mpg')
            out <- df %>% 
                select(wt,mpg)
            click_output <<- rbind(click_output,out) %>% distinct()
            return(out)
        }
        
        if(!is.null(input$dclk$x)){
            df<-nearPoints(mtcars,input$dclk,xvar='wt',yvar='mpg')
            out <- df %>% 
                select(wt,mpg)
            d_click_output <<- setdiff(d_click_output,out)
            return(hover_output)
        }
        
        if(!is.null(input$mhover$x)){
            df<-nearPoints(mtcars,input$mhover,xvar='wt',yvar='mpg')
            out <- df %>% 
                select(wt,mpg)
            hover_output <<- out
            return(hover_output)
        }
        
        if(!is.null(input$mbrush)){
            df<-brushedPoints(mtcars,input$mbrush,xvar='wt',yvar='mpg')
            out <- df %>% 
                select(wt,mpg)
            click_output <<- rbind(click_output,out) %>% dplyr::distinct()
            return(hover_output)
        }
        
    })
    
    output$table_output <- DT::renderDataTable({
        click_table() %>% DT::datatable()
    })
    
    click_table <- reactive({
        input$clk$x
        input$dclk$x
        input$mbrush
        click_output
    })
    
    click_output<- NULL
    d_click_output<- NULL
    hover_output<- NULL
    
})
