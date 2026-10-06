library(shiny)
library(leaflet)
library(Lab5PKG)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Earthquakes"),
  sidebarLayout(
    sidebarPanel(
      selectInput("region", "Region",
                  choices = c("Europe", "Africa", "Asia", "Oceania", "North America", "South America", "Antarctica")),
      dateRangeInput("datum", "Period",
                     start = "2025-01-01", end = "2025-12-31"),
      sliderInput("mag", "Minimum magnitude",
                  min = 4, max = 8, value = 5, step = 0.5)
    ),
    mainPanel(
      actionButton("exc", "Show distrubution"),

      conditionalPanel(
        condition = "input.exc % 2 == 0",
        leafletOutput("map", height = 600)
      ),
      conditionalPanel(
        condition = "input.exc % 2 == 1",
        plotOutput("dist", height = 600)
      )
    )
  )
)

server <- function(input, output, session) {

  data <- reactive({
    earthquake(input$region,
               starttime = as.character(input$datum[1]),
               endtime   = as.character(input$datum[2]),
               min_magnitude = input$mag)
  })

  output$map <- renderLeaflet({
    reg <- data()
    leaflet(reg) |>
      addProviderTiles(providers$Esri.WorldTopoMap) |>
      addCircleMarkers(lng = ~longitude, lat = ~latitude,
                       radius = ~ mag * 1.2,
                       fillOpacity = 0.7, stroke = FALSE, color = "green",
                       popup = ~paste0(place, "<br>Magnitude: ", mag))
  })

  output$dist <- renderPlot({
    reg <- data()
    meanmag <- mean(reg$mag, na.rm = TRUE)

    ggplot(reg, aes(x = mag)) +
      geom_density(fill = "lightblue", alpha = 0.5) +
      geom_vline(xintercept = meanmag, color = "red", linetype = "dashed", linewidth = 1) +
      annotate("text", x = meanmag, y = 1.5, label = paste("Mean:", round(meanmag, 2)),
               color = "red", hjust = -0.1) +
      labs(title = "Distrubution of magnitude", x = "Magnitude", y = "Density") +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5))
  })


  observeEvent(input$exc, {
    text <- if (input$exc %% 2 == 1) "Show map" else "Show distrubution"
    updateActionButton(session, "exc", label = text)
  })


}
shinyApp(ui, server)






