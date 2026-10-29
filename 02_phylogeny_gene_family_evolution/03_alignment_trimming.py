#!/usr/bin/env python3

"""
Custom alignment-trimming procedure.

Criteria reported in the manuscript:
1. Initial removal of alignment columns containing >90% gaps.
2. Minimum retained alignment length: 500 amino acids.
3. Maximum removal of non-gap characters: 25%.
4. If either criterion was not satisfied, the gap threshold was
   progressively increased until both conditions were met.

TODO [BIOINFORMATICIAN]:
Replace this placeholder with the exact custom script used in
the original analysis.
"""
