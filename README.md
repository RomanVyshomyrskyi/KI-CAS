# In pojet used
- **_R_** (https://www.r-project.org/) -- main coding language
- **_Shiny_** (https://shiny.posit.co/) - UI/UX Visual representation
- **_Eurostat_** (https://ec.europa.eu/eurostat/web/main/data/database#Data%20navigation%20tree) - Database


# How to code

## Modular pages example's
Ui example
```R
page_cars_ui <- function(id) {
  ns <- NS(id)
  tagList(
    card(
      card_header("Cars scatter (module-owned controls)"),
      layout_columns(
        col_widths = c(4, 8),
        sliderInput(ns("cex"), "Point size", min = 0.5, max = 3, value = 1.2, step = 0.1),
        plotOutput(ns("plot"), height = 400)
      )
    )
  )
}

```
Server example

```R
page_cars_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$plot <- renderPlot({
      plot(cars, main = "cars dataset", cex = input$cex, pch = 19)
    })
  })
}

```