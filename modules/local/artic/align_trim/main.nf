process ARTIC_ALIGN_TRIM {
    label 'process_single'
    tag "$meta.id"

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/artic:1.11.1--pyhdfd78af_0' :
        'biocontainers/artic:1.11.1--pyhdfd78af_0' }"

    input:
    tuple val(meta), path(bam), path(bai)
    path primer_bed
    val mode
    val platform

    output:
    tuple val(meta), path("${meta.id}.*trimmed.rg.sorted.bam"), path("${meta.id}.*trimmed.rg.sorted.bam.bai"), emit: bam
    tuple val(meta), path("${meta.id}.amplicon_depths.tsv"), optional:true, emit: depths
    tuple val(meta), path("${meta.id}.alignreport-${mode}.csv"), optional:true, emit: report
    path "versions.yml", emit: versions

    script:
    def args = task.ext.args ?: ''
    def outName = "${meta.id}.trimmed.rg.sorted.bam"
    def trimArg = "--no-trim-primers"
    if ( mode == "primers" ) {
        outName = "${meta.id}.primertrimmed.rg.sorted.bam"
        trimArg = ""
    }
    """
    align_trim \\
        $trimArg \\
        --report ${meta.id}.alignreport-${mode}.csv \\
        --amp-depth-report ${meta.id}.amplicon_depths.tsv \\
        $args \\
        $primer_bed \\
        < $bam \\
    | samtools sort -T ${meta.id} - -o $outName

    samtools index $outName

    # Versions #
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        align_trim: \$(echo \$(align_trim --version 2>&1) | sed 's/align_trim //')
    END_VERSIONS
    """

    stub:
    """
    touch ${meta.id}.trimmed.rg.sorted.bam
    touch ${meta.id}.trimmed.rg.sorted.bam.bai

    # Versions #
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        align_trim: \$(echo \$(align_trim --version 2>&1) | sed 's/align_trim //')
    END_VERSIONS
    """
}
