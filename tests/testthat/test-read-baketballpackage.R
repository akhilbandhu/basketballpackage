data <- as_tibble(read.fwf('http://kenpom.com/cbbga22.txt', widths=c(11,24,3,23,4,4,21), strip.white = T))

testing_data <- read_function('http://kenpom.com/cbbga22.txt')

expect_equal(data, testing_data)