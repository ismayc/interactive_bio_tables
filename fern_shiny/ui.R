library(rhandsontable)

shinyUI(fluidPage(
  titlePanel(p("Bio 332: Data Entry for ", em("Ceratopteris richardii"))),
  p("Contact Chester Ismay (", 
    a("cismay@reed.edu", href = "mailto:cismay@reed.edu"),
    ") with questions"),
  sidebarPanel(
    textInput("name", label = "Your first and last name", value = ""),
    textInput("email", label = "Your full Reed email address", value = "")
  ),
  actionButton("save_csv_btn", "Save to CSV"),
  verbatimTextOutput("txt_csv"),
  actionButton("save_class_btn", "Send to Class Google Sheet"),
  verbatimTextOutput("txt_class"),
  rHandsontableOutput(outputId = "hot")
))
