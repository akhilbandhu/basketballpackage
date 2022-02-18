#' Function to read in the data
#' 
#' @param fileUrl the file we are reading from
#'
#' @export
#'
#' @return The function will return basketball data as a tibble
#' 

read_function <- function(fileUrl) {
  basketball_data <- as_tibble(read.fwf(fileUrl, widths=c(11,24,3,23,4,4,21), strip.white = T))
  return(basketball_data)
}
