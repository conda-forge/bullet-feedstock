#!/bin/bash

set -ex

# Delete outdated FindPythonLibs
rm -f build3/cmake/FindPythonLibs.cmake

mkdir -p build
pushd build

export PYTHON_INCLUDE_DIR=$PREFIX/include/`ls $PREFIX/include | grep "python\|pypy"`

cmake ${CMAKE_ARGS} .. \
  -GNinja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DBUILD_SHARED_LIBS=ON \
  -DINSTALL_LIBS=ON \
  -DINSTALL_EXTRA_LIBS=ON \
  -DBUILD_PYBULLET=ON \
  -DBUILD_PYBULLET_NUMPY=ON \
  -DBUILD_OPENGL3_DEMOS=ON \
  -DBUILD_UNIT_TESTS=OFF \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_SKIP_RPATH=YES \
  -DPython_EXECUTABLE=${PYTHON} \
  -DPYTHON_INCLUDE_DIRS=${PYTHON_INCLUDE_DIR} \
  -DPYTHON_INCLUDE_DIR=${PYTHON_INCLUDE_DIR}

ninja -j$CPU_COUNT install

if [[ $target_platform =~ linux.* ]]; then
  install -Dm755 examples/ExampleBrowser/App_ExampleBrowser $PREFIX/bin/BulletExampleBrowser
fi

mkdir -p $PREFIX/opt/bullet
cp -r data $PREFIX/opt/bullet/

# Build float64 variant
cd ..

mkdir build_float64 && cd build_float64

cmake ${CMAKE_ARGS} .. \
  -GNinja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DBUILD_SHARED_LIBS=ON \
  -DINSTALL_LIBS=ON \
  -DINSTALL_EXTRA_LIBS=ON \
  -DBUILD_PYBULLET=OFF \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_SKIP_RPATH=YES \
  -DUSE_DOUBLE_PRECISION:BOOL=ON \
  -DBULLET2_MULTITHREADING:BOOL=ON \
  -DBUILD_BULLET_ROBOTICS_GUI_EXTRA=OFF \
  -DBUILD_BULLET_ROBOTICS_EXTRA=OFF \
  -DBUILD_GIMPACTUTILS_EXTRA=OFF \
  -DBUILD_CPU_DEMOS=OFF \
  -DBUILD_BULLET2_DEMOS=OFF \
  -DBUILD_UNIT_TESTS=OFF \
  -DBUILD_OPENGL3_DEMOS=OFF


ninja -j$CPU_COUNT install
