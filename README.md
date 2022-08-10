# Gerador_metadados
Esse é um shiny app desenvolvido para facilitar a geração de metadados experimentais, bem como a compilação de todos os metadados em um arquivo único, o **Mastermetadado**.

Mais detalhes sobre o uso do APP serão depositados em breve.

Para utilizar o APP Shiny "Gerador de metadados experimentais" na sua maquina, sugiro os seguintes caminhos:

**A forma mais facil** é lançar o programa através do R ou do RStudios com o seguinte comando:
OBS: simplesmente copie e cole o comando abaixo no R e aperte enter.

  ```
if (!require(shiny)) install.packages('shiny')
library(shiny)
runGitHub("Gerador_metadados", "gbarbosabio")
```

A outra forma é fazer o download desse diretório do GitHub no seu computador e lançar o programa através do R ou RStudio.


Pré-requisito 1: Instalar R: <h>https://www.r-project.org/<h>
  
Pré-requisito 2: Instalar RStudio <h>https://www.rstudio.com/<h>
  
Passo 1: Fazer download do Gerador de metadados clicando em "Code" (botão verde), "Download Zip"
  
Passo 2: Descomprensar arquivo zip
  
Passo 3: Abrir arquivo GME.R dentro da pasta GME_R utilisando o RStudio
  
Passo 4: Apertar o botão "Run App" no RStudio  

Para mais formas de abrir o Shiny APP por favor consultar link: <h>https://shiny.rstudio.com/tutorial/written-tutorial/lesson7/<h>
  
O **Gerador de metadados experimentais** Shiny APP foi desenvolvido por **Guilherme Oliveira Barbosa** e está sob a Licença **MIT**
