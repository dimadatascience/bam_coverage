[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A522.10.1-23aa62.svg)](https://www.nextflow.io/)
[![Active Development](https://img.shields.io/badge/Maintenance%20Level-Actively%20Developed-brightgreen.svg)](https://gist.github.com/cheerfulstoic/d107229326a01ff0f333a1d3476e068d)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)

# Bam Coverage pipeline

## Contents
- [Contents](#contents)
- [Overview](#overview)
- [Installation](#installation)
- [Usage](#usage)
- [Input](#input)
- [Output](#output)

## Overview
Nextflow Implementation for Coverage analysis of a list of coordinates given bam files, using samtools and bedtools.

## Installation

Clone the repo

```
git clone git@github.com:dimadatascience/bam_coverage.git
```


## Usage

Update in the configuration file (nextflow.config) by setting the path to :
 - fasta file: genome fasta file
 - bed file: bed file with the coordinates to scan, coordinates: start excluded, end included.
 - clinvar file: VCF file from clinvar to get the pathogenic score


To run the pipeline

```
nextflow run path_to/main.nf -c yourconfig -profile singularity --input samplesheet.csv --outdir outdir
```

## Input

The nextflow pipeline takes as input a csv samplesheet with 3 columns



__IMPORTANT: HEADER is required__ 

| patient   | bam             | bai               |
| --------- | --------------- | ----------------- |
| patient1  | path2.bam files | path2.bai files   |
| .....     | .....           | .....             |

bam and bai must be provided with full path, __not__ relative path.



## Output

Output structure:

```
params.outdir
|-- date
|   `-- patient
|       |-- patient.coverage.bed
|       |-- patient.coverage.clinvar.patho.bed
|       |-- patient.coverage.clinvar.uncertain.bed

```

The pipeline outputs for each patient three files

1) patient.coverage.bed: 
2) patient.coverage.clinvar.patho.bed: produced with bedtools intersect using file 1 and vcf from clinvar, considering pathogenic variants;
3) patient.coverage.clinvar.uncertain.bed: produced with bedtools intersect using file 1 and vcf from clinvar, considering unknown variants;
