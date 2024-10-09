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

To use the package you need to clone the repo from github:

```
git clone https://github.com/nedwalsh/fastANI-phylogenetic_pipeline.git
```

Make sure that the file has the correct permissions to run:

```
chmod +x fastANI-phylogenetic_pipeline/fastANI-lyse.sh
```

IMPORTANT!! Please add the O2D number into the SLURM scripts in the src folder!!
In the line here:
```
#SBATCH --account=OD-########
```
You can do this quickly using nano:
```
nano fastANI-phylogenetic_pipeline/src/multiple_fastANI_pipeline.q
nano fastANI-phylogenetic_pipeline/src/fastANI_pipeline.q
```

Then run it using the Genomes folder as the first positional variable:

```
fastANI-phylogenetic_pipeline/fastANI-lyse.sh Genomes/
```

In the output folder you should have two files to use for the downstream analysis:

```
| Output
---|final_fastani_dist.tsv
---|species_info.csv
```

Now you can run the analysis on your ANI distance output using the ```analyse_files.R``` located in the ```r_visualisation``` folder. You don't need to adjust the script at all, just run in RStudio or through the CLI.

The output from this will be ```treedata.csv``` which you can then visualise however you wish in Rstudio using the ```ggtree``` package.
I have included an example visualisation in the ```r_visualisation``` folder called ```Dendrogram_visualisation.R```.

After that, you should get an output that looks like this. This graph was made using a subset of genomes described by Williams el al, 2022 (doi: 10.1038/s41467-022-32929-2).

<img width="1500" alt="Rplot01" src="https://github.com/user-attachments/assets/756b17ab-aa8f-43ad-9712-56c7e9bc159f">
