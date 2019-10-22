#!/usr/bin/env Rscript 

# Load optparse we need to check inputs

suppressPackageStartupMessages(require(optparse))
suppressPackageStartupMessages(require(workflowscriptscommon))

# parse options 
option_list = list(
    make_option(
        c("-b", "--barcodes"),
        action = 'store',
        default = NA,
        type = 'character',
        help = 'path to the cell barcodes file in .tsv format'
  ),
    make_option(
        c("-o", "--output-file"),
        action = 'store',
        default = NA, 
        type = 'character',
        help = 'path to the tab-deilmited output file'
  )
)

opt = wsc_parse_args(option_list, mandatory = c("barcodes", "output_file"))

# read in the barcodes file 
barcodes = read.csv(opt$barcodes, header = FALSE)

# add changes to dataset for testing purposes
# randomise row order and add duplicates
barcodes = data.frame(rep(barcodes[sample(nrow(barcodes)), ],2))
barcodes$cell_type = rep("dummy_cell_type", nrow(barcodes))
colnames(barcodes) = c("barcode", "cell_type")
write.table(barcodes, file = opt$output_file, sep = "\t")