# RNAseq Pipeline

To run this pipeline you will need Snakemake (installed in a conda env) and Singularity (to run the container with all the softwares, add Singularity to the PATH)

```
export $PATH='$PATH:/path/to/singularity/bin/'
```

The pipeline has been tested with snakemake=6.6.1

The environment has been frozen and can be installed with the environment file.

```
mamba env create --file ./ieo5776_rnaseq_env.yml

or

conda env create --file./ieo5776_rnaseq_env.yml

```

Then activate the environment

```
conda activate snakemake_env
```

and RUN the pipeline by running the script execute_pipeline.sh

```
./execute_pipeline.sh
```

############################

1) Data is in `data` folder, and it's from this [paper](https://www.sciencedirect.com/science/article/pii/S1097276519308901?via%3Dihub#app2). It can be downloaded if necessary, although is already provided.

```
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR966/001/SRR9661891/SRR9661891_1.fastq.gz -o SRR9661891_GSM3934865_I53S-OHT-rep2_Mus_musculus_RNA-Seq_1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR966/001/SRR9661891/SRR9661891_2.fastq.gz -o SRR9661891_GSM3934865_I53S-OHT-rep2_Mus_musculus_RNA-Seq_2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR966/009/SRR9661889/SRR9661889_1.fastq.gz -o SRR9661889_GSM3934863_WT-OHT-rep1_Mus_musculus_RNA-Seq_1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR966/009/SRR9661889/SRR9661889_2.fastq.gz -o SRR9661889_GSM3934863_WT-OHT-rep1_Mus_musculus_RNA-Seq_2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR966/006/SRR9661886/SRR9661886_1.fastq.gz -o SRR9661886_GSM3934860_I53S-OHT-rep1_Mus_musculus_RNA-Seq_1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR966/006/SRR9661886/SRR9661886_2.fastq.gz -o SRR9661886_GSM3934860_I53S-OHT-rep1_Mus_musculus_RNA-Seq_2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR966/004/SRR9661894/SRR9661894_1.fastq.gz -o SRR9661894_GSM3934868_WT-OHT-rep2_Mus_musculus_RNA-Seq_1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR966/004/SRR9661894/SRR9661894_2.fastq.gz -o SRR9661894_GSM3934868_WT-OHT-rep2_Mus_musculus_RNA-Seq_2.fastq.gz
```  

2) Singularity image is in `singularity` folder. You can download it from [DockerHub](https://hub.docker.com/layers/andreamariani/rnaseq_snakemake/092322/images/sha256-9b6d465acd45d523b391d1e8a0e088224d5d564c651effa705129a4d1327209b?context=repo) if necessary. The tag is `092322`.

```
singularity pull ./RNAseq_snakemake/singularity/rnaseq_snakemake_220923.sif docker://andreamariani/rnaseq_snakemake:092322
```
 
3) Other resources like Index/annotation in `resources` folder  


4) Note that this repo is synched with this [github repo](https://github.com/AndreaMariani-AM/test_HPC_rnaseq), although some files (data, some resources and ...) ain't synched given the size.
