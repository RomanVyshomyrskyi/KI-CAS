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


# ---- Main ----

main <- function(){
  data <- get_data()
  run_ui(data)
}


main()

