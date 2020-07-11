#!/usr/bin/env bash


git clone https://github.com/jheinen/gr
cd gr
make
make install
make clean
export PYTHONPATH=${PYTHONPATH}:/usr/local/gr/lib/python
