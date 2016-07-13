## Install and load packages if needed
pkg <- c("dplyr", "readr", "googlesheets", "rhandsontable")
new.pkg <- pkg[!(pkg %in% installed.packages())]
if (length(new.pkg)) {
  install.packages(new.pkg, repos = "https://cran.rstudio.com")
}
lapply(X = pkg, FUN = library, character.only = TRUE)

key <- "1ipLs1UXf4vGaeIjHzUGNvOnlwbq8nIoRAccxqWFevfc"
if(!(key %in% gs_ls()$sheet_key)){
  header <- t(c("rep_name", "rep_email", 
    "dish_position", "density_trt", "actual_spore_num", 
    "mono_count", "uni_count"))
  initial_row <- t(c("default", "a@b.com", 0, 0, 0, 0, 0))
  initial <- rbind(header, initial_row)
  
  cera_sheet <- gs_new(title = "Ceratopteris richardii - data collection - shiny",
    input = initial,
    ws_title = "Data")
  
  #> Key: 1ipLs1UXf4vGaeIjHzUGNvOnlwbq8nIoRAccxqWFevfc
  #> Alternate key: 1ipLs1UXf4vGaeIjHzUGNvOnlwbq8nIoRAccxqWFevfc
  #> Browser URL: https://docs.google.com/spreadsheets/d/1ipLs1UXf4vGaeIjHzUGNvOnlwbq8nIoRAccxqWFevfc/
}