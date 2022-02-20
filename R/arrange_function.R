#' Arranging the data by where the game was played and in descending order
#' 
#' change to desc(Venue) to arrange in descending order
#'
#' @param basketball_data the data frame we are using to do the manipulation
#'
#' @export
#' 

arrange_function <- function(basketball_data) {
  basketball_data <- basketball_data %>% arrange((Venue))
  return(basketball_data)
}