require(imager)
require(shiny)
require(jpeg)
require(png)

shinyUI(
  fluidPage(
    includeCSS("bootstrap.css"),
    
    pageWithSidebar(
      headerPanel(title = 'Image Classification(cifar10) using DenseNet',
                  windowTitle = 'Image Classification(cifar10) using DenseNet'),
      
      fluidRow(
        column(1),
        column(9,
               tabsetPanel(
                 id = "tabs",
                 tabPanel("Upload Image",
                          fileInput('file1', 'Upload a PNG / JPEG File:')),
                 tabPanel(
                   "Use the URL",
                   textInput("url", "Image URL:", "http://"),
                   actionButton("goButton", "Go!")
                 )
               ),
               h3(titlePanel("DESCRIPTION - CIFAR-10 분류")),
               h3(titlePanel("비행기, 자동차, 새, 사슴, 개, 말, 트럭, 고양이, 개구리, 배"))
               
               ),
        column(2)
      ),
      
      
      mainPanel(
        h3("Image"),
        tags$hr(),
        imageOutput("originImage", height = "auto"),
        tags$hr(),
        h3("What is this?"),
        tags$hr(),
        verbatimTextOutput("res")
      )
      
      
    )))
