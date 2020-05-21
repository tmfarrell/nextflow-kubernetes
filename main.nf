/*
 * main.nf : demo of using Nextflow on kubernetes cluster
 */

 fastqgzs = ['gs://test-dev-dzd/sample_fastqs/GCF_001720945.enterococcus.faecium.80.2.1.fq.gz',
             'gs://test-dev-dzd/sample_fastqs/GCF_001720945.enterococcus.faecium.80.2.2.fq.gz']

process download_fastqgz {
    container "tfarrell/microhmdb"

    input:
    each fastqgz from fastqgzs

    output:
    file "*.f*q.gz" into local_fastqgzs

    """
    gsutil cp $fastqgz .
    """
}

process fastqc {
    publishDir "$baseDir", mode: 'copy'

    container "ummidock/fastqc:0.11.7-1"

    input:
    path fastqgz from local_fastqgzs

    output:
    file "*_fastqc.html" into fastqc_htmls
    file "*_fastqc.zip" into fastqc_zips

    """
    fastqc $fastqgz
    """
}

