library(shiny)
library(ggplot2)
library(ggthemes)
library(reshape2)
library(lubridate)
library(dplyr)

ui <-
  shinyUI(
    navbarPage(
      title = div(img(src="grapes.png", width = 30, height = 30), "VintageDataScience"),
      windowTitle = "Huglin Index, VintageDataScience",
      position = "static-top",
      collapsible = TRUE,
      fluid = TRUE,
      inverse = FALSE,
      footer = div(id='myDiv', class='simpleDiv', 'Page created by Paul van Oppen, September 2016, Sydney, Australia', style='font-size:80%'),
      theme = "Superhero.css",
      tabPanel("Index",
               fluidRow(column(12, titlePanel("Huglin index for Maastricht", windowTitle = "VintageDataScience: Huglin Index for Maastricht"))),
               fluidRow(column(3,
                  wellPanel(
                   selectInput("station1", "Select station", list(
                      "Netherlands" = c("Maastricht"),
                      "Germany" = c("Kaiserslautern", "Trier-Petrisberg")
                   )),
                   sliderInput(
                     inputId = "year_index",
                     label = "Choose year",
                     min = Min.Year,
                     max = Max.Year,
                     value = 2000,
                     step = 1,
                     sep = ""
                   ),
                   actionButton(inputId = "first_btn_idx", label = "", icon = icon("angle-double-left", lib = "font-awesome"), style='padding:4px; font-size:80%'),
                   actionButton(inputId = "prev_btn_idx", label = "", icon = icon("angle-left", lib = "font-awesome"), style='padding:4px; font-size:80%'),
                   actionButton(inputId = "next_btn_idx", label = "", icon = icon("angle-right", lib = "font-awesome"), style='padding:4px; font-size:80%'),
                   actionButton(inputId = "last_btn_idx", label = "", icon = icon("angle-double-right", lib = "font-awesome"), style='padding:4px; font-size:80%')
                   
                 )),
               column(9,
                   tags$head(tags$style(HTML(mycss))),
                   div(
                     id = "plot-container",
                     tags$img(src = "http://www.ajaxload.info/images/exemples/35.gif",
                              id = "loading-spinner"),
                     plotOutput("distPlot1", click = "plot_click")
                   ))
               ),
               fluidRow(
                 column(4, offset = 3,
                        h5("Click on the graph to read date and index values:"),
                        verbatimTextOutput("plot_index_info"),
                        downloadButton('downloadData', 'Download'))
               )),
      tabPanel("Summary",
               fluidRow(column(12, titlePanel("Huglin index for Maastricht: annual maxima", windowTitle = "VintageDataScience: Huglin Index for Maastricht"))),
               fluidRow(column(3,
                  wellPanel(
                   selectInput("station2", "Select station", list(
                     "Netherlands" = c("Maastricht"),
                     "Germany" = c("Kaiserslautern", "Trier-Petrisberg")
                   )),
                   sliderInput(
                     inputId = "year_summary",
                     label = "Choose year",
                     min = Min.Year,
                     max = Max.Year,
                     value = 2000,
                     step = 1,
                     sep = ""
                   ),
                   actionButton(inputId = "first_btn_sum", label = "", icon = icon("angle-double-left", lib = "font-awesome"), style='padding:4px; font-size:80%'),
                   actionButton(inputId = "prev_btn_sum", label = "", icon = icon("angle-left", lib = "font-awesome"), style='padding:4px; font-size:80%'),
                   actionButton(inputId = "next_btn_sum", label = "", icon = icon("angle-right", lib = "font-awesome"), style='padding:4px; font-size:80%'),
                   actionButton(inputId = "last_btn_sum", label = "", icon = icon("angle-double-right", lib = "font-awesome"), style='padding:4px; font-size:80%')
                 )),
                 column(9,
                   tags$head(tags$style(HTML(mycss))),
                   div(
                     id = "plot-container",
                     tags$img(src = "http://www.ajaxload.info/images/exemples/35.gif",
                              id = "loading-spinner"),
                     plotOutput("distPlot2", click = "plot_click")
                   ))),
               fluidRow(column(
                 3,
                 offset = 3,
                 h5("Click on the graph to read date and index values:"),
                 verbatimTextOutput("plot_sum_info")
                 #downloadButton('downloadData', 'Download'))
               ))), 
      tabPanel("About the Huglin Index",
               fluidRow(column(12, titlePanel("About the Huglin index"))),
               fluidRow(column(12,
                               h5("Blurb around Jules & Paul"))),
               fluidRow(column(12,
                               withMathJax(includeMarkdown("./www/About_Huglin.md"))),
                        tags$head(tags$style("#background{font-size: 20px; color: black"))
               )),
      tabPanel("About us",
               fluidRow(column(12, titlePanel("About Jules Nijst and Paul van Oppen"))),
               fluidRow(column(12,
                        h5("Blurb around Jules & Paul"))),
               fluidRow(column(12,
                               includeMarkdown("./www/About_us.md")))
               ),
      # Allign the navbarPanel to the left
      tags$head(tags$style(' 
                           nav .container:first-child {
                           margin-left:10px; width: 100%;
                           }'))
    ))