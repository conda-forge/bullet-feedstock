#!/bin/sh

rm -rf examples/ThirdPartyLibs/zlib
rm -rf examples/ThirdPartyLibs/minizip/

python -m pip install .
