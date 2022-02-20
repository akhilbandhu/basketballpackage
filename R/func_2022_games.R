#' Filtering all games played in 2022
#' 
#'
#' @param basketball_data the data frame we are using to do the manipulation
#'
#' @return return the data set with only 2022 games
#' @export
#' 

func_2022_games <- function(basketball_data) {
  basketball_2022_data <- basketball_data %>% 
    filter(as.Date(basketball_data$V1, format = "%m/%d/%Y") >= as.Date("2022/01/01"))
  return(basketball_2022_data)
}