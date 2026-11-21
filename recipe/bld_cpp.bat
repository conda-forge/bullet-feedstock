setlocal enableextensions

mkdir build
cd build
if %errorlevel% neq 0 exit /b %errorlevel%

rem Bullet does not export its symbols on Windows, so only static libraries can be built
rem (BUILD_PYBULLET=ON used to silently force BUILD_SHARED_LIBS=OFF on Windows)
cmake .. ^
  -GNinja ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
  -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
  -DBUILD_SHARED_LIBS=OFF ^
  -DINSTALL_LIBS=ON ^
  -DINSTALL_EXTRA_LIBS=ON ^
  -DUSE_MSVC_RUNTIME_LIBRARY_DLL=ON ^
  -DBUILD_PYBULLET=OFF ^
  -DBUILD_OPENGL3_DEMOS=ON ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_SKIP_RPATH=YES

if %errorlevel% neq 0 exit /b %errorlevel%

ninja install

if %errorlevel% neq 0 exit /b %errorlevel%

rem copy examples\ExampleBrowser\App_ExampleBrowser %PREFIX%\Library\bin\BulletExampleBrowser
rem if errorlevel 1 exit 1

rem mkdir %LIBRARY_PREFIX%\opt\bullet
rem if errorlevel 1 exit 1
rem xcopy /s data %LIBRARY_PREFIX%\opt\bullet
rem if errorlevel 1 exit 1

rem Build float64 variant

cd ..

mkdir build_float64
cd build_float64
if %errorlevel% neq 0 exit /b %errorlevel%

cmake .. ^
  -GNinja ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
  -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
  -DBUILD_SHARED_LIBS=OFF ^
  -DINSTALL_LIBS=ON ^
  -DINSTALL_EXTRA_LIBS=ON ^
  -DUSE_MSVC_RUNTIME_LIBRARY_DLL=ON ^
  -DBUILD_PYBULLET=OFF ^
  -DBUILD_OPENGL3_DEMOS=OFF ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_SKIP_RPATH=YES ^
  -DUSE_DOUBLE_PRECISION:BOOL=ON ^
  -DUSE_MSVC_DISABLE_RTTI:BOOL=OFF ^
  -DBULLET2_MULTITHREADING:BOOL=ON ^
  -DBUILD_BULLET_ROBOTICS_GUI_EXTRA=OFF ^
  -DBUILD_BULLET_ROBOTICS_EXTRA=OFF ^
  -DBUILD_GIMPACTUTILS_EXTRA=OFF ^
  -DBUILD_CPU_DEMOS=OFF ^
  -DBUILD_BULLET2_DEMOS=OFF ^
  -DBUILD_UNIT_TESTS=OFF

if %errorlevel% neq 0 exit /b %errorlevel%

ninja install

if %errorlevel% neq 0 exit /b %errorlevel%
