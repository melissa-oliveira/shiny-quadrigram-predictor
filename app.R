library(shiny)

source("setup_python_virtualenv.R")

ui <- fluidPage(
  titlePanel("Previsão de Domínio da Experiência de Quadrigramas com Modelo Random Forest"),
  sidebarLayout(
    sidebarPanel(
      textInput("input_text", "Digite o quadrigrama para previsão:", ""),
      actionButton("predict_button", "Prever")
    ),
    mainPanel(
      textOutput(outputId = "prediction_result")
    )
  )
)

server <- function(input, output, session) {
  setup_virtual_environment()
  source_python('scripts.py')
  
  observeEvent(input$predict_button, {
    if (input$input_text != "") {
      predicted_label <- predict(input$input_text)
      output$prediction_result <- renderText({
        paste("Domínio da experiência: ", predicted_label)
      })
    }
  })
}

shinyApp(ui, server)
