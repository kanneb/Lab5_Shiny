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
                  min = 0, max = 10, value = 5, step = 0.5)
    ),
    mainPanel(
      leafletOutput("map", height = 600)
    )
  )
)

server <- function(input, output) {

  data <- reactive({
    validate(need(input$datum[1] < input$datum[2], "End date must be after start date"))
    result <- earthquake(input$region,
               starttime = as.character(input$datum[1]),
               endtime   = as.character(input$datum[2]),
               min_magnitude = input$mag)
    validate(need(!is.null(result), "Could not fetch data!"))
    validate(need(nrow(result) > 0, "No data available"))

    result
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
