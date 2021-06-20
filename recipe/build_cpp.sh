#!/bin/sh

mkdir build && cd build

if [ ${target_platform} == "linux-ppc64le" ]; then
  # Disable parallel compilaton (build runs out of memory in Travis)
  NUM_PARALLEL=-j2
else
  NUM_PARALLEL=
fi


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
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_SKIP_RPATH=YES

ninja $NUM_PARALLEL install

if [[ $target_platform =~ linux.* ]]; then
  install -Dm755 examples/ExampleBrowser/App_ExampleBrowser $PREFIX/bin/BulletExampleBrowser
fi

mkdir -p $PREFIX/opt/bullet
cp -r data $PREFIX/opt/bullet/
