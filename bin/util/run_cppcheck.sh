#!/bin/bash

cppcheck --enable=all --quiet -j4 . 2>&1
