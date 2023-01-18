cd ../../..
set TL_LIBRARIES_PATH=%CD%
echo %NINJA_EXE_PATH%
echo %UE_THIRD_PARTY_PATH%
mkdir %TL_LIBRARIES_PATH%\_build\linux\abseil & cd %TL_LIBRARIES_PATH%\_build\linux\abseil
cmake -G "Ninja Multi-Config" -DCMAKE_MAKE_PROGRAM=%NINJA_EXE_PATH% ^
 -DCMAKE_TOOLCHAIN_FILE="%TL_LIBRARIES_PATH%\BuildTools\linux\ue5-linux-cross-compile.cmake" ^
 -DUE_THIRD_PARTY_PATH=%UE_THIRD_PARTY_PATH% ^
 -DCMAKE_INSTALL_PREFIX=%TL_LIBRARIES_PATH%/output/abseil ^
 -DCMAKE_INSTALL_LIBDIR="lib/linux/$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>" ^
 -DCMAKE_INSTALL_CMAKEDIR=lib/linux/cmake ^
 %TL_LIBRARIES_PATH%/Source/abseil/abseil
cmake --build . --target install --config Debug
cmake --build . --target install --config Release