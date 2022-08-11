#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

if (!require(shiny)) install.packages('shiny')
library(shiny)
if (!require(ids)) install.packages('ids')
library(ids)
if (!require(shinyFiles)) install.packages('shinyFiles')
library(shinyFiles)
if (!require(readr)) install.packages('readr')
library(readr)

cnames<-c("Número_identificador","Data_hora_registro","Pesquisador","Título",
          "Financiamento","Resumo","Metodologia","Equipamento","Detalhes",
          "Grupo_genétipos","Outras_informações","Análise","Software","Caminho",
          "Lista_arquivo")

ui <- fluidPage(
  titlePanel(div(
    img(src= "fapesp.jpg",  height = 130, align = "right"),
    h1("Plano de gestão de dados", align = "center"),
    h2("Gerador de metadados experimentais", align = "center"),
    h4("Criado por Guilherme Oliveira Barbosa", align = "center")
  )),
  br(),
  br(),
  sidebarLayout(
    sidebarPanel(
      h5("Passo 1- Escolha o diretório do experimento", align = "left"),
      shinyDirButton("dir_wd", 'Escolha a pasta', 'Escolha a pasta do experimento',FALSE,  align="center"),
      textOutput("selected_dir_wd"),
      br(),
      h5(strong("Já possui o Master Metadata?", align="left")),
      tabsetPanel(
        tabPanel("Resposta --->"),
        tabPanel("NÃO",
                 br(),
                 h5("Passo 2 - Clique na aba informação e preencha os metadados do experimento", align="center"),
                 br(),
                 h5("Passo 3 - Verifique o metadado experimental na aba Revise o metadado", align="center"),
                 br(),
                 h5("Passo 4 - Clique no botão a baixo para criar e salvar Master Metadata", align="center"),
                 downloadButton("save1", "Criar & Salvar Master Metadata"),
                 h6("OBS: Não precisa abrir o Master Metadata caso tenha criado o arquivo agora", align="center"),
                 br(),
                 conditionalPanel(
                   condition = "input.dir_wd",
                   h5("Passo 5 - Clique no botão a baixo para salvar o metadado experimental do diretório do experimeno"),
                   actionButton("save2", "Salvar metadado experimental", align="right"),
                   textOutput("message2"))
        ),
        tabPanel("SIM",
                 br(),                       
                 h5("Passo 2 - Encontre e abra o Master Metadata", align="center"),
                 shinyFilesButton("file1", "Abrir Master Metadata", "Encontre o Master Metadata", FALSE),
                 textOutput("selected_file1"),
                 br(),
                 h5("Passo 3 - Clique na aba informação e preencha os metadados do experimento", align="center"),
                 br(),
                 h5("Passo 4 - Verifique o metadado experimental na aba Revise o metadado", align="center"),
                 br(),
                 conditionalPanel(
                   condition = "input.dir_wd",
                   h5("Passo 5 - Clique no botão a baixo para salvar o metadado experimental do diretório do experimeno"),
                   actionButton("save", "Salvar metadado experimental", align="right"),
                   textOutput("message"))
                 
        )
      )
    ),
    mainPanel(
      h1("Área de trabalho do metadado"),
      h4("Visualise, edite, e reveja o metadado experimental"),
      br(),
      tabsetPanel(
        tabPanel("Master_metadata",
                 fluidPage(
                   br(),
                   DT::dataTableOutput("master"),
                   br(),
                   checkboxGroupInput("show_vars", "Selecione as colunas visíveis no Master Metadata:",
                                      cnames,selected = cnames[c(1,2,3,14)], inline = T, width = "80%")
                 )
        ),  
        tabPanel("Informação",
                 fluidPage(
                   h4("Prencher os dados a baixo sem utilizar vírgula"),
                   textAreaInput("pesquisador", h2("Nome do pesquisador"), 
                                 placeholder = "Digite o nome do pesquisador...", width = "80%"),
                   textAreaInput("titulo", h2("Título do projeto"), 
                                 placeholder = "Digite o título do projeto...", width = "80%"),
                   textAreaInput("financiamento", h2("Financiamento"), 
                                 placeholder = "Digite os financiamentos separados por ponto e vígula...", width = "80%"),
                   textAreaInput("resumo", h2("Resumo do experimento"), 
                                 placeholder = "Digite resumo...", width = "80%"),
                   textAreaInput("metodo", h2("Metodologia"), 
                                 placeholder = "Digite a metodologia...", width = "80%"),
                   textAreaInput("equipamento", h2("Equipamento utilizado"), 
                                 placeholder = "Digite sobre o equipamento utilizado", width = "80%"),
                   textAreaInput("detalhes", h2("Detalhes específicos do equipamento"), 
                                 placeholder = "Digite detalhes se houver...", width = "80%"),
                   textAreaInput("grupos", h2("Grupos ou genótipos do experimento"), 
                                 placeholder = "Digite grupos ou genótipos separados por ponto e vígula...", width = "80%"),
                   textAreaInput("outras", h2("Outras informações do experimento"), 
                                 placeholder = "Digite outras informações do experimento...", width = "80%"),
                   textAreaInput("analise", h2("Análise de dados"), 
                                 placeholder = "Indique qual análise esta sendo feita com os dados neste folder...", width = "80%"),
                   textAreaInput("software", h2("Software"), 
                                 placeholder = "Indique software utilizados para visiualizar os dados...", width = "80%")
                 )
        ),
        tabPanel("Revise o metadado",
                 htmlOutput("selected_metadata"),
        )
      )
    )
  )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  
 observeEvent(input$pesquisador,{
   idmeta <<- as.character(random_id(bytes = 8, use_openssl = T))
   datahoraagora <<- as.character(Sys.time())
 })

  
  df <- reactive({
    new.df <- data.frame(
      Número_identificador= idmeta,
      Data_hora_registro= datahoraagora,
      Pesquisador= paste(input$pesquisador),
      Título= paste(input$titulo),
      Financiamento= paste(input$financiamento),
      Resumo= paste(input$resumo),
      Metodologia= paste(input$metodo),
      Equipamento= paste(input$equipamento),
      Detalhes= paste(input$detalhes),
      Grupo_genétipos= paste(input$grupos),
      Outras_informações= paste(input$outras),
      Análise= paste(input$analise),
      Software= paste(input$software),
      Caminho= paste("",parseDirPath(c(home = '~'), dirwd())),
      Lista_arquivo= paste("",list.files(parseDirPath(c(home = '~'), dirwd())),sep = ' ', collapse = ';'),
      stringsAsFactors = FALSE)
    
    if(is.integer(input$file1)){
      new.df    
    }else{
      new.df <- rbind(new.df,loadeddf)
      new.df   
    }
  })
  
  

  
  output$save1 <- downloadHandler(
    filename = function() {
      paste("_Mastermetadata", ".csv", sep="")
    },
    content = function(file) {
      write_csv(df(),file)
    }
  )
  
  
  output$master <- DT::renderDataTable({df()[, input$show_vars, drop = FALSE]})
  
  shinyFileChoose(input, 'file1', roots = c(home = '~')) 
  observeEvent(input$file1,{
    infile <- parseFilePaths(c(home = '~'), input$file1)
    req(input$file1)
    loadeddf <<- read_csv(as.character(infile$datapath), col_types = "cc")
    output$selected_file1<-renderText({  
      paste(infile$datapath)
    })
  })
  
  
  shinyDirChoose(input, 'dir_wd', roots = c(home = '~'))
  dirwd <- reactive(input$dir_wd)
  output$selected_dir_wd<-renderText({  
    parseDirPath(c(home = '~'), dirwd())
  })
  
  output$selected_metadata <- reactive({
    
    n <- paste("Número identificador do metadado:", idmeta)
    o <- paste("Data e hora de registro: ", datahoraagora)
    a <- paste("Nome do pesquisador: ", input$pesquisador )
    b <- paste("Título do projeto: ", input$titulo )
    c <- paste("Financiamento: ", input$financiamento )
    d <- paste("Resumo do experimento: ", input$resumo )
    e <- paste("Metodologia: ", input$metodo )
    f <- paste("Equipamento utilizado: ", input$equipamento )
    g <- paste("Detalhes do experimento: ", input$detalhes )
    h <- paste("Grupos ou genótipos dos experimento: ", input$grupos )
    i <- paste("Oustas informações dos experimento: ", input$outras )
    j <- paste("Análise de dados: ", input$analise )
    k <- paste("Software utilizado: ", input$software )
    l <- paste("Caminho da pasta do experimento: ", parseDirPath(c(home = '~'), dirwd()) ) 
    m <- paste((list.files(parseDirPath(c(home = '~'), dirwd()))),sep = ' ', collapse = '<br/>')
    
    metadatadata <<- HTML(paste(n,'<br/>', o,'<br/>', a,'<br/>',b,'<br/>',c,'<br/>',d,'<br/>',e,'<br/>',
                                f,'<br/>',g,'<br/>',h,'<br/>',i,'<br/>',j,'<br/>',k,'<br/>',l,'<br/>', '<br/>',
                                '<b>', "Lista dos arquivos contidos nesta pasta:",'<b/>', 
                                '<br/>', m,'<br/>','<br/>','<br/>','<br/>','<br/>',
                                "Esse metadata foi gerado pelo Experimental metadata creator por Guilherme Oliveira Barbosa",'<br/>',
                                "Lincença MIT"))
  })
  
  observeEvent(input$save,{
    setwd(parseDirPath(c(home = '~'), dirwd()))
    writeLines(metadatadata, 
               paste(input$pesquisador,"_",idmeta,"_",Sys.Date(),"_metadata", ".html", sep=""))
    output$message <- renderText(paste("O metadado do experimento foi salvo em: ", parseDirPath(c(home = '~'), dirwd()))) #colocar frase afirmativa do salvamento
    infile <- parseFilePaths(c(home = '~'), input$file1)
    write_csv(df(), infile$datapath)
  })
  
  observeEvent(input$save2,{
    setwd(parseDirPath(c(home = '~'), dirwd()))
    writeLines(metadatadata, 
               paste(input$pesquisador,"_",idmeta,"_",Sys.Date(),"_metadata", ".html", sep=""))
    output$message2 <- renderText(paste("O metadado do experimento foi salvo em: ", parseDirPath(c(home = '~'), dirwd()))) #colocar frase afirmativa do salvamento
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
