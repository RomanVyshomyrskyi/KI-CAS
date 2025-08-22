run_ui <- function(data, pages){
  ui <- page_fluid(
    div(style = "margin-top: 30px;",
        layout_columns(
          col_widths = c(3, 9),
          div(style = "font-weight: 600; font-size: 18px; padding-top:6px;", "Choose mesurment:"),
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
    observeEvent(TRUE, 
                 { updateSelectInput(
                   session, "page_choice", selected = names(pages)[1]);
                   mount_page(names(pages)[1]) }, once = TRUE)
    
    # on change
    observeEvent(input$page_choice, {
      req(input$page_choice)
      mount_page(input$page_choice)
    }, ignoreInit = TRUE)
  }
  
  shinyApp(ui, server)
}
