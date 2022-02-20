data <- as_tibble(read.fwf('http://kenpom.com/cbbga22.txt', widths=c(11,24,3,23,4,4,21), strip.white = T))

names(data)[2] <- "TeamName"

test_data  <- data %>% 
  filter(grepl("Southern Utah",TeamName)) %>%
  mutate(win = ifelse(V3 > V5,1,0))
test_data2 <- basketball_data %>%
  filter(grepl("Southern Utah",V4)) %>%
  mutate(win = ifelse(V5 > V3,1,0))
data <- rbind(test_data,test_data)
win_percentage <- sum(data$win)/nrow(data)

testing_data <- summarize_function(data, "Southern Utah")

expect_equal(win_percentage, testing_data)