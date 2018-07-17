library(RCurl)
library(shiny)
library(lubridate)
library(quantmod)
library(ggplot2)
library(reshape)

shinyUI(fluidPage(

  titlePanel("Predictor de riesgo"),
  tabsetPanel(              
    tabPanel(title = "Home",
             tags$h1("Welcome to stock market analysis"),
             tags$h6("Select the company for which you wish to see the current stock stats"),
             selectInput(inputId = "home_input",label="Companies",c("Apple Inc"="AAPL","Google Inc"="GOOGL","Microsoft Corporation"="MSFT","Amazon Inc"="AMZN","Facebook"="FB","Vodafone Group"="VOD","Cisco Systems"="CSCO")),
             
             
             dateRangeInput("dates", 
                            "Date range",
                            start = "2017-01-01", 
                            end = as.character(Sys.Date())),
             plotOutput("plot")
             
             
    ),
    tabPanel(title="Risk predictor",tags$h1("Let's start predicting"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "sym1",label="Companies",c("Apple Inc"="AAPL","Google Inc"="GOOGL","Microsoft Corporation"="MSFT","Amazon Inc"="AMZN","Facebook"="FB","Vodafone Group"="VOD","Cisco Systems"="CSCO")),
      
      selectInput(inputId = "sym2",label="Companies",c("Apple Inc"="AAPL","Google Inc"="GOOGL","Microsoft Corporation"="MSFT","Amazon Inc"="AMZN","Facebook"="FB","Vodafone Group"="VOD","Cisco Systems"="CSCO")),
      
       dateRangeInput("dates", label = h6("Select the Date range")),
       sliderInput("parp", label = h6("Autoregression Parameter"),
                   min = 0, max = 10, value = 2),
       sliderInput("pard", label = h6("Integration Parameter"),
                   min = 0, max = 10, value = 0),
       sliderInput("parq", label = h6("Moving Average Parameter"),
                   min = 0, max = 10, value = 2)
    ),
    

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("p1"),
      br(""),
      
      plotOutput("p3"),
      br(""),
     
      plotOutput("p4"),
      br(""),
      
      p("*Price used is the Adjusted closing price"),
      tags$h6("Autoregressive integrated moving average (ARIMA):"),
      p("In statistics and econometrics, and in particular in time series analysis, an autoregressive integrated moving average (ARIMA) model is a generalization of an autoregressive moving average (ARMA) model. These models are fitted to time series data either to better understand the data or to predict future points in the series (forecasting).The model is generally referred to as an ARIMA(p,d,q) model where parameters p, d, and q are non-negative integers that refer to the order of the autoregressive, integrated, and moving average parts of the model respectively."),
      em({
"These prices have been calculated based upon the history of the history of the stock prices and the actual prices may vary according to various situations.This is just to study the trend and forecast with the history and the creator of this product is not responsible for the inaccuracy if caused "})
    ))
)
  )
))