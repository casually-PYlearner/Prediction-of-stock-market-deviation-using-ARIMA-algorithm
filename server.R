library(RCurl)
library(lubridate)
library(ggplot2)
library(shiny)
library(reshape)
library(forecast)


shinyServer(function(input, output) {
  
  output$plot <- renderPlot({
    data <- getSymbols(input$home_input, src = "yahoo", 
                       from = input$dates[1],
                       to = input$dates[2],
                       auto.assign = FALSE)
    
    chartSeries(data, theme = chartTheme("black"), 
                type = "line", TA = NULL)
  })
  
  output$p1 <- renderPlot({
    
    pp <<- input$parp
    pd <<- input$pard
    pq <<- input$parq
    
    s1 <<- input$sym1
    s2 <<- input$sym2
    d1 <<- day(input$dates[1])
    d2 <<- day(input$dates[2])
    m1 <<- month(input$dates[1])
    m2 <<- month(input$dates[2])
    y1 <<- year(input$dates[1])
    y2 <<- year(input$dates[2])

    if ((d1==d2) & (m1==m2) & (y1==y2)){
      y1 <<- y1-1
    }
    URL1 <- paste0("http://real-chart.finance.yahoo.com/table.csv?s=",s1,"&a=",m1-1,"&b=",d1,"&c=",y1,"&d=",m2-1,"&e=",d2,"&f=",y2,"&g=d&ignore=.csv")
    URL2 <- paste0("http://real-chart.finance.yahoo.com/table.csv?s=",s2,"&a=",m1-1,"&b=",d1,"&c=",y1,"&d=",m2-1,"&e=",d2,"&f=",y2,"&g=d&ignore=.csv")
    findata1 <<- read.csv(URL1)
    findata2 <<- read.csv(URL2)
    findata1 <<- findata1[,c(1,6,7)]
    findata2 <<- findata2[,c(1,6,7)]
    
    output$p3 <- renderPlot({
      fit1 <<- stats::arima(findata1[,3], order = c(pp, pd, pq))
      plot(forecast(fit1, h = 30), col="green")
    })
    
    output$p4 <- renderPlot({
      fit2 <<-stats::arima(findata2[,3], order = c(pp, pd, pq))
      plot(forecast(fit2, h = 30), col = "blue")
    })
    
    output$t2 <- renderTable({
      accuracy(fit1)
    })
    
    output$t3 <- renderTable({
      accuracy(fit2)
    })
    

    
    plot(findata1[,1],findata1[,3])
    title(main="Share Price Vs Date", sub ="First Company: Green Color;    Second Company: Blue Color")
    lines(findata1[,1],findata1[,3], col = "Green")
    par(new = T)
    plot(findata2[,1],findata2[,3],axes = F)
    lines(findata2[,1],findata2[,3], col = "Blue")
    par(new = F)
    })
  
  output$p2 <- renderPlot({
    plot(findata1[,1],findata1[,2])
    title(main="Share Volume Vs Date", sub ="First Company: Green Color;    Second Company: Blue Color")
    lines(findata1[,1],findata1[,2], col = "Green")
    par(new = T)
    plot(findata2[,1],findata2[,2],axes = F)
    lines(findata2[,1],findata2[,2], col = "Blue")
    par(new = F)
  })
  
  output$t1 <- renderTable({
    
    v1 <- c(s1,s2)
    v2 <- c(mean(findata1[,3]),mean(findata2[,3]))
    v3 <- c(sd(findata1[,3]),sd(findata2[,3]))
    v4 <- c(mean(findata1[,2]),mean(findata2[,2]))
    v5 <- c(sd(findata1[,2]),sd(findata2[,2]))
    v <- data.frame(v1,v2,v3,v4,v5)
    names(v) <- c("Name","Avg.Price","Std.Deviation.Price","Avg.Volume","Std.Deviation.Volume")
    v
  })
})

