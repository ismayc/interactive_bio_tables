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
      rep_name <- rep(input$name, 12)
      rep_email <- rep(input$email, 12)
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
      rep_name <- rep(input$name, 12)
      rep_email <- rep(input$email, 12)
      out_df <- cbind(rep_name, rep_email, values[["hot"]])
      gs_url("https://docs.google.com/spreadsheets/d/1ipLs1UXf4vGaeIjHzUGNvOnlwbq8nIoRAccxqWFevfc/") %>%
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
      dish_position <- c("A1", "A2", "A3", "A4",
        "B1", "B2", "B3", "B4",
        "C1", "C2", "C3", "C4")
      density_trt <- c("many (~10)", "really many (~20)", "some (~5)", "few (~1)",
        "some (~5)", "few (~1)", rep("many (~10)", 2),
        "really many (~20)", "few (~1)", "really many (~20)", "some (~5)")
      actual_spore_num <- as.integer(rep("", 12))
      mono_count <- as.integer(rep("", 12))
      uni_count <- as.integer(rep("", 12))
      DF <- data_frame(dish_position, density_trt, actual_spore_num, 
        mono_count, uni_count) %>%
        # Have column names be on multiple rows
        rename(`Dish \n Position` = dish_position,
          `Density \n Treatment` = density_trt,
          `Actual \n Spore Number` = actual_spore_num,
          `COUNTS \n monoecious` = mono_count,
          `COUNTS \n unisexual` = uni_count)
    }
    
    # Set the interactive portion to be DF defined above
    setHot(DF)
    
    # Format the visual output of the interactive table
    rhandsontable(DF, rowHeaders = NULL) %>%
      hot_table(highlightCol = TRUE, highlightRow = TRUE) %>%
      hot_context_menu(allowRowEdit = FALSE, allowColEdit = FALSE) %>%
      hot_col(col = "Dish \n Position", readOnly = TRUE) %>%
      hot_col(col = "Density \n Treatment", readOnly = TRUE) %>%
      hot_validate_numeric(cols = c("Actual \n Spore Number", "COUNTS \n monoecious",
        "COUNTS \n unisexual"), 
        min = 0)
  })
})
