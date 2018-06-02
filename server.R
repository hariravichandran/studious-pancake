#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

shinyServer(function(input, output) {
    
  output$interestPlot <- renderPlot({
    
    # We need n periods, which are the years * the number of months
    periods <- seq(1, input$Years * 12, by = 1)
    
    # Use Fisher Approximation to Calculate the Real Interest Rate, convert to percentage
    r <- (input$InterestRate - input$InflationRate + 0.0001)/100 #Added 0.0001 to compensate for singularity where Interest = Inflation
    i <- (input$InterestRate + 0.0001)/100 #Nominal Interest Rate (not taking inflation into account), added delta = 0.0001 to prevent singularity when interest = 0
    
    # # Initialize a Vector of Values
    value <- vector(mode = "numeric", length = 0)
    value_nominal <- vector(mode = "numeric", length = 0)
    
    # Calculate the value of the payments at the end of the current year
    for (n in periods){
        value[n] <- input$Payment * ((1 + r/12) ^ n - 1)/(r/12)
        value_nominal[n] <- input$Payment * ((1 + (i)/12) ^ n - 1)/((i)/12)
        # Checked using https://www.calculatorsoup.com/calculators/financial/future-value-annuity-calculator.php
    }
    
    # Generate vector of years based on Starting Year and Number of Years to save
    years <- seq(input$StartYear, input$StartYear + input$Years, length.out = input$Years * 12) #Monthly Increment
    
    plot(years, value, type = "l", lwd = 2, lty = 1, col = "blue", xlab = "Year", ylab = "Savings Value ($)")
    lines(years, value_nominal, lwd = 2, lty = 2, col = "red")
    legend("topleft", inset = 0.05, col = c("blue", "red"), lty = c(1, 2),
           title = "Interest Rate Type", c("Real (Inflation Adjusted)", "Nominal"))
    
  })
  
  #Total Amount of Cash Deposited through the Process
  output$CashDep <- renderText({paste("$", prettyNum(input$Years * 12 * input$Payment, big.mark = ","))})
  
  #I use the same formulas again to calculate the Future Value, since it was difficult to transfer the results for the plot to renderText()
  output$totalValue <- renderText({paste("Real (Inflation Adjusted) Value At End of Year ", input$Years + input$StartYear, ": $", 
                                         prettyNum(input$Payment * ((1 + (input$InterestRate/100 - input$InflationRate/100)/12) ^ (input$Years * 12) - 1)/((input$InterestRate/100 - input$InflationRate/100)/12), big.mark = ","))})
  
  output$totalValue_nominal <- renderText({paste("Nominal Value At End of Year ", input$Years + input$StartYear, ": $", 
                                         prettyNum(input$Payment * ((1 + (input$InterestRate/100)/12) ^ (input$Years * 12) - 1)/((input$InterestRate/100)/12), big.mark = ","))})
  
})
