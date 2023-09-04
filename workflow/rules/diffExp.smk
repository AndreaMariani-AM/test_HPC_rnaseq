########################################################
# This file contains rules to:
## 1) Create expression tables from the counts aggregated
##		at gene level.
## 2) Calculate Normalized counts with DEseq2
## 3) Differential expression between contrasts
## 4) Filter DE genes and perform enrichemt analyses
## 5) PCA plot
## 6) Volcano plot for each contrasts
########################################################

# Creating Expression tables
rule create_tables:
    input:
        expand("results/02salmon/{sample}/quant.genes.sf", sample = SAMPLES)
    output:
        tpm         = "results/04deseq2/tpm.tsv",
        fpkm        = "results/04deseq2/fpkm.tsv",
        raw_counts  = "results/04deseq2/Raw_counts.tsv"
    params:
        sample_names  = expand("{sample}", sample = SAMPLES),
        exclude       = config["diffexp"].get("exclude", None)
    log:
        "results/00log/deseq2/create_tables.log"
    script:
        "../scripts/createTables_count_rpkm_tpm.R"

# Perform DEseq2 normalization and retrieve normalized counts
rule deseq2:
    input:
        expand("results/02salmon/{sample}/quant.sf", sample = SAMPLES)
    output:
        rds         	= "results/04deseq2/all.rds",
        norm_counts 	= "results/04deseq2/Normalized_counts.tsv",
    params:
        sample_names  	= expand("{sample}", sample = SAMPLES),
        samples  		= config["samples"],
        exclude  		= config["diffexp"].get("exclude", None),
        tx2gene  		= config["ref"]["annotation"],
        annot_col 		= config["ref"]["annot_type"]
    log:
        "results/00log/deseq2/init.log"
    script:
        "../scripts/DESeq2.R"

# Perform DEseq2 differential expression for specified contrasts
# Switch for FPKM to TPM
rule get_contrasts:
    input:
        rds     = rules.deseq2.output.rds,
        tpm     = rules.create_tables.output.tpm
    output:
        table     = "results/04deseq2/{contrast}/{contrast}_diffexp.tsv",
        ma_plot   = "results/04deseq2/{contrast}/{contrast}_ma-plot.pdf",
        pval_hist = "results/04deseq2/{contrast}/{contrast}_pval-hist.pdf",
    params:
        contrast        = lambda w: config["diffexp"]["contrasts"][w.contrast],
        lfcShrink       = config["lfcShrink"],
        samples         = config["samples"],
        exclude         = config["diffexp"].get("exclude", None),
        annot           = config["ref"]["geneInfo"].get("file", None),
        column_used     = config["ref"]["geneInfo"]["column_used"],
        column_toAdd    = config["ref"]["geneInfo"]["column_toAdd"],
        name_annotation = config["ref"]["geneInfo"]["name_annotation"],
    log:
        "results/00log/deseq2/{contrast}.diffexp.log"
    script:
        "../scripts/get_DESeq2_contrasts.R"

# Filter DE genes based on some parameters, Pval/Log2FC/TPM
rule filter_deg:
    input:
        diffExp = rules.get_contrasts.output.table,
    output:
        "results/04deseq2/{contrast}/log2fc{log2fc}_pval{pvalue}_tpm{tpm}/{contrast}_diffexp_log2fc{log2fc}_pval{pvalue}_tpm{tpm}.tsv"
    params:
        pval      = lambda w: w.pvalue,
        log2fc    = lambda w: w.log2fc,
        tpm_filt  = lambda w: w.tpm
    log:
        "results/00log/deseq2/{contrast}.{log2fc}.{pvalue}_tpm{tpm}.filter_deg.log"
    script:
        "../scripts/filter_deg.R"

# Perform enrichement analyses
rule enrichments:
    input:
        rules.filter_deg.output
    output:
        enrichments = "results/04deseq2/{contrast}/log2fc{log2fc}_pval{pvalue}_tpm{tpm}/{contrast}_enrichments_log2fc{log2fc}_pval{pvalue}_tpm{tpm}.xlsx",
    params:
        genome       = config["ref"]["genome"],
        pvalue       = config["enrichments"]["pval"],
        qvalue       = config["enrichments"]["qval"],
        set_universe = config["enrichments"]["set_universe"],
    log:
        "results/00log/deseq2/{contrast}.log2fc{log2fc}_pval{pvalue}_tpm{tpm}.enrichments.log"
    script:
        "../scripts/enrichments.R"   

# Create volcano plots of DE genes for each contrast
rule volcano:
    input:
        rules.filter_deg.output
    output:
        volcano_pdf	 = "results/04deseq2/{contrast}/log2fc{log2fc}_pval{pvalue}_tpm{tpm}/{contrast}_volcano_log2fc{log2fc}_pval{pvalue}_tpm{tpm}.pdf",
        volcano_png	 = "results/04deseq2/{contrast}/log2fc{log2fc}_pval{pvalue}_tpm{tpm}/{contrast}_volcano_log2fc{log2fc}_pval{pvalue}_tpm{tpm}.png",
    params:
        pval     = lambda w: w.pvalue,
        log2fc   = lambda w: w.log2fc,
        contrast = lambda w: w.contrast,
    log:
        "results/00log/deseq2/{contrast}.log2fc{log2fc}_pval{pvalue}_tpm{tpm}.volcano.log"
    script:
        "../scripts/volcano.R"

# PCA plot
rule pca:
    input:
        rules.deseq2.output.rds
    output:
        "results/04deseq2/pca_elipse_names_top{ntop}.pdf",
        "results/04deseq2/pca_top{ntop}.pdf",
        "results/04deseq2/pca_names_top{ntop}.pdf"
    params:
        pca_labels = config["pca"]["labels"],
    log:
        "results/00log/pca_{ntop}.log"
    script:
        "../scripts/plot-PCA.R"
