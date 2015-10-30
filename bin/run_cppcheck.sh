#!/bin/bash

cppcheck --enable=all --quiet *.cpp *.cc *.h 2>&1 | \
grep -v -e 'The function.*is never used' \
        -e 'Cppcheck cannot find all the include files'
