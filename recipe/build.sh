#!/bin/sh

mkdir build && cd build

cmake \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_INSTALL_RPATH="${PREFIX}/lib" -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON -DCMAKE_MACOSX_RPATH=ON \
  -DBUILD_SHARED_LIBS=ON \
  -DINSTALL_LIBS=ON \
  -DBUILD_PYBULLET=ON \
  -DBUILD_PYBULLET_NUMPY=ON \
  -DBUILD_CPU_DEMOS=ON \
  -DBUILD_UNIT_TESTS=OFF \
  -DBUILD_EXTRAS=ON \
  -DBUILD_OPENGL3_DEMOS=ON \
  -DPYTHON_EXECUTABLE=${PYTHON} \
  -DPYTHON_VERSION_PYBULLET=${PY_VER} \
  ..
make install -j${CPU_COUNT}
python -c "import pybullet" || echo "FAIL"
echo -e "run\nbt\nquit\n" > test.gdb
cat test.gdb
gdb --batch --command=test.gdb --args ${PYTHON} -c "import pybullet"

