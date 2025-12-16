suppressPackageStartupMessages({
  library(optparse)
  library(readr)
  library(dplyr)
  library(tidyr)
  library(stringr)
  library(forcats)
  library(ggplot2)
  library(scales)
  library(shiny)
})

option_list <- list(
  make_option("--input",  type="character", help="Pfad zu *F1_positions.csv"),
  make_option("--metric", type="character", default="F1_combined",
              help="Metrik: F1_combined | F1_m | F1_c [default: %default]"),
  make_option("--sep",    type="character", default=",",
              help="Delimiter: ',' ';' oder '\\t' [default: %default]")
)
opt <- parse_args(OptionParser(option_list=option_list))
if (is.null(opt$input)) stop("--input fehlt", call. = FALSE)

read_any <- function(p, sep) {
  if (sep == "\t") readr::read_tsv(p, show_col_types = FALSE)
  else if (sep == ";") readr::read_delim(p, delim=";", show_col_types = FALSE)
  else readr::read_csv(p, show_col_types = FALSE)
}
raw <- read_any(opt$input, opt$sep)

df <- raw %>%
  mutate(
    filter_thresh   = suppressWarnings(as.numeric(filter_thresh)),
    mod_thresh      = suppressWarnings(as.numeric(mod_thresh)),
    F1_m            = suppressWarnings(as.numeric(F1_m)),
    F1_c            = suppressWarnings(as.numeric(F1_c)),
    F1_combined     = suppressWarnings(as.numeric(F1_combined)),
    start           = suppressWarnings(as.integer(start)),
    strand          = ifelse(strand %in% c("+","-"), strand, as.character(strand))
  ) %>%
  filter(!is.na(filter_thresh), !is.na(mod_thresh)) %>%
  filter(toupper(file) != "SUMMARY")

df <- df %>%
  mutate(
    anchor_start = ifelse(strand == "+", start - 1L, start)
  )

# Positionen
pos_levels <- df %>% distinct(anchor_start) %>% arrange(anchor_start) %>% pull(anchor_start)
if (length(pos_levels) == 0) stop("Keine Positionen gefunden (Spalte 'start').", call. = FALSE)
pos_labels <- paste0("pos ", seq_along(pos_levels), " (", pos_levels, ")")

df <- df %>%
  mutate(
    pos    = factor(anchor_start, levels = pos_levels, labels = pos_labels),
    strand = factor(strand, levels = c("+","-"))
  )

metric_default <- match.arg(opt$metric, choices = c("F1_combined","F1_m","F1_c"))

# Shiny 
ui <- fluidPage(
  titlePanel("F1 Positions Explorer (CpG-anker-korrekt)"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("view", "Ansicht:",
                   choices = c("Einzel-Heatmap (Pos & Strand)" = "single",
                               "Paar-Heatmap (beide Stränge für eine Pos)" = "pair",
                               "Alle Positionen (Facets)" = "facet",
                               "Beste Thresholds (Balken)" = "bar"),
                   selected = "single"),
      conditionalPanel(
        condition = "input.view == 'single'",
        selectInput("pos_single", "Position (Anker) wählen:", choices = levels(df$pos)),
        selectInput("strand_single", "Strang wählen:", choices = levels(df$strand))
      ),
      conditionalPanel(
        condition = "input.view == 'pair'",
        selectInput("pos_pair", "Position (Anker) wählen:", choices = levels(df$pos))
      ),
      radioButtons("metric", "Metrik:",
                   choices = c("F1_combined","F1_m","F1_c"),
                   selected = metric_default)
    ),
    mainPanel(
      plotOutput("plot", height = "680px"),
      h4("Beste Thresholds je Position (Anker) & Strand"),
      tableOutput("bestTable")
    )
  )
)

server <- function(input, output, session) {
  
  cur_metric <- reactive({
    match.arg(input$metric, choices = c("F1_combined","F1_m","F1_c"))
  })
  
  best_tbl_all <- reactive({
    df %>%
      group_by(pos, strand) %>%
      slice_max(order_by = .data[[cur_metric()]], n = 1, with_ties = FALSE) %>%
      ungroup() %>%
      transmute(
        barcode, chr,
        start_actual = start,          # originale Startkoordinate der Zeile
        anchor_start,                  # Anker (PLUS-Start)
        pos, strand,
        best_filter = filter_thresh,
        best_mod    = mod_thresh,
        best_metric = .data[[cur_metric()]],
        validcov, nmod, canonical, percent_modified
      ) %>%
      arrange(pos, strand)
  })
  
  output$bestTable <- renderTable(best_tbl_all())
  
  output$plot <- renderPlot({
    m <- cur_metric()
    
    if (input$view == "single") {
      df_sel <- df %>% filter(pos == input$pos_single, strand == input$strand_single)
      
      ggplot(df_sel, aes(x = mod_thresh, y = filter_thresh, fill = .data[[m]])) +
        geom_tile(color = "white") +
        scale_fill_gradient(name = m, limits = c(0,1), oob = scales::squish) +
        scale_x_continuous(breaks = sort(unique(df_sel$mod_thresh))) +
        scale_y_continuous(breaks = sort(unique(df_sel$filter_thresh))) +
        coord_fixed() +
        labs(
          title = paste0("Heatmap ", m, " @ ", input$pos_single,
                         " (Anker) / Strand ", input$strand_single),
          x = "mod_thresh", y = "filter_thresh"
        ) +
        theme_minimal(base_size = 12) +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
      
    } else if (input$view == "pair") {
      df_sel <- df %>% filter(pos == input$pos_pair)
      
      ggplot(df_sel, aes(x = mod_thresh, y = filter_thresh, fill = .data[[m]])) +
        geom_tile(color = "white") +
        scale_fill_gradient(name = m, limits = c(0,1), oob = scales::squish) +
        scale_x_continuous(breaks = sort(unique(df_sel$mod_thresh))) +
        scale_y_continuous(breaks = sort(unique(df_sel$filter_thresh))) +
        coord_fixed() +
        facet_wrap(~ strand, nrow = 1) +
        labs(
          title = paste0("Paar-Heatmaps ", m, " @ ", input$pos_pair, " (beide Stränge)"),
          x = "mod_thresh", y = "filter_thresh"
        ) +
        theme_minimal(base_size = 12) +
        theme(axis.text.x = element_text(angle = 45, hjust = 1),
              strip.text = element_text(face = "bold"))
      
    } else if (input$view == "facet") {
      ggplot(df, aes(x = mod_thresh, y = filter_thresh, fill = .data[[m]])) +
        geom_tile(color = "white", linewidth = 0.15) +
        scale_fill_gradient(name = m, limits = c(0,1), oob = scales::squish) +
        scale_x_continuous(breaks = sort(unique(df$mod_thresh))) +
        scale_y_continuous(breaks = sort(unique(df$filter_thresh))) +
        coord_fixed() +
        facet_grid(strand ~ pos, scales = "fixed") +
        labs(
          title = paste0("Heatmaps ", m, " für alle Positionen (Anker) & beide Stränge"),
          x = "mod_thresh", y = "filter_thresh"
        ) +
        theme_minimal(base_size = 10) +
        theme(
          panel.grid = element_blank(),
          axis.text.x = element_text(angle = 45, hjust = 1),
          strip.text = element_text(face = "bold")
        )
      
    } else { # "bar"
      bt <- best_tbl_all()
      ggplot(bt, aes(x = pos, y = best_metric, fill = strand)) +
        geom_col(position = position_dodge(width = 0.7), width = 0.6) +
        geom_text(aes(label = round(best_metric, 3)),
                  position = position_dodge(width = 0.7), vjust = -0.4, size = 3) +
        geom_text(aes(label = paste0("f=", best_filter, ", m=", best_mod)),
                  position = position_dodge(width = 0.7), vjust = 1.6, size = 2.7, color = "gray20") +
        scale_y_continuous(labels = percent_format(accuracy = 1), limits = c(0, 1.05)) +
        labs(
          title = paste0("Beste ", m, " je Position (Anker) & Strand"),
          x = "Position (Index & anchor_start)", y = m
        ) +
        theme_minimal(base_size = 11) +
        theme(panel.grid.major.x = element_blank(),
              legend.position = "top")
    }
  })
}

shinyApp(ui, server)
