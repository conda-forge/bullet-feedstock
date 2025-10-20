#!/bin/sh

set -exuo pipefail

rm -rf examples/ThirdPartyLibs/zlib

python -m pip install .
