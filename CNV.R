require(cn.mops)

base_dir = "/lustre/scratch108/bacteria/jl11/pairs_analysis/haem_flu_pairs"
pairs_file = "haem_pairs_Rin.txt"

pairs <- read.table(file=paste(base_dir, pairs_file,sep="/"),header=T,sep="\t")

BAMfiles <- paste("/lustre/scratch108/bacteria/jl11/cnvs/H_influenzae", 
      pairs$CSF_lane,paste(pairs$CSF_lane,"mapping.bam",sep="."),sep="/")

BAMfiles <- c(BAMfiles, paste("/lustre/scratch108/bacteria/jl11/cnvs/H_influenzae", 
                                  pairs$blood_lane,paste(pairs$blood_lane,"mapping.bam",sep="."),sep="/"))

bamDataRanges <- getReadCountsFromBAM(BAMfiles, 
                    sampleNames=c(paste(pairs$Sample_ID,"csf",sep="_"),paste(pairs$Sample_ID,"blood",sep="_")),mode="paired")
cnv_result <- haplocn.mops(bamDataRanges)
int_cnv_result <- calcIntegerCopyNumbers(cnv_result)

saveRDS(cnv_result,file="cnv_result.RData")
saveRDS(int_cnv_result,file="int_cnv_result.RData")

overlaps <- matrix(ncol = nrow(pairs), nrow = length(cnvr(int_cnv_result)))
overlaps <- as.data.frame(overlaps)
colnames(overlaps) <- pairs$Sample_ID

num_mistmatched = 0
mismatches = rep(0,length(cnvr(int_cnv_result)))
for (i in seq(1,nrow(pairs))) # reverted to using a loop as data structures are complex...
{
  overlaps[,i] <- factor(mcols(cnvr(int_cnv_result))[,eval(paste("X",pairs$Sample_ID,"_csf",sep="")[i])],levels = paste("CN",seq(0,8),sep="")) == 
    factor(mcols(cnvr(int_cnv_result))[,eval(paste("X",pairs$Sample_ID,"_blood",sep="")[i])],levels = paste("CN",seq(0,8),sep=""))
  mismatched_regions <- which(!(overlaps[,i]))
  if (length(mismatched_regions) != 0)
  {
    num_mistmatched <- num_mistmatched + 1
    mismatches[mismatched_regions] <- mismatches[mismatched_regions] + 1
  }
}

write.table(overlaps, "cnv_mistmatches.txt")
