# RNAseq Pipeline

To run this pipeline you will need Snakemake (installed in a conda env) and Singularity (to run the container with all the softwares, add Singularity to the PATH)

```
export $PATH='$PATH:/hpcnfs/software/singularity/3.11.4/bin/'
```

The pipeline has been tested with snakemake=6.6.1

The environment has been freezed and can be installed with the environment file.

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

Data in in `data` folder
Singularity image is in `singularity` folder
Other resources like Index/annotation in `resources` folder


Note that this repo is synched with this [github repo](https://github.com/AndreaMariani-AM/test_HPC_rnaseq), although not some files (data, some resources and ...) ain't synched given the size.
