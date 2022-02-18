#' Function that will filter the tibble to only games played by a given team
#' 
#'
#' @param basketball_data the data frame we are using to do the manipulation
#' @param team_name the name of the team of whose games we want
#'
#' @export
#' 

team_function <- function(basketball_data, team_name) {
  basketball_data %>% 
    filter(grepl(team_name,V2) | grepl(team_name,V4))
}