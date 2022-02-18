#' Removing the 6th and 7th columns from the basketball data set
#' 
#' As of now the columns have not been named so just using V6 and V7 
#'
#' @param basketball_data the data frame we are using to do the manipulation
#'
#' @export
#' 

remove_function <- function(basketball_data) {
  basketball_data <- basketball_data %>% 
    select(-V6, -V7)
}