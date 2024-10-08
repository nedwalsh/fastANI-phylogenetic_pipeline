library(pvclust)
library(dplyr)
library(ape)
library(treeio)
library(ggtree)
library(tidytree)
library(ggtreeDendro)

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
