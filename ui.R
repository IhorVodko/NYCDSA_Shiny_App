#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# library(shinydashboard)
# library(quantmod)
# library(moments)
# library(DT)

# Define UI for application that draws a histogram
dashboardPage(skin='green',
    dashboardHeader(title = 'Trader_v1.0', titleWidth = 230,
                    tags$li(a(href = 'https://www.linkedin.com/in/ihor-vodko/',
                              img(src = 'In_Logo.png',title = "linkedin link", height = "45px")),
                            class = "dropdown"),
                    tags$li(a(href = 'https://github.com/IhorVodko/Shiny_App',
                              img(src = 'Git_Loogo.png',title = "github link", height = "45px")),
                            class = "dropdown")
                    ),
    dashboardSidebar(
        
        sidebarUserPanel("By Ihor Vodko", 
                         tags$img(src = 'pic2.jpg', width = '195', height = '100' ) 
        ),
        sidebarMenu(
            menuItem("Chart Builder", tabName = "chart", icon = icon("chart-line")),
            menuItem('Statistics', tabName='returns', icon = icon('coins')),
            menuItem("Data", tabName = "data", icon = icon("database")),
            textInput("symbol", label = "Enter a ticker (yahoo.finance)", 
                      placeholder = 'For example: AMZN'),
            actionButton('view', label = 'View'),
            tags$head(tags$script(src = "message-handler.js")),
            actionButton("do", "Read before use")
        )
    )    ,
    dashboardBody(
        tabItems(
            tabItem(tabName = "chart",
                    fluidRow(
                        column(width = 12,
                            plotOutput(outputId = "chart")
                        ),
                        column(width = 4,
                            dateRangeInput("date", label = h1('Date range'), start = '2018-01-01'),
                            actionButton('apply', 'Apply changes')
                         ),
                        column(width = 4,
                               radioButtons("bb", label = h1("Bolindger Bands"),
                                            choices = list("No" = 'NULL', "Yes" = 'addBBands(n=20, sd=2.33)'), 
                                            selected = 'NULL')
                               ),
                        column(width = 4, 
                               radioButtons('style', label=h1('Chart Style'),
                                                           choices = list('Line' = 'line', 'Bars'= 'bars', 'Candlesticks'='candlesticks' ) ,
                                                           selected = 'line'
                                            )
                               )
                )
            ),
            tabItem(tabName = "data",
                    fluidRow(box(DT::dataTableOutput("table"), width = 12))
                    ),
            tabItem(tabName = 'returns', 
                        fluidRow(
                            plotOutput(outputId = 'r_chart')
                        ),
                        fluidRow(
                          plotOutput(outputId = 'r_ch')
                          
                        ),
                        fluidRow(
                          box(width=3, title='Avg return', background='black', solidHeader=TRUE, status='warning',
                              textOutput(outputId = 'mean')
                          ),
                          box(width=3, title='Risk', background='black', solidHeader=TRUE, status='warning',
                              textOutput(outputId = 'sd')
                          ),
                          box(width = 3, title='Skewness', background='black', solidHeader=TRUE, status='warning',
                              textOutput(outputId = 'skew')
                          ),
                          box(width = 3, title='Kurtosis', background='black', solidHeader=TRUE, status='warning',
                              textOutput(outputId = 'kurt')
                          ),
                          
                        )
                    )
         )
  )
)

