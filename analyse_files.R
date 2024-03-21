library(dplyr)
library(ape)
library(tidyverse)
library(pvclust)
library(treeio)
library(ggtree)
library(tidytree)
library(ggtreeDendro)

list.files()

species_data = read.csv("species_info.csv" , header = FALSE)
fastaniout <- read.delim("MH191_10_Proximal_Clades_fastani_edited.tsv", header = FALSE) %>% select(1:5)

feature_name <- c('Species_1','Species_2','ANI','query_seqs','matched_seqs')

colnames(fastaniout) <- feature_name

species_names <- unique(c(fastaniout$Species_1, fastaniout$Species_2))
num_species <- length(species_names)
ANI_matrix <- matrix(0, nrow = num_species, ncol = num_species, dimnames = list(c(), c()))

# Populating the ANI matrix
for (i in 1:nrow(fastaniout)) {
  Species_1 <- fastaniout[i, "Species_1"]
  Species_2 <- fastaniout[i, "Species_2"]
  ani_value <- 100 - as.numeric(fastaniout[i, "ANI"])
  
  row_index <- match(Species_1, species_names)
  col_index <- match(Species_2, species_names)
  
  ANI_matrix[row_index, col_index] <- ani_value
}

# Adding species names to the matrix
rownames(ANI_matrix) <- c(species_names)
colnames(ANI_matrix) <- c(species_names)

nboot <- 1000
pv_result <- pvclust(ANI_matrix, method.hclust="complete", nboot=nboot)

gplot <- autoplot(pv_result,
                  layout = "dendrogram",
                  ladderize = TRUE,
                  label_edge = FALSE,
                  pvrect = FALSE,
                  alpha = 0.95,
                  hang = 0.1)

mytree <- as_tibble(gplot$data)

help(pvclust)

labels <- data.frame(mytree$label)
labels$nums <- as.numeric(rownames(labels))
merged_df <- merge(labels, species_data,by.x = "mytree.label", by.y = "V1")
ordered_df <- merged_df[order(merged_df$nums, decreasing = FALSE),]
below <- labels %>% 
  slice(length(ordered_df$mytree.label)+1:n())
final_labels <- bind_rows(ordered_df, below)
mytree$label <- final_labels$V2

mytree <- as_tibble(mytree)

write.table(mytree, file = "treedata.csv", sep = ",", col.names = TRUE, row.names = FALSE)
