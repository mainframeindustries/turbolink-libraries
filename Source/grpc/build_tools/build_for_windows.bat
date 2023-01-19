cd ../../..
set TL_LIBRARIES_PATH=%CD%

mkdir %TL_LIBRARIES_PATH%\_build\win64\grpc & cd %TL_LIBRARIES_PATH%\_build\win64\grpc
cmake -G "Visual Studio 16 2019" -A x64 ^
 -DCMAKE_INSTALL_PREFIX=%TL_LIBRARIES_PATH%/output/grpc ^
 -DgRPC_INSTALL_LIBDIR="lib/win64/$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>" ^
 -DgRPC_INSTALL_CMAKEDIR=lib/win64/cmake -DgRPC_USE_CARES=OFF ^
 -DgRPC_ABSL_PROVIDER=package -Dabsl_DIR="%TL_LIBRARIES_PATH%/output/abseil/lib/win64/cmake" ^
 -DgRPC_RE2_PROVIDER=package -Dre2_DIR="%TL_LIBRARIES_PATH%/output/re2/lib/win64/cmake" ^
 -DgRPC_PROTOBUF_PROVIDER=package -DgRPC_PROTOBUF_PACKAGE_TYPE=CONFIG ^
 -DProtobuf_DIR="%TL_LIBRARIES_PATH%/output/protobuf/lib/win64/cmake" ^
 -DgRPC_ZLIB_PROVIDER=package ^
 -DZLIB_INCLUDE_DIR="%UE_THIRD_PARTY_PATH%/zlib/v1.2.8/include/Win64/VS2015" ^
 -DZLIB_LIBRARY_RELEASE="%UE_THIRD_PARTY_PATH%/zlib/v1.2.8/lib/Win64/VS2015/Release/zlibstatic.lib" ^
 -DZLIB_LIBRARY_DEBUG="%UE_THIRD_PARTY_PATH%/zlib/v1.2.8/lib/Win64/VS2015/Debug/zlibstatic.lib" ^
 -DgRPC_SSL_PROVIDER=package -DgRPC_BUILD_TESTS=OFF^
 -DOPENSSL_INCLUDE_DIR="%UE_THIRD_PARTY_PATH%/OpenSSL/1.1.1n/include/Win64/VS2015" ^
 -DLIB_EAY_LIBRARY_DEBUG="%UE_THIRD_PARTY_PATH%/OpenSSL/1.1.1n/lib/Win64/VS2015/Debug/libcrypto.lib" ^
 -DLIB_EAY_LIBRARY_RELEASE="%UE_THIRD_PARTY_PATH%/OpenSSL/1.1.1n/lib/Win64/VS2015/Release/libcrypto.lib" ^
 -DLIB_EAY_DEBUG="%UE_THIRD_PARTY_PATH%/OpenSSL/1.1.1n/lib/Win64/VS2015/Debug/libcrypto.lib" ^
 -DLIB_EAY_RELEASE="%UE_THIRD_PARTY_PATH%/OpenSSL/1.1.1n/lib/Win64/VS2015/Release/libcrypto.lib" ^
 -DSSL_EAY_DEBUG="%UE_THIRD_PARTY_PATH%/OpenSSL/1.1.1n/lib/Win64/VS2015/Debug/libssl.lib" ^
 -DSSL_EAY_LIBRARY_DEBUG="%UE_THIRD_PARTY_PATH%/OpenSSL/1.1.1n/lib/Win64/VS2015/Debug/libssl.lib" ^
 -DSSL_EAY_LIBRARY_RELEASE="%UE_THIRD_PARTY_PATH%/OpenSSL/1.1.1n/lib/Win64/VS2015/Release/libssl.lib" ^
 -DSSL_EAY_RELEASE="%UE_THIRD_PARTY_PATH%/OpenSSL/1.1.1n/lib/Win64/VS2015/Release/libssl.lib" ^
 -DSSL_EAY_DEBUG="%UE_THIRD_PARTY_PATH%/OpenSSL/1.1.1n/lib/Win64/VS2015/Debug/libssl.lib" ^
 -DCMAKE_POLICY_DEFAULT_CMP0091=NEW -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDLL ^
 %TL_LIBRARIES_PATH%/Source/grpc/grpc
cmake --build . --target INSTALL --config Debug
cmake --build . --target INSTALL --config Release