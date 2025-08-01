#!/bin/bash

# Step 1: Define the base directories for the samples and subset popmap
samples_path="/home/eks0112/dummy_files/all_demultiplexed_LC.output"
popmap_path="/home/eks0112/dummy_files/all_demultiplexed_LC.output/subset_popmap_15.txt"

# Step 2: Loop through the values for -M and -n
for i in {1..8}; do
  # Create a directory for each iteration
  mkdir params-test_m3M${i}n${i}
  
  # Run the denovo_map.pl command with varying -M and -n values
  /usr/local/genome/stacks/bin/denovo_map.pl -m 3 -M ${i} -n ${i} -T 4 \
    -o ./params-test_m5M${i}n${i} \
    --popmap $popmap_path \
    --samples $samples_path \
    -X "populations: -R .80"
done
