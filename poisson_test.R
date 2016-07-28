
poisson_test <- function(mutations, length, total_mutations, genome_length)
{
  length <- as.numeric(length)
  mutations <- as.numeric(mutations)
  p.value<-poisson.test(mutations,r=total_mutations*(length/genome_length), alternative = "greater")['p.value']
  return(as.numeric(p.value))
}

setwd("~/Documents/PhD/Pairs")

strep_poisson <- read.delim("~/Documents/PhD/Pairs/strep_poisson.txt", 
                            header=FALSE, stringsAsFactors=FALSE)

mutations <- sum(strep_poisson$V2)

p_values <- apply(strep_poisson,1,function(x) {poisson_test(x[[2]], x[[3]], mutations, 2221315)})
p_values <- p.adjust(p_values, method="bonferroni", n=2232)

sp <- data.frame(strep_poisson[which(p_values < 0.05),], V4=p_values[which(p_values < 0.05)])

neisseria_poisson <- read.delim("~/Documents/PhD/Pairs/neisseria_poisson.txt",
                                 header=F, stringsAsFactors = F)

mutations <- sum(neisseria_poisson$V2)

p_values <- apply(neisseria_poisson,1,function(x) {poisson_test(x[[2]], x[[3]], mutations, 2272360)})
p_values <- p.adjust(p_values, method="bonferroni", n=2034)

nm <- data.frame(neisseria_poisson[which(p_values < 0.05),], V4=p_values[which(p_values < 0.05)])

neisseria_carriage_poisson <- read.delim("~/Documents/PhD/Pairs/neisseria_carriage_poisson.txt",
                                header=F, stringsAsFactors = F)
mutations <- sum(neisseria_poisson$V2)

p_values <- apply(neisseria_carriage_poisson,1,function(x) {poisson_test(x[[2]], x[[3]], mutations, 2272360)})
p_values <- p.adjust(p_values, method="bonferroni", n=2034)

nm_car <- data.frame(neisseria_carriage_poisson[which(p_values < 0.05),], V4=p_values[which(p_values < 0.05)])
