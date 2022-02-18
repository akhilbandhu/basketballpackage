#' Create a new column that designates where each game was
#' played. Also create a column that gives the score differences (team1−team2)
#' 
#' Mutate where the game was played into a new column
#' We are just going to use the second name column to do this
#'
#' The second piece of the code is to get the difference in the scores
#' The absolute value function is used to not get any negative scores
#' @param basketball_data the data frame we are using to do the manipulation
#'
#' @export
#'

mutate_function <- function(basketball_data) {
  basketball_data <- basketball_data %>%
    mutate(Venue = V4)
  basketball_data <- basketball_data %>% 
    mutate(score_difference = (abs(V3-V5)))
  View(basketball_data)
}
