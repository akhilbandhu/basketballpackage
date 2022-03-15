#' Shiny Basketball Package function
#' 
#' This function will create the shiny app for the basketball package.
#' The appdir object basically looks for the shiny folder in the basketball 
#' package and runs the ui and server functions.
#'
#' The ui.R file will create the ui for the application.
#' The server.R will set up the server.
#' The app.R function sources both the ui and server functions. 
#' 
#' @export
#' 

shiny_basketball_app <- function() {
  appdir <- system.file("shiny", package = "basketballpackage")
  shiny::runApp(appdir)
}