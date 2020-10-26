# Wrapper scripts for components of the DropletUtils package

DropletUtils is a Bioconductor package written by Aaron Lun. This package provides parameterised scripts providing direct command line access to the functions of that package, to facilitate inclusion in workflows.

## Install

The recommended method for script installation is via a Bioconda recipe called dropletutils-scripts.

With the [Bioconda channels](https://bioconda.github.io/#set-up-channels) configured the latest release version of the package can be installed via the regular conda install command:

```
conda install dropletutils-scripts
```

## Test installation

There is a test script included:

```
dropletutils-scripts-post-install-tests.sh
```

This downloads test data and executes all of the scripts described below.

## Commands

Currently available scripts are detailed below, each of which has usage instructions available via --help.

### dropletutils-read-10x-counts.R: call Read10xCounts()

To read 10x data and create a SingleCellExperiment object comprising sparse matrices:

```
dropletutils-read-10x-counts.R -s <comma-separated list of 10x directories> -c <logical, should columns be named by barcode?> -o <file to store serialized SingleCellExperiment object>
```

### dropletutils-downsample-matrix.R: call downsampleMatrix()

```
dropletutils-downsample-matrix.R -i <input SingleCellExperiment in .rds format> -p <single proportion or file with one value per line for each matrix column> -c <logical, should downsampling be done by column?> -o <file to store serialized SingleCellExperiment object>
```

### dropletutils-barcoderanks.R: call barcodeRanks()

```
dropletutils-barcoderanks.R -i <input SingleCellExperiment in .rds format> -l <maximum total count below which all barcodes are assumed to be empty droplets> -f <fit bounds> -o <file to store serialized SingleCellExperiment object> -p <file to store barcode plot in>
```

### dropletutils-empty-drops.R: call emptyDrops() and produce filtered object if desired

```
dropletutils-empty-drops.R -i <input SingleCellExperiment in .rds format> -l <maximum total count below which all barcodes are assumed to be empty droplets> \
    -n <number of iterations> -m <logical, return barcodes with totals less than -l value?> -g <minimum total count required for a barcode to be considered as a potential cell> \
    -r <retain> -f <logical, filter the output object?> -d <FDR value below which a droplet is said to contain a cell> -o <file to store serialized SingleCellExperiment object> -t <output text file>
```
