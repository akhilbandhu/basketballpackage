data <- as_tibble(read.fwf('http://kenpom.com/cbbga22.txt', widths=c(11,24,3,23,4,4,21), strip.white = T))


test_data <- data %>% filter(
  as.Date(
    data$V1,
    format = "%m/%d/%Y") 
  >= as.Date("2022/01/01"))

testing_data <- func_2022_games(data)

expect_equal(test_data, testing_data)
