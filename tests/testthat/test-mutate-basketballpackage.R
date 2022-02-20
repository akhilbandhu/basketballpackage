data <- as_tibble(read.fwf('http://kenpom.com/cbbga22.txt', widths=c(11,24,3,23,4,4,21), strip.white = T))

test_data  <- data %>%
  mutate(Venue = V4)
test_data <- test_data %>% 
  mutate(score_difference = (abs(V3-V5)))

testing_data <- mutate_function(data)

expect_equal(test_data, testing_data)