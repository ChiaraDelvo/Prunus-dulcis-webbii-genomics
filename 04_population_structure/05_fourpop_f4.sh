#!/usr/bin/env bash

INPUT=Set1_Input_Mig_F4.treemix.gz

fourpop \
    -i "${INPUT}" \
    -k 100 \
    | tee TreeMix_F4.out
