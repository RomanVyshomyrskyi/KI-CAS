# ---- Packages Installation ---- (Run if needed) 

# install.packages("shiny")
# install.packages("eurostat")
# install.packages("dplyr")

# ---- Imports ----
# -- Library's --

library(shiny) 
library(eurostat)
library(dplyr)

# -- Files --
source("scripts/get_data.R")
source("scripts/run_ui.R")



#  ---- Page register global ----
pages <- list(
  # ---- example's ----
  #"Cars (plot)"   = list(ui = "",   server = ""),
  #"Iris (table)"  = list(ui = page_iris_ui,   server = page_iris_server),
  #"Random (plot)" = list(ui = page_random_ui, server = page_random_server)
)

# ---- Main ----
main <- function(){
  data <- get_data()
  run_ui(data, pages)
}


main()

