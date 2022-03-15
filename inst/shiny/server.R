server <- function(input, output, session) {
  basketball_data <- as_tibble(
    read.fwf(
      'http://kenpom.com/cbbga22.txt', 
      widths=c(11,24,3,23,4,4,21), 
      strip.white = T
    )
  )
  
  mutated_table <- mutate_function(basketball_data)
  arranged_table <- arrange_function(mutated_table)
  selected_table <- remove_function(mutated_table)
  table_2022 <- func_2022_games(selected_table)
  SUU_table <- team_function(table_2022, "Southern Utah")
  # names(basketball_data)[1] <- "Date"
  # names(basketball_data)[2] <- "Team 1"
  # names(basketball_data)[3] <- "Score Team 1"
  # names(basketball_data)[4] <- "Team 2"
  # names(basketball_data)[5] <- "Score Team 2"
  output$heading <- renderText({
    "Reading in the original table"
  })
  output$mutate <- renderText({
    "Creating a new column that designates where each game was played. 
        Also create a column that gives the score differences (team1−team2).
      Looking at the graph you can see that most score difference lie between
      5 and 15 with outliers in the bigger score differences"
  })
  output$arrange <- renderText({
    "Sort the dataset by the location where the game was played."
  })
  output$select <- renderText({
    "Remove V6 and V7"
  })
  output$fiter <- renderText({
    "Filter 2022 games"
  })
  output$SUU <- renderText({
    "Filter 2022 SUU games. The plot below shows the usual score difference in 
      SUU games"
  })
  output$basketball_data <- renderTable({
    return(head(basketball_data))
  })
  output$mutate_function <- renderTable({
    return(head(mutated_table))
  })
  output$arrange_function <- renderTable({
    return(head(arranged_table))
  })
  output$select_function <- renderTable({
    return(head(selected_table))
  })
  output$filter_function <- renderTable({
    return(head(table_2022))
  })
  output$SUU_function <- renderTable({
    return(head(SUU_table))
  })
  output$plot1 <- renderPlot({
    ggplot(mutated_table, 
           aes(x=V1,y=V3)
    ) + geom_boxplot() + 
      labs(
        x= "Date", 
        y="Score", 
        title = "Away Team Scores"
      ) +
      ylim(0,150) 
    # scale_x_date(date_labels = "%Y")
  })
  output$plot2 <- renderPlot({
    ggplot(mutated_table, 
           aes(x=V1,y=V5)
    ) + geom_boxplot() + 
      labs(
        x= "Date", 
        y="Score", 
        title = "Home Team Scores"
      ) +
      ylim(0,150) 
    # scale_y_continuous(breaks = c(0,50,100,150,200))
    # scale_x_date(date_labels = "%Y")
  })
  output$plot3 <- renderPlot({
    ggplot(mutated_table, 
           aes(
             x=1:nrow(mutated_table),
             y = score_difference)
    ) + 
      geom_boxplot() + 
      labs(
        x="Game Number",
        y="Score Difference",
        title="Score differences in games played"
      )
  })
  output$plot4 <- renderPlot({
    ggplot(SUU_table, 
           aes(
             x=1:nrow(SUU_table),
             y = score_difference)
    ) + 
      geom_boxplot() + 
      labs(
        x="Game Number",
        y="Score Difference",
        title="Score differences in SUU games"
      )
  })
  
}
