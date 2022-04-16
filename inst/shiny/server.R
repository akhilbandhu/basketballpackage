server <- function(input, output, session) {
  basketball_data <- as_tibble(
    read.fwf(
      'http://kenpom.com/cbbga22.txt', 
      widths=c(11,24,3,23,4,4,21), 
      strip.white = T
    )
  )
  
  # if(is_null(input$team_name)) {
  #   team <- "Southern Utah"
  # }else{
  #   team <- reactive({
  #     input$team_name
  #   })
  # }
  # 
  mutated_table <- mutate_function(basketball_data)
  arranged_table <- arrange_function(mutated_table)
  selected_table <- remove_function(mutated_table)
  table_2022 <- func_2022_games(selected_table)
  SUU_table <- team_function(table_2022, "Southern Utah")
  
  # Basketball
  kenpom22_conf <- read.csv("~/Downloads/kenpom22_conf.csv")
  away_avg_score <- kenpom22_conf %>%                                       
    group_by(vis) %>%   
    # mutate(avg_away_score = mean(AwayScore))
    summarise_at(vars(score2),
                 list(name = mean))
  
  # Home
  home_avg_score <- kenpom22_conf %>%                                       
    group_by(home) %>%   
    # mutate(avg_away_score = mean(AwayScore))
    summarise_at(vars(score1),
                 list(name = mean))
  
  
  # Well this works so we'll go ahead and use it
  # test_basketball$avg_away_score <- ave(basketball_data$AwayScore, basketball_data$AwayTeam)
  # okay now to the otehrs
  # Things to do:
  # Average Points Scored : Total Score, Home Score
  # Average Points Allowed: Total Score, Home Score, Away Score
  # Score difference: Total, Home, Away
  # Winning Percentage: Total, Home, Away
  # Conference
  # Tournament Participation: boolean
  # I see we got to make a brand new dataset
  # Start with Average points
  names(away_avg_score)[1] <- "TeamName"
  names(home_avg_score)[1] <- "TeamName"
  
  new_basketball <- merge(x=away_avg_score,y=home_avg_score,by="TeamName",all=TRUE)
  names(new_basketball)[2] <- "avg_away_score"
  names(new_basketball)[3] <- "avg_home_score"
  
  new_basketball <- new_basketball %>%
    mutate(avg_total_score = (avg_away_score+avg_home_score)/2)
  
  # Average Points Allowed: Total Score, Home Score, Away Score
  home_avg_allowed <- kenpom22_conf %>%                                       
    group_by(home) %>%   
    # mutate(avg_away_score = mean(AwayScore))
    summarise_at(vars(score2),
                 list(name = mean))
  
  away_avg_allowed <- kenpom22_conf %>%                                       
    group_by(vis) %>%   
    # mutate(avg_away_score = mean(AwayScore))
    summarise_at(vars(score1),
                 list(name = mean))
  
  names(away_avg_allowed)[1] <- "TeamName"
  names(home_avg_allowed)[1] <- "TeamName"
  new_basketball <- merge(x=new_basketball,y=away_avg_allowed,by="TeamName",all=TRUE)
  new_basketball <- merge(x=new_basketball,y=home_avg_allowed,by="TeamName",all=TRUE)
  names(new_basketball)[5] <- "avg_home_allowed"
  names(new_basketball)[6] <- "avg_away_allowed"
  
  new_basketball <- new_basketball %>%
    mutate(avg_total_allowed = (avg_away_allowed+avg_home_allowed)/2)
  
  # Score difference: Total, Home, Away
  # Let's go with average score difference
  # Away First
  # how about we just use kenpom_conf22 as our dataset
  # it's cleaner
  away_avg_score_diff <- kenpom22_conf %>%                                       
    group_by(vis) %>%   
    summarise_at(vars(score_diff),
                 list(name = mean))
  
  home_avg_score_diff <- kenpom22_conf %>%                                       
    group_by(home) %>%   
    summarise_at(vars(score_diff),
                 list(name = mean))
  
  names(away_avg_score_diff)[1] <- "TeamName"
  names(home_avg_score_diff)[1] <- "TeamName"
  new_basketball <- merge(x=new_basketball,y=away_avg_score_diff,by="TeamName",all=TRUE)
  new_basketball <- merge(x=new_basketball,y=home_avg_score_diff,by="TeamName",all=TRUE)
  names(new_basketball)[8] <- "away_avg_score_diff"
  names(new_basketball)[9] <- "home_avg_score_diff"
  # now we need to change the sign of the away average difference
  new_basketball$away_avg_score_diff <- new_basketball$away_avg_score_diff*-1
  
  # now lets do win percentages
  kenpom22_conf <- kenpom22_conf %>%
    group_by(home) %>%   
    mutate(win_home = ifelse(score_diff > 0,1,0))
  
  #away wins
  kenpom22_conf <- kenpom22_conf %>%
    group_by(vis) %>%   
    mutate(win_away = ifelse(score_diff < 0,1,0))
  
  # now that we have the boolean
  # we can do win percentage
  home_win_percetage <- kenpom22_conf %>%
    group_by(home) %>%
    summarize(win_percentage = sum(win_home)/n()*100)
  
  away_win_percetage <- kenpom22_conf %>%
    group_by(vis) %>%
    summarize(win_percentage = sum(win_away)/n()*100)
  
  names(home_win_percetage)[1] <- "TeamName"
  names(away_win_percetage)[1] <- "TeamName"
  new_basketball <- merge(x=new_basketball,y=home_win_percetage,by="TeamName",all=TRUE)
  new_basketball <- merge(x=new_basketball,y=away_win_percetage,by="TeamName",all=TRUE)
  names(new_basketball)[10] <- "home_win_percetage"
  names(new_basketball)[11] <- "away_win_percetage"
  
  # dropped all nas
  new_basketball <- new_basketball[complete.cases(new_basketball),]
  
  new_basketball <- new_basketball %>%
    mutate(total_win_percentage = (home_win_percetage+away_win_percetage)/2)
  
  # to get conference, we will have to left join new_basketball with kenpom22_conf
  #this actually gets conference data
  for(i in 1:nrow(new_basketball)) {
    for(j in 1:nrow(kenpom22_conf)) {
      if(new_basketball$TeamName[i] == kenpom22_conf$home[j]) {
        new_basketball$conference[i] <- kenpom22_conf$home_conference[j]
        break
      }
      if(new_basketball$TeamName[i] == kenpom22_conf$vis[j]) {
        new_basketball$conference[i] <- kenpom22_conf$vis_conference[j]
        break
      }
    }
  }
  
  # now get if they played in the tournament or not
  for(i in 1:nrow(new_basketball)) {
    for(j in 1:nrow(tournament)) {
      if(new_basketball$TeamName[i] == tournament$ID[j]) {
        new_basketball$tournament[i] <- 1
        break;
      }
      else{
        new_basketball$tournament[i] <- 0
      }
    }
  }
  
  # PCA
  pca_basketball <- prcomp(new_basketball[2:11], scale = TRUE)
  pca_basketball
  
  plot(pca_basketball)
  
  pca_data_basket <- as.data.frame(pca_basketball$x[, 1:2]) # extract first two columns and convert to data frame
  pca_data_basket <- cbind(pca_data_basket, new_basketball$total_win_percentage) # bind by columns
  colnames(pca_data_basket) <- c("PC1", "PC2", "Win Percentage") # change column names
  
  # UMAP
  umap_basketball <- umap(new_basketball[,2:11])
  
  # team_table <- team_function(table_2022, team)
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
  output$plot5 <- renderPlot({
    ggplot(pca_data_basket) +
      aes(PC1, PC2, color = 1, shape = 1) + # define plot area
      geom_point(size = 2) +
      scale_shape_identity()# adding data points
  })
  output$plot6 <- renderPlot({
    data.frame(umap_basketball$layout) %>%
      ggplot(aes(X1,X2, color = 1, shape = 1))+
      geom_point() +
      scale_shape_identity() +
      coord_fixed(ratio = 1)
  })
  
}
