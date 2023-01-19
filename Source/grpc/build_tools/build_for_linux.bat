cd ../../..
set TL_LIBRARIES_PATH=%CD%

mkdir %TL_LIBRARIES_PATH%\_build\linux\grpc & cd %TL_LIBRARIES_PATH%\_build\linux\grpc
cmake -G "Ninja Multi-Config" -DCMAKE_MAKE_PROGRAM=%NINJA_EXE_PATH% ^
 -DCMAKE_TOOLCHAIN_FILE="%TL_LIBRARIES_PATH%\BuildTools\linux\ue5-linux-cross-compile.cmake" ^
 -DUE_THIRD_PARTY_PATH=%UE_THIRD_PARTY_PATH% ^
 -DCMAKE_INSTALL_PREFIX=%TL_LIBRARIES_PATH%/output/grpc ^
 -DgRPC_INSTALL_LIBDIR="lib/linux/$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>" ^
 -DgRPC_INSTALL_CMAKEDIR=lib/linux/cmake ^
 -DgRPC_ABSL_PROVIDER=package -Dabsl_DIR="%TL_LIBRARIES_PATH%/output/abseil/lib/linux/cmake" ^
 -DgRPC_USE_CARES=OFF ^
 -DgRPC_RE2_PROVIDER=package -Dre2_DIR="%TL_LIBRARIES_PATH%/output/re2/lib/linux/cmake" ^
 -DgRPC_PROTOBUF_PROVIDER=package -DgRPC_PROTOBUF_PACKAGE_TYPE=CONFIG ^
 -DProtobuf_DIR="%TL_LIBRARIES_PATH%/output/protobuf/lib/linux/cmake" ^
 -DgRPC_ZLIB_PROVIDER=package ^
 -DZLIB_INCLUDE_DIR="%UE_THIRD_PARTY_PATH%/zlib/zlib-1.2.5/Inc" ^
 -DZLIB_LIBRARY_RELEASE="%UE_THIRD_PARTY_PATH%/zlib/zlib-1.2.5/Lib/Linux/x86_64-unknown-linux-gnu/libz.a" ^
 -DZLIB_LIBRARY_DEBUG="%UE_THIRD_PARTY_PATH%/zlib/zlib-1.2.5/Lib/Linux/x86_64-unknown-linux-gnu/libz.a" ^
 -DgRPC_SSL_PROVIDER=package ^
 -DOPENSSL_INCLUDE_DIR="%UE_THIRD_PARTY_PATH%/OpenSSL/1.1.1n/include/Unix/x86_64-unknown-linux-gnu" ^
 -DOPENSSL_SSL_LIBRARY="%UE_THIRD_PARTY_PATH%/OpenSSL/1.1.1n/lib/Unix/x86_64-unknown-linux-gnu/libssl.a" ^
 -DOPENSSL_CRYPTO_LIBRARY="%UE_THIRD_PARTY_PATH%/OpenSSL/1.1.1n/lib/Unix/x86_64-unknown-linux-gnu/libcrypto.a" ^
 -DgRPC_BUILD_CODEGEN=OFF -DgRPC_BUILD_CSHARP_EXT=OFF ^
 -DgRPC_BUILD_GRPC_CPP_PLUGIN=OFF -DgRPC_BUILD_GRPC_CSHARP_PLUGIN=OFF ^
 -DgRPC_BUILD_GRPC_NODE_PLUGIN=OFF -DgRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN=OFF ^
 -DgRPC_BUILD_GRPC_PHP_PLUGIN=OFF -DgRPC_BUILD_GRPC_PYTHON_PLUGIN=OFF ^
 -DgRPC_BUILD_GRPC_RUBY_PLUGIN=OFF -DgRPC_BUILD_TESTS=OFF ^
 %TL_LIBRARIES_PATH%/Source/grpc/grpc
cmake --build . --target install --config Debug
cmake --build . --target install --config Release