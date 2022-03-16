ui <- fluidPage(
  
  # Put a titlePanel here
  titlePanel("Basketball Package"),
  
  # Read in the basketball dataset
  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("Reading in Dataset", 
                         textOutput("heading"),
                         tableOutput("basketball_data")),
                tabPanel("Home and Away Team Scores", 
                         plotOutput('plot1'),
                         plotOutput('plot2')),
                tabPanel("Mutate Function",
                         textOutput("mutate"),
                         tableOutput('mutate_function')),
                tabPanel("Score Differences Plot",
                         plotOutput('plot3')),
                tabPanel("Arrange Function",
                         textOutput("arrange"),
                         tableOutput('arrange_function')),
                tabPanel("Select Function",
                         textOutput("select"),
                         tableOutput('select_function')),
                tabPanel("Filter Function",
                         textOutput("filter"),
                         tableOutput('filter_function')),
                tabPanel("SUU Games",
                         textOutput("SUU"),
                         tableOutput('SUU_function')),
                tabPanel("Score differences for SUU",
                         plotOutput('plot4'))
    )
  )
)
