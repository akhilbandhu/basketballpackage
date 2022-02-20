data <- as_tibble(read.fwf('http://kenpom.com/cbbga22.txt', widths=c(11,24,3,23,4,4,21), strip.white = T))

test_data  <- data %>% 
  filter(grepl("Southern Utah",V2) | grepl("Southern Utah",V4))

testing_data <- team_function(data, "Southern Utah")

expect_equal(test_data, testing_data)