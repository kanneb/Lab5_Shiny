library(shiny)
ui <- fluidPage(
  numericInput(inputId = "n", label = "How many tosses?",
               value = 4, min = 1, max = 100, step = 1),
  plotOutput(outputId = "probs")
)
server <- function(input, output) {
  output$probs <- renderPlot({
    barplot(dbinom(0:input$n, input$n, 0.5),
            names = 0:input$n, ylab = "Probability")
  })
}
shinyApp(ui, server)
