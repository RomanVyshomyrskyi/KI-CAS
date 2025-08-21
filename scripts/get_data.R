get_data <- function(){
  # function to get data return time series (if possible else 0) 
 
  if (check_access_to_data()){
    data <- get_eurostat("ei_isset_q")
    head(data)
    
    filtered_data <- data %>%
      filter(geo == "DE",
             indic_bt == "NETTUR",
             nace_r2 == "I",
             unit == "I21",
             s_adj == "CA") %>%
      arrange(TIME_PERIOD) %>%
      dplyr::select(TIME_PERIOD, values) %>%
      na.omit()
    
    ts_data <- ts(filtered_data$values,
                  start = c(lubridate::year(min(filtered_data$TIME_PERIOD)),
                            lubridate::quarter(min(filtered_data$TIME_PERIOD))),
                  frequency = 4)
    return(ts_data)
  }else{
    return(0)
  }
}