process clinvar_assignment {

    container "yinxiu/bam_coverage:latest"
    cpus 1
    errorStrategy 'retry'
    maxRetries = 3
    memory { 1.GB * task.attempt }

    publishDir "${params.outdir}/${params.date}/${patient}", mode: "copy"
    
    input:
    tuple val(patient), path(coverage)

    output:
    tuple val(patient), path("${patient}.coverage.clinvar.patho.bed"), path("${patient}.coverage.clinvar.uncertain.bed"), path("${patient}.coverage.bed")

    script:
    """
    awk '{print \$1,\$2-1,\$2, \$3}' ${patient}.coverage.tsv > ${patient}.coverage.bed
    sed -i 's/ /\\t/g' ${patient}.coverage.bed
    awk '{if(\$0~/^#/) print \$0}' ${params.clinvar_vcf} > clinvar.intersect.vcf
    bedtools intersect -b ${patient}.coverage.bed -a ${params.clinvar_vcf} | sort | uniq >> clinvar.intersect.vcf

    grep -E "CLNSIG=Pathogenic|CLNSIG=Likely_patho" clinvar.intersect.vcf | awk '{print \$1, \$2-1, \$2}' | sed 's/ /\\t/g' > clinvar.intersect.patho.vcf
    grep -E -v "CLNSIG=Benign|CLNSIG=Likely_benign|CLNSIG=Pathogenic|CLNSIG=Likely_patho" clinvar.intersect.vcf | awk '{print \$1, \$2-1, \$2}' | sed 's/ /\\t/g' > clinvar.intersect.uncertain.vcf

    bedtools intersect -a ${patient}.coverage.bed -b clinvar.intersect.patho.vcf | sort  | uniq > ${patient}.coverage.clinvar.patho.bed
    bedtools intersect -a ${patient}.coverage.bed -b clinvar.intersect.uncertain.vcf | sort | uniq > ${patient}.coverage.clinvar.uncertain.bed
    """
}
