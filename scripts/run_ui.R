library(shiny)
library(bslib)



run_ui <- function(data){
}


# ----- Concept test -----


# --- Modular pages ---
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

page_cars_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$plot <- renderPlot({
      plot(cars, main = "cars dataset", cex = input$cex, pch = 19)
    })
  })
}

page_iris_ui <- function(id) {
  ns <- NS(id)
  tagList(
    card(
      card_header("Iris head (module-owned controls)"),
      layout_columns(
        col_widths = c(5, 7),
        selectInput(ns("species"), "Species", choices = c("All", levels(iris$Species))),
        tableOutput(ns("tbl"))
      )
    )
  )
}

page_iris_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$tbl <- renderTable({
      d <- iris
      if (input$species != "All") d <- subset(d, Species == input$species)
      head(d, 10)
    })
  })
}

page_random_ui <- function(id) {
  ns <- NS(id)
  tagList(
    card(
      card_header("Random normal histogram"),
      sliderInput(ns("n"), "N", min = 100, max = 5000, value = 1000, step = 100),
      plotOutput(ns("hist"), height = 400)
    )
  )
}

page_random_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$hist <- renderPlot({
      hist(rnorm(input$n), main = sprintf("Histogram (n = %d)", input$n))
    })
  })
}

# --- register (global) ---
pages <- list(
  "Cars (plot)"   = list(ui = page_cars_ui,   server = page_cars_server),
  "Iris (table)"  = list(ui = page_iris_ui,   server = page_iris_server),
  "Random (plot)" = list(ui = page_random_ui, server = page_random_server)
)

# --- Main body ---
ui <- page_fluid(
  div(style = "margin-top: 30px;",
      layout_columns(
        col_widths = c(3, 9),
        div(style = "font-weight: 600; font-size: 18px; padding-top:6px;", "Choose page:"),
        selectInput("page_choice", NULL, choices = names(pages), width = "100%")
      )
  ),
  hr(),
  uiOutput("page_mount")   # where the selected module's UI will appear
)

server <- function(input, output, session) {
  # a unique id for the currently mounted module
  current_id <- reactiveVal("page_1")
  
  # mount the chosen module: render its UI + run its server
  mount_page <- function(choice) {
    id <- paste0("page_", as.integer(runif(1, 1e6, 2e6)))  # simple unique id
    current_id(id)
    output$page_mount <- renderUI(pages[[choice]]$ui(id))
    pages[[choice]]$server(id)
  }
  
  # initial
  observeEvent(TRUE, { updateSelectInput(session, "page_choice", selected = names(pages)[1]); mount_page(names(pages)[1]) }, once = TRUE)
  
  # on change
  observeEvent(input$page_choice, {
    req(input$page_choice)
    mount_page(input$page_choice)
  }, ignoreInit = TRUE)
}

shinyApp(ui, server)