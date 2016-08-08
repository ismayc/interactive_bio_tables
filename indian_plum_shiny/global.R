## Install and load packages if needed
pkg <- c("dplyr", "readr", "googlesheets", "rhandsontable")
new.pkg <- pkg[!(pkg %in% installed.packages())]
if (length(new.pkg)) {
  install.packages(new.pkg, repos = "https://cran.rstudio.com")
}
lapply(X = pkg, FUN = library, character.only = TRUE)

total_num <- 30

key <- "17zzPVP3Uq9ztYXtV9oHc4XqiPSfcZzkxqoIvPpURKEY"
if(!(key %in% gs_ls()$sheet_key)){
  header <- t(c("rep_name", "rep_email", 
    "order", "plant_height", "stem_diameter", 
    "flowering", "inflor", "sex", 
    "flower1", "flower2", "flower3", "box_id"))
  initial_row <- t(c("default", "a@b.com", 0, 0, 0L, "", "", "", 0L, 0L, 0L, 0L))
  initial <- rbind(header, initial_row)
  
  plum_sheet <- gs_new(title = "Indian Plum - data collection - shiny",
    input = initial,
    ws_title = "Data")
  
  #> Key: 17zzPVP3Uq9ztYXtV9oHc4XqiPSfcZzkxqoIvPpURKEY
  #> Alternate key: 17zzPVP3Uq9ztYXtV9oHc4XqiPSfcZzkxqoIvPpURKEY
  #> Browser URL: https://docs.google.com/spreadsheets/d/17zzPVP3Uq9ztYXtV9oHc4XqiPSfcZzkxqoIvPpURKEY/
}