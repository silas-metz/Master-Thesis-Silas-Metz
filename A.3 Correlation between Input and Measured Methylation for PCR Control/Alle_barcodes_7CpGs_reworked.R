suppressPackageStartupMessages({
  library(data.table)
  library(dplyr)
  library(stringr)
  library(tidyr)
  library(ggplot2)
  library(scales)
  library(glue)
  library(purrr)
  library(readr)
})


# INPUT
input_dir     <- "/path/to/input_dir/PCR1/CG/Hac/00_Results/filtered_all"
positions_csv <- "/path/to/clock/positions_or_clock/TestClock.csv"
file_pattern  <- "\\.csv$"
out_file_png  <- file.path(input_dir, "AlleBarcodes_7CpGs_percent_14bars_GT_mean_labels.png")
out_file_pdf  <- file.path(input_dir, "AlleBarcodes_7CpGs_percent_14bars_GT_mean_labels.pdf")

read_any <- function(f){
  dt <- tryCatch(suppressWarnings(fread(f, data.table = FALSE)), error = function(e) NULL)
  if (is.null(dt)) stop("Konnte Datei nicht lesen: ", f)
  names(dt) <- tolower(names(dt))
  dt
}

get_barcode_num <- function(path){
  m <- str_match(basename(path), "(?i)(?:barcode|bc)_?(\\d+)")
  if (!is.na(m[,2])) as.integer(m[,2]) else NA_integer_
}

extract_percent_modified <- function(df){
  cand <- c("percent_modified","mod_percent","fracmod","ratio_nmod")
  col  <- cand[cand %in% names(df)][1]
  if (is.na(col)) stop("Keine Spalte für Methylierung gefunden (z.B. percent_modified/fracmod)")
  x <- suppressWarnings(as.numeric(df[[col]]))
  if (all(is.na(x))) stop("Methylierungswerte sind NA – prüfe Datei/Spaltennamen")
  if (max(x,na.rm=TRUE) <= 1) x <- x*100
  x
}

normalize_chrom <- function(v){
  v <- as.character(v)
  v <- tolower(v)
  v <- gsub("^chr","",v)
  toupper(v)
}

expand_positions_pm1 <- function(pos){
  stopifnot(all(c("chrom","start","end","cpg_index") %in% names(pos)))
  pos0 <- pos
  pos1 <- pos %>% mutate(end = end - 1L)
  pos2 <- pos %>% mutate(start = start + 1L)
  pos3 <- pos %>% mutate(start = start + 1L, end = end - 1L)
  bind_rows(
    pos0 %>% mutate(rule="exact"),
    pos1 %>% mutate(rule="end-1"),
    pos2 %>% mutate(rule="start+1"),
    pos3 %>% mutate(rule="start+1,end-1")
  ) %>% distinct()
}

files <- list.files(input_dir, pattern=file_pattern, full.names=TRUE,
                    ignore.case=TRUE, recursive=TRUE)
if(length(files)==0) stop("Keine CSV-Dateien gefunden: ",input_dir)

bc_df <- tibble(path=files, barcode=sapply(files,get_barcode_num)) %>% arrange(barcode,path)
if(all(is.na(bc_df$barcode))) bc_df$barcode <- seq_len(nrow(bc_df))
bc_df <- bc_df %>% mutate(titration = round(seq(0,100,length.out=nrow(bc_df))))

# Positionsdatei
pos_tbl <- NULL
if(!is.na(positions_csv)){
  raw_pos <- read_any(positions_csv) %>%
    rename_with(tolower) %>%
    rename(chrom = any_of(c("chrom","chr"))) %>%
    select(chrom,start,end) %>%
    mutate(across(c(start,end),as.integer),
           chrom=normalize_chrom(chrom),
           cpg_index=row_number())
  if(nrow(raw_pos)!=7) message("Hinweis: Positionsdatei hat ",nrow(raw_pos)," Zeilen (erwartet:7)")
  pos_tbl <- expand_positions_pm1(raw_pos)
}


# Vorverarbeitung
prep_list <- lapply(seq_len(nrow(bc_df)), function(i){
  f <- bc_df$path[i]; bc <- bc_df$barcode[i]; tit <- bc_df$titration[i]
  df <- read_any(f)
  nm <- names(df)
  if(!"chrom" %in% nm && "chr" %in% nm) df <- df %>% rename(chrom=chr)
  if(!"strand" %in% names(df) && "str" %in% names(df)) df <- df %>% rename(strand=str)
  if(!"strand" %in% names(df)){ message("Übersprungen (ohne strand): ",f); return(NULL) }
  
  df <- df %>% mutate(chrom=normalize_chrom(chrom), percent=extract_percent_modified(df))
  if("modcode" %in% names(df)) df <- df %>% mutate(modcode=tolower(modcode)) %>% filter(modcode=="m")
  
  if(!is.null(pos_tbl)){
    dfj <- df %>% inner_join(pos_tbl,by=c("chrom","start","end"))
    if(nrow(dfj)==0){ message("Keine Positionstreffer: ",f); return(NULL) }
    dfj <- dfj %>% mutate(strand=ifelse(strand %in% c("+","plus","pos","POS"),"+",
                                        ifelse(strand %in% c("-","minus","neg","NEG"),"-",NA))) %>%
      filter(!is.na(strand))
    if(!"validcov" %in% names(dfj)) stop("Spalte validcov fehlt in ",f)
    df_ag <- dfj %>% mutate(validcov=as.numeric(validcov),percent=as.numeric(percent)) %>%
      group_by(cpg_index,strand) %>% slice_max(order_by=validcov,n=1,with_ties=FALSE) %>%
      ungroup() %>%
      transmute(cpg_index,strand,percent)
  } else {
    top_pos <- df %>% count(chrom,start,end,sort=TRUE) %>% slice_head(n=7) %>%
      transmute(chrom,start,end,cpg_index=row_number())
    dfj <- df %>% inner_join(top_pos,by=c("chrom","start","end")) %>%
      mutate(strand=ifelse(strand %in% c("+","plus","pos","POS"),"+",
                           ifelse(strand %in% c("-","minus","neg","NEG"),"-",NA))) %>%
      filter(!is.na(strand))
    if(!"validcov" %in% names(dfj)) stop("Spalte validcov fehlt in ",f)
    df_ag <- dfj %>% mutate(validcov=as.numeric(validcov),percent=as.numeric(percent)) %>%
      group_by(cpg_index,strand) %>% slice_max(order_by=validcov,n=1,with_ties=FALSE) %>%
      ungroup() %>%
      transmute(cpg_index,strand,percent)
  }
  
  df_full <- tidyr::complete(df_ag,cpg_index=1:7,strand=c("+","-"),fill=list(percent=0))
  df_full %>% mutate(barcode=bc,titration=tit,
                     cpg_label=factor(cpg_index,levels=1:7),
                     strand_lab=factor(strand,levels=c("+","-"))) %>%
    select(titration,barcode,cpg_label,strand_lab,percent)
})

prep_list <- compact(prep_list)
if(length(prep_list)==0) stop("Keine Daten übrig – prüfe Positionen.")
all_long <- bind_rows(prep_list) %>%
  mutate(titration_f=factor(titration,levels=sort(unique(titration))))

# Ground-Truth & Mean
gt_df <- all_long %>% distinct(titration_f) %>%
  mutate(gt=as.numeric(as.character(titration_f)),
         gt_label_y=pmin(gt+2,98),
         gt_label=paste0("GT: ",gt,"%"))

mean_df <- all_long %>%
  group_by(titration_f) %>%
  summarise(mean_percent=mean(percent,na.rm=TRUE),.groups="drop") %>%
  left_join(gt_df %>% select(titration_f,gt),by="titration_f") %>%
  mutate(mean_label_y_raw=ifelse(abs(mean_percent-gt)<5,
                                 ifelse(mean_percent<=gt,mean_percent-4,mean_percent+4),
                                 mean_percent+3),
         mean_label_y=pmin(pmax(mean_label_y_raw,2),98),
         mean_label=glue("Mean: {round(mean_percent,1)}%"))

# Plot
fac_levels <- levels(all_long$titration_f)

fac_groups <- split(fac_levels, ceiling(seq_along(fac_levels)/7))

png_files <- character(0)
pdf_files <- character(0)

for(i in seq_along(fac_groups)){
  this_levels <- fac_groups[[i]]
  
  this_all   <- all_long %>% filter(titration_f %in% this_levels)
  this_gt    <- gt_df    %>% filter(titration_f %in% this_levels)
  this_mean  <- mean_df  %>% filter(titration_f %in% this_levels)
  
  p <- ggplot(this_all,aes(x=cpg_label,y=percent,fill=strand_lab))+
    geom_col(width=0.8,position=position_dodge(width=0.78))+
    
    geom_segment(data=this_gt,inherit.aes=FALSE,
                 aes(x=-Inf,xend=Inf,y=gt,yend=gt),
                 color="red",linetype="dashed",linewidth=0.8)+
    geom_label(data=this_gt,inherit.aes=FALSE,
               aes(x=3.9,y=gt_label_y,label=gt_label),
               color="darkred",fill="white",alpha=0.85,
               size=3.6,fontface="bold",label.size=0.25,label.r=unit(0.15,"lines"))+
    
    geom_segment(data=this_mean,inherit.aes=FALSE,
                 aes(x=-Inf,xend=Inf,y=mean_percent,yend=mean_percent),
                 color="#1E88E5",linewidth=1.2)+
    geom_label(data=this_mean,inherit.aes=FALSE,
               aes(x=4.6,y=mean_label_y,label=mean_label),
               color="#0D47A1",fill="white",alpha=0.85,
               size=3.6,fontface="bold",label.size=0.25,label.r=unit(0.15,"lines"))+
    
    facet_grid(.~titration_f,switch="x",scales="fixed",space="free_x")+
    scale_x_discrete(drop=FALSE)+
    scale_y_continuous(limits=c(0,100),breaks=seq(0,100,10),expand=c(0,0))+
    scale_fill_manual(values=c("+"="#3949AB","-"="#90CAF9"),name="Strand")+
    labs(x="CpG position",
         y="Percent Modified [%]",
         title="Ground Truth (🔴 red) + Mean (🔵 blue)")+
    theme_classic(base_size=12)+
    theme(axis.text.x=element_text(angle=0,vjust=0.5,size=9),
          panel.spacing.x=unit(0.6,"lines"),
          strip.background=element_blank(),
          strip.placement="outside",
          strip.text.x=element_text(size=12,face="bold"),
          legend.position="bottom")
  
  png_i <- sub("\\.png$",
               paste0("_part",i,".png"),
               out_file_png)
  pdf_i <- sub("\\.pdf$",
               paste0("_part",i,".pdf"),
               out_file_pdf)
  
  plot_width  <- max(12,2.4*length(unique(this_all$titration_f)))
  plot_height <- 6
  
  ggsave(png_i,p,width=plot_width,height=plot_height,dpi=300,limitsize=FALSE)
  ggsave(pdf_i,p,width=plot_width,height=plot_height,device=cairo_pdf,limitsize=FALSE)
  
  png_files <- c(png_files, png_i)
  pdf_files <- c(pdf_files, pdf_i)
}

message(glue("
Fertig!
PNG-Dateien:
- {paste(png_files, collapse = '\n- ')}

PDF-Dateien:
- {paste(pdf_files, collapse = '\n- ')}

Barcodes erkannt: {length(unique(all_long$barcode))}
Facets (Titration, gesamt): {paste(levels(all_long$titration_f), collapse=', ')}
"))
