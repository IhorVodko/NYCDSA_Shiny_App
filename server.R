#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#TA=input$volume

# library(shinydashboard)
# library(quantmod)
# library(moments)
# library(DT)


function(input, output, session){
      
    observeEvent(input$view, {close.adj=getSymbols(input$symbol, from=input$date[1],
                                                    env = NULL)
                              output$chart <- renderPlot({chartSeries(close.adj, type=input$style,
                                                                     TA=input$bb)}) 
                           }
                 )
    observeEvent(input$do, {
    session$sendCustomMessage(type = 'testmessage',
                               message = 'If API does not work, try another ticker or restart the app')
    })
    observeEvent(input$apply, {close.adj=getSymbols(input$symbol, from=input$date[1],
                                                    to=input$date[2], env = NULL)
                            output$chart <- renderPlot({chartSeries(close.adj, type=input$style, TA=input$bb
                                            )})
                                 }
                )
    observeEvent(input$view, {close.adj=getSymbols(input$symbol, from=input$date[1], to=input$date[2], env=NULL)
                              close.adj$rtn = diff(log(close.adj[, 6]))
                              output$r_chart <- renderPlot({chartSeries(close.adj$rtn)})
                              output$r_ch <- renderPlot({ggplot(data = close.adj, aes(x=close.adj$rtn)) + 
                                  geom_density(colour='green', fill='#33BF66', alpha=0.5)+theme(plot.background = 
                                  element_rect(fill='#242525'), panel.background = element_rect(fill='#292B2C'),
                                  panel.grid.minor = element_blank())+xlab('daily log_returns')+
                                  theme(axis.text=element_text(size=18, colour='#0FDD16'), axis.title=
                                  element_text(size=18, colour='#0DC22E'))
                              })
                              output$mean <- renderPrint({cat(paste(round(mean(close.adj$rtn, na.rm=TRUE),5),
                                'p-value:', round(t.test(close.adj$rtn, na.rm = TRUE)$p.value, 5), sep='\n')) })
                              output$sd <- renderPrint({sd(close.adj$rtn, na.rm=TRUE)})
                              output$skew <- renderPrint({cat(paste(round(skewness(close.adj$rtn, na.rm=TRUE),5), 'p-value:',
                                  round( 2*(pnorm( (skewness(close.adj$rtn, na.rm=TRUE))/sqrt(6/nrow(close.adj)) )),5), sep='\n'))
                                                                })
                              output$kurt <- renderPrint({cat(paste(round(kurtosis(close.adj$rtn, na.rm=TRUE),5), 'p-value:',
                                                                    round( 2*(1-pnorm( (kurtosis(close.adj$rtn, na.rm=TRUE))/sqrt(24/nrow(close.adj)) )),5), sep='\n'))
                                            })
                            }
                 )

    observeEvent(input$view, {
        sym = getSymbols(input$symbol, from=input$date[1], to=input$date[2], env = NULL)
        sym_d = data.frame(sym)
        sym_d$Date = index(sym)
        sym_d = subset(sym_d, select=c(Date, 1:6))
        output$table <- DT::renderDataTable({
        datatable(sym_d, options = list(pageLength = 16), filter='top', rownames=FALSE
                  )})
                                        })
}