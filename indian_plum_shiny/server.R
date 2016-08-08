## Install and load packages if needed
pkg <- c("dplyr", "readr", "googlesheets", "rhandsontable")
new.pkg <- pkg[!(pkg %in% installed.packages())]
if (length(new.pkg)) {
  install.packages(new.pkg, repos = "https://cran.rstudio.com")
}
lapply(X = pkg, FUN = library, character.only = TRUE)


shinyServer(function(input, output, session) {
  
  # Create list called values with one entry named "hot".  This will be the interactive table.
  # This is done to use the is.null condition later
  values <- list()
  setHot <- function(x){ 
    values[["hot"]] <<- x
  }
  
  # Watch to see if Save to CSV button pressed
  observe({
    x = input$save_csv_btn
    
    # If DF, name, and email are all non-empty, write (name, email, DF) to out.csv
    if (!is.null(values[["hot"]]) && (input$name != "") && (input$email != "")) {
      rep_name <- rep(input$name, total_num)
      rep_email <- rep(input$email, total_num)
      write_csv(x = cbind(rep_name, rep_email, values[["hot"]]), path = "out.csv")
    }
    
  })
  
  # When the Save to CSV button is clicked produce text in the app
  observeEvent(input$save_csv_btn, {
    output$txt_csv <- renderText("You have saved your results to the file out.csv")
  })
  
  # Watch to see if Send to Google Form button pressed
  observe({
    x = input$save_class_btn
    
    # If DF, name, and email are all non-empty, write (name, email, DF) to Google Form
    if (!is.null(values[["hot"]]) && (input$name != "") && (input$email != "") ) {
      rep_name <- rep(input$name, total_num)
      rep_email <- rep(input$email, total_num)
      out_df <- cbind(rep_name, rep_email, values[["hot"]])
      gs_url("https://docs.google.com/spreadsheets/d/17zzPVP3Uq9ztYXtV9oHc4XqiPSfcZzkxqoIvPpURKEY/") %>%
        gs_add_row(input = out_df)
    }
  })
  
  # When the Send to Google Sheet button is clicked produce text in the app
  observeEvent(input$save_class_btn, {
    output$txt_class <- renderText("You have saved your results to the class Google Sheet.")
  })
  
  # Specify interactive table values
  output$hot <- renderRHandsontable({
    if (!is.null(input$hot)) {
      # Update table as needed
      # Warnings are suppressed to avoid NA barks for missing integer values in Console
      DF <- suppressWarnings(hot_to_r(input$hot))
    } else {
      # Create initial table to display
      order <- 1:total_num
      plant_height <- as.numeric(rep("", total_num))
      stem_diameter <- as.integer(rep("", total_num))
      flowering <- rep("", total_num)
      inflor <- rep("", total_num)
      sex <- rep("", total_num)
      flower1 <- as.integer(rep("", total_num))
      flower2 <- as.integer(rep("", total_num))
      flower3 <- as.integer(rep("", total_num))
      box_id <- as.integer(rep("", total_num))
      DF <- data_frame(order, plant_height, stem_diameter, flowering,
                       inflor, sex, flower1, flower2, flower3, box_id) %>%
        # Have column names be on multiple rows
        rename(`plant height (m)` = plant_height,
          `stem diameter (cm)` = stem_diameter,
          `flowering? (Y/N)` = flowering,
          `inflor (Y/N)` = inflor,
          `sex (M/F)` = sex,
          `Flower #1` = flower1,
          `Flower #2` = flower2,
          `Flower #3` = flower3,
          `Box ID #` = box_id)
    }
    
    # Set the interactive portion to be DF defined above
    setHot(DF)
    
    # Format the visual output of the interactive table
    rhandsontable(DF, rowHeaders = NULL) %>%
      hot_table(highlightCol = TRUE, highlightRow = TRUE) %>%
      hot_context_menu(allowRowEdit = FALSE, allowColEdit = FALSE) %>%
      hot_col(col = "order", readOnly = TRUE) %>%
      hot_validate_numeric(cols = c("plant height (m)", "stem diameter (cm)",
        "Flower #1", "Flower #2", "Flower #3", "Box ID #"), 
        min = 0) %>%
      hot_validate_character(cols = c("flowering? (Y/N)", "inflor (Y/N)"),
                             choices = c("Y", "N")) %>%
      hot_validate_character(cols = "sex (M/F)",
                             choices = c("M", "F"))       
  })
})
