require(ggplot2)

carriage <- read.delim("~/Documents/PhD/Pairs/carriage.Rin", stringsAsFactors = F)
sp <- data.frame(Sample=seq(1,6), Total=c(1,rep(0,5)), Species=rep("Streptococcus pneumoniae",6))
colnames(carriage) <- colnames(sp)
all_carriage <- rbind(sp, carriage)
all_carriage$Species <- factor(all_carriage$Species, levels = c("Neisseria meningitidis","Streptococcus pneumoniae"))

# A >10 category
all_carriage[which(all_carriage$Total>10),2] <- 11

pdf(file="~/Documents/PhD/Pairs/plots/carriage_results.pdf", width=10, height=5)

ggplot(all_carriage, aes(x=Total)) +
  geom_histogram(binwidth=1,colour="black",fill="#FF9999") + theme_bw(base_size = 14) +
  theme(strip.text = element_text(face = "italic")) + 
  xlab("Number of variants between samples") + ylab("Count") + 
  scale_x_discrete(limits=seq(0,10,1),breaks=seq(0,10,1)) + facet_wrap(~Species,scales="free")

dev.off()

samples <- c("921940", "951529", "910039", "901168", "911634", "951018", "892385", "882011")
recomb <- data.frame(Sample = samples, Events=c(2,5,5,1,4,1,1,1), Type="Recombination")
snp <- data.frame(Sample = samples, Events=c(1,0,0,10,0,4,4,5), Type="SNPs/INDELs")
outliers <- rbind(recomb, snp)

pdf(file="~/Documents/PhD/Pairs/plots/recombination_events.pdf", width=8, height=6)

ggplot(outliers, aes(x=Sample, y=Events, fill=as.factor(Type))) +
  geom_bar(stat="identity", colour="black", position="dodge") + 
  theme_bw(base_size = 14) + theme(legend.position="bottom") +
  scale_y_discrete(limits=seq(0,10,1),breaks=seq(0,10,2)) +
  scale_fill_manual(values=c("#999999", "#E69F00"), 
                    name="Event type")

dev.off()

