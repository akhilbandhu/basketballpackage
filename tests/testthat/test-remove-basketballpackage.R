data <- as_tibble(read.fwf('http://kenpom.com/cbbga22.txt', widths=c(11,24,3,23,4,4,21), strip.white = T))

test_data  <- data %>% 
  select(-V6, -V7)

testing_data <- remove_function(data)

expect_equal(test_data, testing_data)