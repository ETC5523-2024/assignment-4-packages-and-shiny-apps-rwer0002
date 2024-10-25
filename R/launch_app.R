#' @export
launch_app <- function() {
  app_dir <- system.file("grasslandbirds-app", package = "grasslandbirds")
  shiny::runApp(app_dir, display.mode = "normal")
}



