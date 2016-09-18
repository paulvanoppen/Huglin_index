library(shiny)
library(ggplot2)
library(ggvis)
library(ggthemes)
library(reshape2)
library(lubridate)
library(dplyr)

options(shiny.reactlog=TRUE)

server <- function(input, output, session) {
  
  myplot1 <- function(DF, year) {
    # plot function for the Huglin Index as a function of day number
    mypalette <- c("#66C2A5", "#FC8D62", "#8DA0CB", "#E78AC3", "#A6D854", "#FFD92F", "#E5C494", "#B3B3B3")
    mypalette <- c(mypalette[1:length(year)], "grey", "grey")
    year <- c(year, "MIN", "MAX")
    DF <- DF[DF$YEAR %in% year,]
    p <- ggplot(DF, aes(x = HI.dayofyear, y = HI.cumsum, colour = YEAR, order = YEAR))
    p <- p + geom_line(size = 1.1)
    p <- p + scale_x_continuous(breaks = c(91,121,152,182,213,244,273), limits = c(91, 273), labels = c("APR","MAY","JUN","JUL","AUG","SEP","OCT"))
    p <- p + scale_y_continuous(breaks = seq(0, 2000, 400), minor_breaks = seq(0 , 2000, 400), limits = c(0, 2000))
    p <- p + ylab("Index Huglin\n") + xlab("\nMonth")
    p <- p + theme(legend.title = element_blank())
    p <- p + theme(legend.position="bottom")
    p <- p + scale_color_manual(values = mypalette)
    p <- p + theme(axis.text.x = element_text(size = 14, family = "sans", face = "bold"))
    p <- p + theme(axis.text.y = element_text(size = 14, family = "sans", face = "bold"))
    p <- p + theme(axis.title = element_text(size = 16, family = "sans", face = "bold"))
    p <- p + theme(legend.text = element_text(size = 14))
    #p <- p + theme(aspect.ratio=4/10)
    p
  }

  myplot2 <- function(DF, year) {
    # plot function for the maximum value of the Huglin Index for each year
    p <- ggplot(data = DF, aes(x = as.numeric(YEAR), y = HI.cumsum))
    p <- p + geom_line(size = 1.1, color = "#66C2A5")
    p <- p + geom_point(data = DF[DF$YEAR == year, ], shape = 19, size = 5, colour = "red") 
    p <- p + scale_y_continuous(breaks = seq(1000, 2000, 200), limits = c(1000, 2000))
    p <- p + scale_x_continuous(breaks = seq(1900, 2015, 10))
    p <- p + ylab("End-of-year Huglin Index\n") 
    p <- p + xlab("\nYears")
    p <- p + theme(axis.text.x = element_text(size = 14, family = "sans", face = "bold"))
    p <- p + theme(axis.text.y = element_text(size = 14, family = "sans", face = "bold"))
    p <- p + theme(axis.title = element_text(size = 16, family = "sans", face = "bold"))
    p <- p + theme(legend.text = element_text(size = 14))
    p
  }
  
  output$distPlot1 <- renderPlot({
    # Render HUglin Index as a function of day number (myplot1)
    year <- input$year_index
    myplot1(Huglin.index, as.character(year))
  })
  
  output$plot_index_info <- renderText({
    #browser()
    if (is.null(input$plot_click$x)) return()
    dayofyear <- round(input$plot_click$x, digits = 0)
    #index <- input$plot_click$y
    year <- input$year_index
    index <- Huglin.index %>% filter(as.numeric(YEAR) == year & HI.dayofyear == dayofyear) %>% select(HI.cumsum)
    index <- as.character(round(as.numeric(index$HI.cumsum), digits = 1))
    date <- format(strptime(paste(year, dayofyear), format="%Y %j"), format = "%d-%m-%Y")
    paste0("Date  = ", date, "; Index = ", index)
  })
  
  output$distPlot2 <- renderPlot({
    # Render maximum value of Huglin Index (myplot2)
    year <- input$year_summary # get year from slider
    HI.max <- Huglin.index[!(Huglin.index$YEAR %in% c("MIN", "MAX")),] # subset the DF to contain only yearly data (remove MIN and MAX)
    DF <- HI.max %>% group_by(YEAR) %>% slice(which.max(HI.cumsum)) # determine the max value per Year
    myplot2(DF, year)
  })

  output$plot_sum_info <- renderText({
    if (is.null(input$plot_click$x)) return()
    year <- round(input$plot_click$x, digits = 0)
    HI.max <- Huglin.index[!(Huglin.index$YEAR %in% c("MIN", "MAX")),] # subset the DF to contain only yearly data (remove MIN and MAX)
    DF <- HI.max %>% group_by(YEAR) %>% slice(which.max(HI.cumsum)) # determine the max value per Year
    index <- DF[DF$YEAR == as.character(year), "HI.cumsum"]
    paste0("Year  = ", year, "; Index = ", index)
  })
    
  observeEvent(input$first_btn_idx, {
    # Event handler for button: first_btn_idx, moves slider to first year
    if (is.null(input$first_btn_idx)) return()
    year <- Min.Year
    updateSliderInput(session,
                      inputId = "year_index",
                      value = year)
  })
  
  observeEvent(input$prev_btn_idx, {
    # Event handler for button: prev_btn_idx, moves slider to previous year
    if (is.null(input$prev_btn_idx)) return()
    year <- input$year_index
    year <- if ((year > Min.Year) & (year <= Max.Year)) year - 1
    updateSliderInput(session,
                      inputId = "year_index",
                      value = year)
  })
  
  observeEvent(input$last_btn_idx, {
    # Event handler for button: last_btn_idx, moves slider to last year
    if (is.null(input$last_btn_idx)) return()
    year <- Max.Year
    updateSliderInput(session,
                      inputId = "year_index",
                      value = year)
  })
  
  observeEvent(input$next_btn_idx, {
    # Event handler for button: next_btn_idx, moves slider to next year
    if (is.null(input$next_btn_idx)) return()
    year <- input$year_index
    year <- if ((year >= Min.Year) & (year < Max.Year)) year + 1
    updateSliderInput(session,
                      inputId = "year_index",
                      value = year)
  })
  
  observeEvent(input$first_btn_sum, {
    if (is.null(input$first_btn_sum)) return()
    year <- Min.Year
    updateSliderInput(session,
                      inputId = "year_summary",
                      value = year)
  })
  
  observeEvent(input$prev_btn_sum, {
    if (is.null(input$prev_btn_sum)) return()
    year <- input$year_summary
    year <- if ((year > Min.Year) & (year <= Max.Year)) year - 1
    updateSliderInput(session,
                      inputId = "year_summary",
                      value = year)
  })
  
  observeEvent(input$last_btn_sum, {
    if (is.null(input$last_btn_sum)) return()
    year <- Max.Year
    updateSliderInput(session,
                      inputId = "year_summary",
                      value = year)
  })
  
  observeEvent(input$next_btn_sum, {
    if (is.null(input$next_btn_sum)) return()
    year <- input$year_summary
    year <- if ((year >= Min.Year) & (year < Max.Year)) year + 1
    updateSliderInput(session,
                      inputId = "year_summary",
                      value = year)
  })
  
  plotInput = function() {
    year <- input$year_index
    myplot1(Huglin.index, as.character(year))
  }
  
  output$downloadData <- downloadHandler(
    filename <- paste0("Huglin Index", Sys.Date(), ".png"),
    content = function(file) {
      device <- function(..., width, height) {
        grDevices::png(..., width = width, height = height, res = 300, units = "in")
      }
      ggsave(file, plot = plotInput(), device = device)
    }
  )
  
  output$text1 <- renderText({paste("Deliver relevant climatic data to people in the wine industry", input$var)})
  
}
