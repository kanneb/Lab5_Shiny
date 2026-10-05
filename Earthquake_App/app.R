library(shiny)
library(leaflet)
library(Lab5PKG)

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
      leafletOutput("map", height = 600)
    )
  )
)

server <- function(input, output) {

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


}
shinyApp(ui, server)
