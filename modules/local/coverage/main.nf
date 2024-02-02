process coverage {
    container "yinxiu/bam_coverage:latest"
    cpus 5
    errorStrategy 'retry'
    maxRetries = 3
    memory { 5.GB * task.attempt }

    //publishDir "${params.outdir}/${params.date}/${patient}", mode: "copy"
    
    input:
    tuple val(patient), path(bam_file), path(bai_file)


    output:
    tuple val(patient), path("${patient}.coverage.tsv"), emit: coverage

    script:
    """
    samtools depth -a -b ${params.bed} -o ${patient}.coverage.tsv ${bam_file} --threads ${task.cpus} --reference ${params.fasta}
    """
}
