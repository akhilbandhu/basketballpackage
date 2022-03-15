ui <- fluidPage(
  
  # Put a titlePanel here
  titlePanel("Basketball Package"),
  
  # Read in the basketball dataset
  mainPanel(
    textOutput("heading"),
    tableOutput('basketball_data'),
    plotOutput('plot1'),
    plotOutput('plot2'),
    textOutput("mutate"),
    tableOutput('mutate_function'),
    plotOutput('plot3'),
    textOutput("arrange"),
    tableOutput('arrange_function'),
    textOutput("select"),
    tableOutput('select_function'),
    textOutput("filter"),
    tableOutput('filter_function'),
    textOutput("SUU"),
    tableOutput('SUU_function'),
    plotOutput('plot4')
  )
)
