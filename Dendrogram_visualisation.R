# Install and load the pvclust package
install.packages("pvclust")
install.packages("dendextend")
if (!requireNamespace("BiocManager", quietly=TRUE))
  install.packages("BiocManager")
## BiocManager::install("BiocUpgrade") ## you may need this
BiocManager::install("treeio", force =TRUE)
BiocManager::install("ggtree")
BiocManager::install("ggtreeDendro")

library(pvclust)
library(dplyr)
library(ape)
library(treeio)
library(ggtree)
library(tidytree)
library(ggtreeDendro)

help(pvclust)

setwd("//fs1-cbr.nexus.csiro.au/{af-mosh-phylo}/work/SCRATCH3OUT/output")
getwd()

mytree <- read.delim("treedata.csv", sep=",")

my_tree <- ggtree(mytree, 
       layout="roundrect",
       aes(x,y))+
  geom_treescale()
my_tree +
  #geom_tiplab()+
  geom_tippoint()
  #geom_label(aes(x=branch, label=au))+
  #geom_hilight(node=21, extend = 0.2, fill = "yellow", colour = "red")
