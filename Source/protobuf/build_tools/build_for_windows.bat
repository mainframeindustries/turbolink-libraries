cd ../../..
set TL_LIBRARIES_PATH=%CD%

mkdir %TL_LIBRARIES_PATH%\_build\win64\protobuf & cd %TL_LIBRARIES_PATH%\_build\win64\protobuf
cmake -G "Visual Studio 16 2019" -A x64 ^
 -DCMAKE_INSTALL_PREFIX=%TL_LIBRARIES_PATH%/output/protobuf ^
 -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded$<$<CONFIG:Debug>:Debug>DLL" ^
 -Dprotobuf_BUILD_TESTS=false -Dprotobuf_WITH_ZLIB=false ^
 -Dprotobuf_DEBUG_POSTFIX="" ^
 -DCMAKE_INSTALL_LIBDIR="lib/win64/$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>" ^
 -DCMAKE_INSTALL_CMAKEDIR=lib/win64/cmake ^
 -Dprotobuf_MSVC_STATIC_RUNTIME=false ^
 -DCMAKE_POLICY_DEFAULT_CMP0091=NEW -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDLL ^
 %TL_LIBRARIES_PATH%/Source/protobuf/protobuf/cmake
cmake --build . --target INSTALL --config Debug
cmake --build . --target INSTALL --config Release