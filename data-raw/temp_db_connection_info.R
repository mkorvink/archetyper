

config <- config::get()

con <- DBI::dbConnect(odbc::odbc(),
                      Driver   = "PostgreSQL Driver",
                      Server   = config$server,
                      Database = config$pw,
                      UID      = config$username,
                      PWD      = config$password,
                      Port     = 5432)
