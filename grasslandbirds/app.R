#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(bslib)
library(tidyverse)
library(grasslandbirds)

# Define UI for application that draws a histogram
ui <- page_sidebar(
  theme = bs_theme(version = 5, bootswatch = "minty"),

   # Application title
  title = ("Grassland Bird Population Vs Agriculture Growth - NORTH AMERICA"),

  # Sidebar with a slider input for number of bins
  sidebar =  sidebar(
    selectizeInput("YearSelect", label = "Select Year", choices = unique(analysis_data$Year), multiple = TRUE),
    ),

  navset_pill(
    nav_panel("Plots", card(
      plotOutput("distPlot"),
      plotOutput("argPlot")
    )),
    nav_panel("About",
              tags$p("The dashboard in the plot tab shows and compares the bird population of Grassland Birds
              and the Production amount in livestock and crops in North America, throughout
              the years."),
              tags$p("The filter on the left side (in the plot tab) can be used to select the
              years in which the plots will show.")
    )
  ),

)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({


      analysis_data%>%
        filter(Year %in% input$YearSelect) %>%
        ggplot(aes(x = Year, y = population)) +
        geom_line(linewidth = 0.5) +
        labs(title = "Bird Population")

    })

    output$argPlot <- renderPlot({


      analysis_data%>%
        filter(Year %in% input$YearSelect) %>%
        ggplot(aes(x = Year, y = Value)) +
        geom_line(linewidth = 0.5) +
        labs(title = "Production of Livestock and Crops")

    })

    observeEvent(input$YearSelect, {
      if (length(input$YearSelect) == 1) {
        showNotification("Minimum 2 Years need to be selected.",
                         type = "error",
                         duration = 3.5)
      }
    })


}

# Run the application
shinyApp(ui = ui, server = server)
