cd ../../..
set TL_LIBRARIES_PATH=%CD%

mkdir %TL_LIBRARIES_PATH%\_build\linux\protobuf & cd %TL_LIBRARIES_PATH%\_build\linux\protobuf
cmake -G "Ninja Multi-Config" -DCMAKE_MAKE_PROGRAM=%NINJA_EXE_PATH% ^
 -DCMAKE_TOOLCHAIN_FILE="%TL_LIBRARIES_PATH%\BuildTools\linux\ue5-linux-cross-compile.cmake" ^
 -DUE_THIRD_PARTY_PATH=%UE_THIRD_PARTY_PATH% -Dprotobuf_DEBUG_POSTFIX="" ^
 -DCMAKE_INSTALL_PREFIX=%TL_LIBRARIES_PATH%/output/protobuf ^
 -DCMAKE_INSTALL_LIBDIR="lib/linux/$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>" ^
 -DCMAKE_INSTALL_CMAKEDIR=lib/linux/cmake ^
 -Dprotobuf_BUILD_TESTS=false -Dprotobuf_WITH_ZLIB=false ^
 -Dprotobuf_BUILD_EXAMPLES=false ^
 -Dprotobuf_BUILD_PROTOC_BINARIES=false -Dprotobuf_BUILD_LIBPROTOC=false ^
 %TL_LIBRARIES_PATH%/Source/protobuf/protobuf/cmake
cmake --build . --target install --config Debug
cmake --build . --target install --config Release