# fastANI-phylogenetic_pipeline
This program takes a folder of genomes then carries out a whole genome phylogeny based on ANI

The method relies onthe folling packages:
fastANI
https://github.com/ParBLiSS/FastANI

pvclust
https://academic.oup.com/bioinformatics/article/22/12/1540/207339

treeio, ggtree and ggtreeDendro
https://yulab-smu.top/treedata-book/


I have made this pipeline to make a phylogeny from whole genomes. The pipeline relies on fastANI to make pairwise genome comparisons.

Before we begin the analysis, we need to consider the working directory topology and how each of the files should be accessed and created.
When you are creating a new project which will be an alignment against certain genomes, you need to create a directory as such:

```
|Main_Dir
---->|Genomes
    ---->|Genome1.fna
    ---->|Genome2.fna
    ---->|Genome3.fna
    ---->|....
```

The first bit is complicated because of the computability issue. you want to run the analysis with over 100 >genomes, its best to split these analysis into separate files.
