#' Function that will summarize the data for a team win loss percentage record
#' 
#' @param basketball_data the data frame we are using to do the manipulation
#'
#' @export
#' 

summarize_function <- function(basketball_data, team_name) {
  data <- basketball_data %>% 
    filter(grepl(team_name,TeamName)) %>%
    mutate(win = ifelse(V3 > V5,1,0))
  data2 <- basketball_data %>%
    filter(grepl(team_name,V4)) %>%
    mutate(win = ifelse(V5 > V3,1,0))
  data <- rbind(data,data2)
  win_percentage <- sum(data$win)/nrow(data)
  win_percentage
}
