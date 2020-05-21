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
    echo $PWD > download_fastqgz.log
    ls -la $PWD/* >> download_fastqgz.log
    ls -la /data/work/* >> download_fastqgz.log
    gsutil cp download_fastqgz.log gs://users-dev-dzd/tim/
    """
}

process fastqc {
    publishDir "$baseDir", mode: 'copy'

    container "biocontainers/fastqc:v0.11.8dfsg-2-deb_cv1"

    input:
    path fastqgz from local_fastqgzs

    output:
    file "*_fastqc.html" into fastqc_htmls
    file "*_fastqc.zip" into fastqc_zips

    """
    ls -la /data/work/
    /usr/bin/fastqc $fastqgz
    """
}

