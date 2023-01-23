# [grpc](https://grpc.io/)
gRPC is a modern open source high performance Remote Procedure Call (RPC) framework that can run in any environment. It can efficiently connect services in and across data centers with pluggable support for load balancing, tracing, health checking and authentication. It is also applicable in last mile of distributed computing to connect devices, mobile applications and browsers to backend services.

## Version
1.50

## Submodule
https://github.com/grpc/grpc/tree/v1.50.0

## Patch
```
cd %TL_LIBRARIES_PATH%/Source/grpc/grpc
git apply --whitespace=nowarn ../patch/*.patch
```

## Build

### 1. Windows/Xbox
```
cd build_tools
./build_for_windows.bat
```
### 2. Android(armv7, arm64, x64)
```
mkdir %TL_LIBRARIES_PATH%\_build\android\grpc & cd %TL_LIBRARIES_PATH%\_build\android\grpc
for /d %i in (armeabi-v7a.ARMv7 arm64-v8a.ARM64 x86_64.x64) do (
for /f "tokens=1,2 delims=." %a in ("%i") do (
mkdir %a & pushd %a ^
 & "%ANDROID_HOME%\cmake\%NDK_CMAKE_VERSION%\bin\cmake.exe" -G "Ninja Multi-Config" ^
 -DCMAKE_TOOLCHAIN_FILE="%NDKROOT%\build\cmake\android.toolchain.cmake" ^
 -DCMAKE_MAKE_PROGRAM=%ANDROID_HOME%\cmake\%NDK_CMAKE_VERSION%\bin\ninja.exe ^
 -DANDROID_ABI=%a ^
 -DCMAKE_INSTALL_PREFIX=%TL_LIBRARIES_PATH%/output/grpc ^
 -DgRPC_INSTALL_LIBDIR="lib/android/%a/$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>" ^
 -DgRPC_INSTALL_CMAKEDIR=lib/android/%a/cmake ^
 -DgRPC_ABSL_PROVIDER=package -Dabsl_DIR="%TL_LIBRARIES_PATH%/output/abseil/lib/android/%a/cmake" ^
 -DgRPC_RE2_PROVIDER=package -Dre2_DIR="%TL_LIBRARIES_PATH%/output/re2/lib/android/%a/cmake" ^
 -DgRPC_PROTOBUF_PROVIDER=package -DgRPC_PROTOBUF_PACKAGE_TYPE=CONFIG ^
 -DProtobuf_DIR="%TL_LIBRARIES_PATH%/output/protobuf/lib/android/%a/cmake" ^
 -DgRPC_USE_CARES=OFF -DgRPC_ZLIB_PROVIDER=package ^
 -DZLIB_INCLUDE_DIR="%UE_THIRD_PARTY_PATH%/zlib/zlib-1.2.5/Inc" ^
 -DgRPC_SSL_PROVIDER=package ^
 -DOPENSSL_INCLUDE_DIR="%UE_THIRD_PARTY_PATH%/OpenSSL/1.1.1k/include/Android" ^
 -DOPENSSL_SSL_LIBRARY="%UE_THIRD_PARTY_PATH%/OpenSSL/1.1.1k/lib/Android/%b/libssl.a" ^
 -DOPENSSL_CRYPTO_LIBRARY="%UE_THIRD_PARTY_PATH%/OpenSSL/1.1.1k/lib/Android/%b/libcrypto.a" ^
 -DgRPC_BUILD_CODEGEN=OFF -DgRPC_BUILD_CSHARP_EXT=OFF ^
 %TL_LIBRARIES_PATH%/Source/grpc/grpc ^
 & "%ANDROID_HOME%\cmake\%NDK_CMAKE_VERSION%\bin\cmake.exe" --build . --target install --config Debug ^
 & "%ANDROID_HOME%\cmake\%NDK_CMAKE_VERSION%\bin\cmake.exe" --build . --target install --config Release ^
 & popd
))
```
### 3. Linux
```
cd build_tools
./build_for_linux.bat
```
### 4. Mac
```
mkdir -p $TL_LIBRARIES_PATH/_build/mac/grpc && cd $TL_LIBRARIES_PATH/_build/mac/grpc
cmake -G "Unix Makefiles" \
 -DCMAKE_INSTALL_PREFIX=$TL_LIBRARIES_PATH/output/grpc \
 -DgRPC_INSTALL_LIBDIR=lib/mac -DgRPC_INSTALL_CMAKEDIR=lib/mac/cmake \
 -DCMAKE_OSX_DEPLOYMENT_TARGET=10.14 -DCMAKE_CXX_STANDARD=14 \
 -DgRPC_ABSL_PROVIDER=package -Dabsl_DIR="$TL_LIBRARIES_PATH/output/abseil/lib/mac/cmake" \
 -DgRPC_RE2_PROVIDER=package -Dre2_DIR="$TL_LIBRARIES_PATH/output/re2/lib/mac/cmake" \
 -DgRPC_PROTOBUF_PROVIDER=package -DgRPC_PROTOBUF_PACKAGE_TYPE=CONFIG \
 -DProtobuf_DIR="$TL_LIBRARIES_PATH/output/protobuf/lib/mac/cmake" \
 -DgRPC_USE_CARES=OFF -DgRPC_ZLIB_PROVIDER=package \
 -DZLIB_INCLUDE_DIR="$UE_THIRD_PARTY_PATH/zlib/v1.2.8/include" \
 -DZLIB_LIBRARY_RELEASE="$UE_THIRD_PARTY_PATH/zlib/v1.2.8/lib/Mac/libz.a" \
 -DZLIB_LIBRARY_DEBUG="$UE_THIRD_PARTY_PATH/zlib/v1.2.8/lib/Mac/libz.a" \
 -DgRPC_SSL_PROVIDER=package \
 -DOPENSSL_INCLUDE_DIR="$UE_THIRD_PARTY_PATH/OpenSSL/1.1.1k/include/Mac" \
 -DOPENSSL_SSL_LIBRARY="$UE_THIRD_PARTY_PATH/OpenSSL/1.1.1k/lib/Mac/libssl.a" \
 -DOPENSSL_CRYPTO_LIBRARY="$UE_THIRD_PARTY_PATH/OpenSSL/1.1.1k/lib/Mac/libcrypto.a" \
 -DgRPC_BUILD_CODEGEN=OFF -DgRPC_BUILD_CSHARP_EXT=OFF \
 -DgRPC_BUILD_GRPC_CPP_PLUGIN=OFF -DgRPC_BUILD_GRPC_CSHARP_PLUGIN=OFF \
 -DgRPC_BUILD_GRPC_NODE_PLUGIN=OFF -DgRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN=OFF \
 -DgRPC_BUILD_GRPC_PHP_PLUGIN=OFF -DgRPC_BUILD_GRPC_PYTHON_PLUGIN=OFF \
 -DgRPC_BUILD_GRPC_RUBY_PLUGIN=OFF \
 $TL_LIBRARIES_PATH/Source/grpc/grpc
cmake --build . --target install --config Release
```
### 5. iOS
```
mkdir -p $TL_LIBRARIES_PATH/_build/ios/grpc && cd $TL_LIBRARIES_PATH/_build/ios/grpc
cmake -G "Unix Makefiles" \
 -DCMAKE_INSTALL_PREFIX=$TL_LIBRARIES_PATH/output/grpc \
 -DCMAKE_TOOLCHAIN_FILE=$TL_LIBRARIES_PATH/BuildTools/iOS/ios.toolchain.cmake \
 -DPLATFORM=OS64  -DCMAKE_CXX_STANDARD=17 \
 -DgRPC_INSTALL_LIBDIR=lib/ios -DgRPC_INSTALL_CMAKEDIR=lib/ios/cmake \
 -DgRPC_ABSL_PROVIDER=package -Dabsl_DIR="$TL_LIBRARIES_PATH/output/abseil/lib/ios/cmake" \
 -DgRPC_USE_CARES=OFF \
 -DgRPC_RE2_PROVIDER=package -Dre2_DIR="$TL_LIBRARIES_PATH/output/re2/lib/ios/cmake" \
 -DgRPC_PROTOBUF_PROVIDER=package -DgRPC_PROTOBUF_PACKAGE_TYPE=CONFIG \
 -DProtobuf_DIR="$TL_LIBRARIES_PATH/output/protobuf/lib/ios/cmake" \
 -DgRPC_ZLIB_PROVIDER=package \
 -DZLIB_INCLUDE_DIR="$UE_THIRD_PARTY_PATH/zlib/zlib-1.2.5/Inc" \
 -DZLIB_LIBRARY_RELEASE="$UE_THIRD_PARTY_PATH/zlib/zlib-1.2.5/lib/IOS/Device/libzlib.a" \
 -DZLIB_LIBRARY_DEBUG="$UE_THIRD_PARTY_PATH/zlib/zlib-1.2.5/lib/IOS/libzlib.a" \
 -DgRPC_SSL_PROVIDER=package \
 -DOPENSSL_INCLUDE_DIR="$UE_THIRD_PARTY_PATH/OpenSSL/1.1.1k/include/IOS" \
 -DOPENSSL_SSL_LIBRARY="$UE_THIRD_PARTY_PATH/OpenSSL/1.1.1k/lib/IOS/libssl.a" \
 -DOPENSSL_CRYPTO_LIBRARY="$UE_THIRD_PARTY_PATH/OpenSSL/1.1.1k/lib/IOS/libcrypto.a" \
 -DgRPC_BUILD_CODEGEN=OFF -DgRPC_BUILD_CSHARP_EXT=OFF \
 -DgRPC_BUILD_GRPC_CPP_PLUGIN=OFF -DgRPC_BUILD_GRPC_CSHARP_PLUGIN=OFF \
 -DgRPC_BUILD_GRPC_NODE_PLUGIN=OFF -DgRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN=OFF \
 -DgRPC_BUILD_GRPC_PHP_PLUGIN=OFF -DgRPC_BUILD_GRPC_PYTHON_PLUGIN=OFF \
 -DgRPC_BUILD_GRPC_RUBY_PLUGIN=OFF \
 $TL_LIBRARIES_PATH/Source/grpc/grpc
cmake --build . --target install --config Release
```