#!/bin/bash
cd ../build/test;
# loop and run all test files which start with "test_"
for file in test_*; do
    ./$file
done