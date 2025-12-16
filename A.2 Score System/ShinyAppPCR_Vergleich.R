# app.R
suppressPackageStartupMessages({
  libs <- c("shiny","readr","dplyr","ggplot2","tidyr","stringr","forcats")
  to_install <- libs[!libs %in% rownames(installed.packages())]
  if (length(to_install) > 0) install.packages(to_install, repos = "https://cloud.r-project.org")
  lapply(libs, require, character.only = TRUE)
})

# >>>>>>>>>>>> Die 7 Ziel-Positionen – hier leicht editierbar <<<<<<<<<<<
# ACHTUNG: Verwende die Koordinaten GENAU so, wie sie in der bedMethyl stehen (chr, start, end).
target_positions <- tibble::tribble(
  ~chrom, ~start,    ~end,
  "chrX", 71111367L, 71111368L,
  "chrX", 71111452L, 71111453L,
  "chrX", 71111464L, 71111465L,
  "chrX", 71111541L, 71111544L,
  "chrX", 71111621L, 71111622L,
  "chrX", 71111642L, 71111643L,
  "chrX", 71111706L, 71111707L
)

# =======================
# Hilfsfunktionen
# =======================

read_bedmethyl <- function(path) {
  df <- readr::read_tsv(path, col_names = FALSE, show_col_types = FALSE, progress = FALSE, comment = "#")
  if (ncol(df) < 18) stop("Erwarte 18 Spalten im bedMethyl-Format, gefunden: ", ncol(df))
  nm <- c("chr","start","end","modcode","score","strand",
          "thickStart","thickEnd","itemRgb","validcov","percent_modified","nmod",
          "canonical","othermod","delete","fail","diff","nocall")
  names(df)[1:18] <- nm
  df$start            <- as.integer(df$start)
  df$end              <- as.integer(df$end)
  df$percent_modified <- as.numeric(df$percent_modified)
  df
}

filter_only_m <- function(df) dplyr::filter(df, .data$modcode == "m")

agg_pct <- function(df) {
  df %>%
    group_by(chr, start, strand) %>%
    summarise(percent_modified = mean(percent_modified, na.rm = TRUE), .groups = "drop")
}

build_axis_grid <- function(positions_tbl) {
  plus <- positions_tbl %>%
    transmute(chr   = chrom,
              start = start,
              strand = "+",
              x_label = paste0(start, " (+)")) %>%
    mutate(x_ord = row_number() * 2 - 1)
  minus <- positions_tbl %>%
    transmute(chr   = chrom,
              start = start + 1L,
              strand = "-",
              x_label = paste0(start, " (-)")) %>%
    mutate(x_ord = row_number() * 2)
  bind_rows(plus, minus) %>% arrange(x_ord)
}

prepare_for_plot <- function(df, positions_tbl) {
  grid <- build_axis_grid(positions_tbl)
  out <- grid %>%
    left_join(agg_pct(df), by = c("chr","start","strand")) %>%
    arrange(x_ord)
  out$x_label <- forcats::fct_inorder(out$x_label)
  out
}

make_plot <- function(df, title_text) {
  col_map <- c("+" = "red", "-" = "orange")
  ggplot(df, aes(x = x_label, y = percent_modified, fill = strand)) +
    geom_col(width = 0.8, na.rm = TRUE) +
    geom_text(aes(label = ifelse(is.na(percent_modified), "NA",
                                 sprintf("%.3f", percent_modified))),
              vjust = -0.3, size = 3, na.rm = TRUE) +
    scale_fill_manual(values = col_map, name = "Strand") +
    labs(
      title = title_text,
      x = "Position (erst +, dann - pro Stelle; Label = erste Koordinate)",
      y = "percent_modified (m)"
    ) +
    theme_minimal(base_size = 13) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          panel.grid.minor = element_blank())
}

# =======================
# Shiny App
# =======================

ui <- fluidPage(
  titlePanel("Vergleich bedMethyl (m) – 7 Positionen: start=Plus, start+1=Minus"),
  sidebarLayout(
    sidebarPanel(
      fileInput("fileA", "Datei A wählen:", accept = c(".bed", ".tsv", ".txt")),
      fileInput("fileB", "Datei B wählen:", accept = c(".bed", ".tsv", ".txt")),
      checkboxInput("show_tables", "Tabellen unter den Plots anzeigen", value = FALSE),
      tags$hr(),
      tags$p(HTML("<b>Hinweis:</b> Nur m-Methylierungen werden berücksichtigt. Farben: <span style='color:red'>+</span> rot, <span style='color:orange'>−</span> orange."))
    ),
    mainPanel(
      h4("Plot – Datei A"),
      plotOutput("plotA", height = "420px"),
      uiOutput("tblA"),
      tags$hr(),
      h4("Plot – Datei B"),
      plotOutput("plotB", height = "420px"),
      uiOutput("tblB")
    )
  )
)

server <- function(input, output, session) {
  datA <- reactive({
    req(input$fileA)
    df <- read_bedmethyl(input$fileA$datapath) |> filter_only_m()
    prepare_for_plot(df, target_positions)
  })
  datB <- reactive({
    req(input$fileB)
    df <- read_bedmethyl(input$fileB$datapath) |> filter_only_m()
    prepare_for_plot(df, target_positions)
  })
  
  output$plotA <- renderPlot({
    req(input$fileA)
    make_plot(datA(), paste0("Datei A: ", basename(input$fileA$name)))
  })
  output$plotB <- renderPlot({
    req(input$fileB)
    make_plot(datB(), paste0("Datei B: ", basename(input$fileB$name)))
  })
  
  output$tblA <- renderUI({
    req(input$show_tables, input$fileA)
    tagList(h5(paste("Werte –", basename(input$fileA$name))), tableOutput("tableA"))
  })
  output$tableA <- renderTable({
    req(input$show_tables, input$fileA)
    datA() %>%
      select(x_label, strand, start, percent_modified) %>%
      rename(`Positions-Label` = x_label,
             Strand = strand,
             Start  = start,
             percent_modified_m = percent_modified)
  }, striped = TRUE, digits = 3)
  
  output$tblB <- renderUI({
    req(input$show_tables, input$fileB)
    tagList(h5(paste("Werte –", basename(input$fileB$name))), tableOutput("tableB"))
  })
  output$tableB <- renderTable({
    req(input$show_tables, input$fileB)
    datB() %>%
      select(x_label, strand, start, percent_modified) %>%
      rename(`Positions-Label` = x_label,
             Strand = strand,
             Start  = start,
             percent_modified_m = percent_modified)
  }, striped = TRUE, digits = 3)
}

shinyApp(ui, server)