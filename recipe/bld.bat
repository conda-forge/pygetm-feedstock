REM From https://github.com/conda-forge/netcdf-fortran-feedstock/blob/main/recipe/bld.bat
set "HOST=x86_64-w64-mingw32"
set "CC=%HOST%-gcc.exe"
set "FC=%HOST%-gfortran.exe"

(
echo [build_ext]
echo cmake_opts=-DPython3_EXECUTABLE="%PYTHON%" -G "Ninja"
echo compiler=%FC%
) > "%SRC_DIR%\python\setup.cfg"

set CFLAGS=-DMS_WIN64
set CMAKE_BUILD_PARALLEL_LEVEL=%CPU_COUNT%

python -m pip install --no-deps -v "%SRC_DIR%\python"
if errorlevel 1 exit /b 1

set BUILD_DIR=%SRC_DIR%\extern\pygsw\build
cmake -S "%SRC_DIR%\extern\pygsw" -B "%BUILD_DIR%" -DCMAKE_BUILD_TYPE=Release -DPython3_EXECUTABLE="%PYTHON%" -G "Ninja"
if errorlevel 1 exit /b 1
cmake --build "%BUILD_DIR%" --target pygsw_wheel --config Release --parallel %CPU_COUNT%
if errorlevel 1 exit /b 1
xcopy /E /I "%BUILD_DIR%\pygsw" "%SP_DIR%\pygetm\pygsw"
if errorlevel 1 exit /b 1

set BUILD_DIR=%SRC_DIR%\extern\python-otps2\build
cmake -S "%SRC_DIR%\extern\python-otps2" -B "%BUILD_DIR%" -DCMAKE_BUILD_TYPE=Release -DPython3_EXECUTABLE="%PYTHON%" -G "Ninja"
if errorlevel 1 exit /b 1
cmake --build "%BUILD_DIR%" --target otps2_wheel --config Release --parallel %CPU_COUNT%
if errorlevel 1 exit /b 1
xcopy /E /I "%BUILD_DIR%\otps2" "%SP_DIR%\pygetm\otps2"
