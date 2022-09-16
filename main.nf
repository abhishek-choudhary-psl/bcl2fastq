// Declare syntax version
nextflow.enable.dsl=2

// Script parameters
params.input_dir

process bcl2fastq {
  publishDir "${params.output_dir}", mode: 'copy', overwrite: true

  input:
    path input_dir

  output:
    file "*.fastq.gz"
    file "Reports"
    file "Stats"

    """
    bcl2fastq \
        --use-bases-mask=Y26,I8,Y98 \
        --create-fastq-for-index-reads \
        --minimum-trimmed-read-length=8 \
        --mask-short-adapter-reads=8 \
        --ignore-missing-positions \
        --ignore-missing-controls \
        --ignore-missing-filter \
        --ignore-missing-bcls \
        --runfolder-dir ${input_dir} \
        --output-dir . \
        --sample-sheet ${input_dir}/cellranger-tiny-bcl-simple-1.2.0.csv \
        --interop-dir ${input_dir}/InterOp \
        --input-dir ${input_dir}/Data/Intensities/BaseCalls \
        --stats-dir ./Stats \
        --reports-dir ./Reports \
        --no-lane-splitting
    """
}

workflow {
   def input_ch = Channel.fromPath(params.input_dir)
   bcl2fastq(input_ch)
}
