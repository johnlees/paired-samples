results <- read.delim("~/Documents/PhD/Pairs/all_results.Rin")

no_outliers <- as.data.frame(subset(x=results,subset=Total<=10))

ggplot(no_outliers, aes(x=Total)) +
  geom_histogram(binwidth=1,colour="black",fill="#FF9999") + theme_bw(base_size = 14) +
  xlab("Number of variants between samples") + ylab("Count") + 
  scale_x_discrete(limits=seq(0,10,1),breaks=seq(0,10,1)) + facet_wrap(~Species,scales="free")

map_to_23F <- read.delim("~/Documents/PhD/Pairs/map_to_23F.plot", header=FALSE, stringsAsFactors=FALSE)

ggplot(map_to_23F, aes(x=V3)) + 
  geom_dotplot(binwidth = 1000, dotsize = 30, stackdir = "centerwhole", fill="blue") + 
  scale_y_continuous(NULL, breaks = NULL) + theme_bw(base_size = 14) + 
  xlab("Genome coordinate")

map_to_MC58 <- read.delim("~/Documents/PhD/Pairs/map_to_MC58.plot", header=FALSE, stringsAsFactors=FALSE)

ggplot(map_to_MC58, aes(x=V3)) + 
  geom_dotplot(binwidth = 1000, dotsize = 30, stackdir = "centerwhole", fill="blue") + 
  scale_y_continuous(NULL, breaks = NULL) + theme_bw(base_size = 14) + 
  xlab("Genome coordinate")
