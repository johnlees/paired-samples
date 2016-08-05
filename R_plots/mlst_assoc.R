setwd("~/Documents/PhD/Pairs/")

# Run pair_results.R first
pair_mlst <- read.delim("~/Documents/PhD/Pairs/mlst_regressions/pair_mlst.txt", stringsAsFactors=FALSE)

merged <- merge(no_outliers, pair_mlst, by.x = "Sample", by.y = "Isolate")

mlst_all_lm <- lm(Total ~ ST, data=merged[merged$Species=="Streptococcus pneumoniae",])
p_vals <- p.adjust(summary(mlst_all_lm)$coefficients[,4])
p_vals[p_vals < 0.05] # Nothing

mlst_all_lm <- lm(Total ~ ST, data=merged[merged$Species=="Neisseria meningitidis",])
p_vals <- p.adjust(summary(mlst_all_lm)$coefficients[,4])
p_vals[p_vals < 0.05] # Intercept

test_gene <- function(samples, input_frame)
{
  input_frame$Total <- 0
  input_frame[input_frame$Sample %in% samples$V1,]$Total <- 1
  
  mlst_dlt_glm <- glm(Total ~ ST, data=input_frame, family = binomial())
  p_vals <- p.adjust(summary(mlst_dlt_glm)$coefficients[,4])
  
  return(p_vals[p_vals < 0.05])
}

dlt_samples <- read.table("~/Documents/PhD/Pairs/mlst_regressions/dlt_samples.txt", quote="\"", comment.char="", stringsAsFactors=FALSE)
test_gene(dlt_samples, merged[merged$Species=="Streptococcus pneumoniae",])

dhh_samples <- read.table("~/Documents/PhD/Pairs/mlst_regressions/dhh_samples.txt", quote="\"", comment.char="", stringsAsFactors=FALSE)
test_gene(dhh_samples, merged[merged$Species=="Streptococcus pneumoniae",])

# etc