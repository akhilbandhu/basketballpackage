test_data <- basketball_data %>% 
  arrange(Venue)
basketball_data <- arrange_function(basketball_data)
expect_equal(
  basketball_data, test_data
)