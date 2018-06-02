#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a plot and prints out the future value
shinyUI(fluidPage(

tags$head(tags$style("#totalValue{color: blue;
                             font-size: 20px;
                             font-style: normal;
                             }"
                    )
         ),

tags$head(tags$style("#totalValue_nominal{color: red;
                             font-size: 20px;
                             font-style: italic;
                             }"
                    )
         ),
tags$head(tags$style("#CashDep{color: green;
                             font-size: 24px;
                             font-style: bold;
                             }"
)
),
    
  # Application title
  titlePanel("Monthly Savings Calculator"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       p("Feel free to play around with the sliders below. As you do, the results on the right will change."),
       sliderInput("StartYear", "Starting Year (AD)", min = 2000, max = 2040, value = 2018, step = 1),
       sliderInput("Years", "Number of Years to Save:", min = 1, max = 40, value = 10, step = 1),
       sliderInput("InterestRate", "Annual Interest Rate (Percent)", min = 0, max = 20, value = 9, step = 0.5),
       sliderInput("InflationRate", "Annual Inflation Rate (Percent)", min = 0, max = 5, value = 2, step = 0.5),
       sliderInput("Payment", "Monthly Deposit Amount ($)", min = 0, max = 3000, value = 500, step = 250)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
        h2("Overview"),
        p("This investment calculator is designed to help people understand the effectiveness of compound interest at generating long-term returns, and to encourage investing."),
        h2("Plot of Returns Over Time"),
        plotOutput("interestPlot"),
        h2("Total Cash Deposited into Savings Account"),
        textOutput("CashDep"),
        h2("Return Amounts at End Year"),
        textOutput("totalValue"),
        textOutput("totalValue_nominal")
    )
  )
))


