#!/usr/bin/env bats

# Extract the test data

@test "Extract .mtx matrix from archive" {
    if [ "$use_existing_outputs" = 'true' ] && [ -f "$raw_matrix" ]; then
        skip "$raw_matrix exists and use_existing_outputs is set to 'true'"
    fi
   
    run rm -rf $raw_matrix && tar -xvzf $test_data_archive --strip-components 2 -C $data_dir
    echo "status = ${status}"
    echo "output = ${output}"
 
    [ "$status" -eq 0 ]
    [ -f  "$raw_matrix" ]
}

# create an sdrf file to incorporate into SCE object 
@test "fetch a dummy sdrf for testing" {
    if [ "$use_existing_outputs" = 'true' ] && [ -f "$test_sdrf" ]; then
        skip "$test_sdrf exists and use_existing_outputs is set to 'true'"
    fi

    run rm -rf $test_sdrf && dropletutils-make-test-sdrf.R -b $barcodes -o $test_sdrf
    echo "status = ${status}"
    echo "output = ${output}"
 
    [ "$status" -eq 0 ]
    [ -f  "$test_sdrf" ]
}


# Create the Matrix object

@test "SingleCellExperiment object creation from 10x" {
    if [ "$use_existing_outputs" = 'true' ] && [ -f "$raw_sce_object" ]; then
        skip "$raw_sce_object exists and use_existing_outputs is set to 'true'"
    fi
    
    run rm -f $raw_sce_object && dropletutils-read-10x-counts.R\
                                                -s $samples\
                                                -c $col_names\
                                                -o $raw_sce_object\
                                                -m $test_sdrf\
                                                --cell-id-column $cell_id_column

    echo "status = ${status}"
    echo "output = ${output}"
    
    [ "$status" -eq 0 ]
    [ -f  "$raw_sce_object" ]
}

# Downsample the Matrix object

@test "Downsample counts in a SingleCellExperiment" {
    if [ "$use_existing_outputs" = 'true' ] && [ -f "$down_sce_object" ]; then
        skip "$down_sce_object exists and use_existing_outputs is set to 'true'"
    fi
    
    run rm -f $down_sce_object && dropletutils-downsample-matrix.R -i $raw_sce_object -p $down_prop -c $down_bycol -o $down_sce_object
    echo "status = ${status}"
    echo "output = ${output}"
    
    [ "$status" -eq 0 ]
    [ -f  "$down_sce_object" ]
}

# Check out the barcode ranks

@test "QC: look at barcode ranks" {
    if [ "$use_existing_outputs" = 'true' ] && [ -f "$branks_sce_object" ]; then
        skip "$branks_sce_object exists and use_existing_outputs is set to 'true'"
    fi
    
    run rm -f $branks_sce_object && dropletutils-barcoderanks.R -i $raw_sce_object -l $branks_lower -o $branks_sce_object -p $branks_png
    echo "status = ${status}"
    echo "output = ${output}"
    
    [ "$status" -eq 0 ]
    [ -f  "$down_sce_object" ]
}

# Check out the barcode ranks

@test "Filter empty droplets" {
    if [ "$use_existing_outputs" = 'true' ] && [ -f "$empty_filtered_sce_object" ]; then
        skip "$branks_sce_object exists and use_existing_outputs is set to 'true'"
    fi
    
    run rm -f $empty_filtered_sce_object && dropletutils-empty-drops.R -i $raw_sce_object -l $empty_lower -n $empty_niters -m $empty_test_ambient -g $empty_ignore -r $empty_retain -f $empty_filter_object -d $empty_filter_fdr -o $empty_filtered_sce_object -t $empty_filtered_text
    echo "status = ${status}"
    echo "output = ${output}"
    
    [ "$status" -eq 0 ]
    [ -f  "$down_sce_object" ]
}
