suppressPackageStartupMessages({
  if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
  
  BiocManager::install("methylclockData", ask = FALSE, update = FALSE)
  library(methylclockData)
})

# Horvath

coefHorvath <- get_coefHorvath()

horvath_cpgs <- data.frame(
  cpg_id = coefHorvath$CpGmarker[coefHorvath$CpGmarker != "(Intercept)"]
)

write.csv(
  horvath_cpgs,
  file = "Horvath_CpGs.csv",
  row.names = FALSE,
  quote = FALSE
)

cat("Horvath_CpGs.csv geschrieben (", nrow(horvath_cpgs), " CpGs)\n")

# Hannum

coefHannum <- get_coefHannum()

hannum_cpgs <- data.frame(
  cpg_id = coefHannum$CpGmarker
)

write.csv(
  hannum_cpgs,
  file = "Hannum_CpGs.csv",
  row.names = FALSE,
  quote = FALSE
)

cat("Hannum_CpGs.csv geschrieben (", nrow(hannum_cpgs), " CpGs)\n")
