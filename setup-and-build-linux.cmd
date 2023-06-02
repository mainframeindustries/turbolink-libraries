set TL_LIBRARIES_PATH=%CD%

set UE_THIRD_PARTY_PATH={SET UE FOLDER}\Engine\Source\ThirdParty
set NINJA_EXE_PATH={SET PATH TO NINJA}\ninja.exe
set LINUX_MULTIARCH_ROOT=C:\UnrealToolchains\v20_clang-13.0.1-centos7

set OUTPUT_FOLDER=%TL_LIBRARIES_PATH%/output/linux
set BUILD_FOLDER=%TL_LIBRARIES_PATH%/_build/linux

IF EXIST "%OUTPUT_FOLDER%" (rmdir "%OUTPUT_FOLDER%" /s /q)
IF EXIST "%BUILD_FOLDER%" (rmdir "%BUILD_FOLDER%" /s /q)

git submodule update --init
git submodule foreach git clean -fdx

cd %TL_LIBRARIES_PATH%/Source/abseil/abseil
git apply --whitespace=nowarn ../patch/0001-changes-from-turbolink-libraries-for-grpc-1.41.0.patch
git apply --whitespace=nowarn ../patch/0002-remove-symbolize-to-get-accustomed-to-xbox.patch

cd %TL_LIBRARIES_PATH%/Source/re2/re2
git apply --whitespace=nowarn ../patch/0001-changes-from-turbolink-libraries-for-grpc-1.41.0.patch

cd %TL_LIBRARIES_PATH%/Source/protobuf/protobuf
git apply --whitespace=nowarn ../patch/0001-changes-from-turbolink-libraries-for-grpc-1.41.0.patch

cd %TL_LIBRARIES_PATH%/Source/grpc/grpc
git apply --whitespace=nowarn ../patch/0001-Remove-cares-and-fix-grpc-plugin-target.patch

:: abseil
mkdir %BUILD_FOLDER%\abseil & cd %BUILD_FOLDER%\abseil
cmake -G "Ninja Multi-Config" -DCMAKE_MAKE_PROGRAM=%NINJA_EXE_PATH% ^
 -DCMAKE_TOOLCHAIN_FILE="%TL_LIBRARIES_PATH%\BuildTools\linux\ue5-linux-cross-compile.cmake" ^
 -DUE_THIRD_PARTY_PATH=%UE_THIRD_PARTY_PATH% ^
 -DCMAKE_INSTALL_PREFIX=%OUTPUT_FOLDER%/abseil ^
 -DCMAKE_INSTALL_LIBDIR="lib/linux/$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>" ^
 -DCMAKE_INSTALL_CMAKEDIR=lib/linux/cmake ^
 %TL_LIBRARIES_PATH%/Source/abseil/abseil
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --target install --config Debug
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --target install --config Release
if %errorlevel% neq 0 exit /b %errorlevel%

:: re2
mkdir %BUILD_FOLDER%\re2 & cd %BUILD_FOLDER%\re2
cmake -G "Ninja Multi-Config" -DCMAKE_MAKE_PROGRAM=%NINJA_EXE_PATH% ^
 -DCMAKE_TOOLCHAIN_FILE="%TL_LIBRARIES_PATH%\BuildTools\linux\ue5-linux-cross-compile.cmake" ^
 -DUE_THIRD_PARTY_PATH=%UE_THIRD_PARTY_PATH% ^
 -DCMAKE_INSTALL_PREFIX=%OUTPUT_FOLDER%/re2 ^
 -DCMAKE_INSTALL_LIBDIR="lib/linux/$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>" ^
 -DCMAKE_INSTALL_CMAKEDIR=lib/linux/cmake ^
 -DRE2_BUILD_TESTING=OFF ^
 %TL_LIBRARIES_PATH%/Source/re2/re2
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --target install --config Debug
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --target install --config Release
if %errorlevel% neq 0 exit /b %errorlevel%

:: Protofuf
mkdir %BUILD_FOLDER%\protobuf & cd %BUILD_FOLDER%\protobuf
cmake -G "Ninja Multi-Config" -DCMAKE_MAKE_PROGRAM=%NINJA_EXE_PATH% ^
 -DCMAKE_TOOLCHAIN_FILE="%TL_LIBRARIES_PATH%\BuildTools\linux\ue5-linux-cross-compile.cmake" ^
 -DUE_THIRD_PARTY_PATH=%UE_THIRD_PARTY_PATH% -Dprotobuf_DEBUG_POSTFIX="" ^
 -DCMAKE_INSTALL_PREFIX=%OUTPUT_FOLDER%/protobuf ^
 -DCMAKE_INSTALL_LIBDIR="lib/linux/$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>" ^
 -DCMAKE_INSTALL_CMAKEDIR=lib/linux/cmake ^
 -Dprotobuf_BUILD_TESTS=false -Dprotobuf_WITH_ZLIB=false ^
 -Dprotobuf_BUILD_EXAMPLES=false ^
 -Dprotobuf_BUILD_PROTOC_BINARIES=false -Dprotobuf_BUILD_LIBPROTOC=false ^
 %TL_LIBRARIES_PATH%/Source/protobuf/protobuf/cmake
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --target install --config Debug
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --target install --config Release
if %errorlevel% neq 0 exit /b %errorlevel%

:: gRPC
mkdir %BUILD_FOLDER%\grpc & cd %BUILD_FOLDER%\grpc
cmake -G "Ninja Multi-Config" -DCMAKE_MAKE_PROGRAM=%NINJA_EXE_PATH% ^
 -DCMAKE_TOOLCHAIN_FILE="%TL_LIBRARIES_PATH%\BuildTools\linux\ue5-linux-cross-compile.cmake" ^
 -DUE_THIRD_PARTY_PATH=%UE_THIRD_PARTY_PATH% ^
 -DCMAKE_INSTALL_PREFIX=%OUTPUT_FOLDER%/grpc ^
 -DgRPC_INSTALL_LIBDIR="lib/linux/$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>" ^
 -DgRPC_INSTALL_CMAKEDIR=lib/linux/cmake ^
 -DgRPC_ABSL_PROVIDER=package -Dabsl_DIR="%OUTPUT_FOLDER%/abseil/lib/linux/cmake" ^
 -DgRPC_USE_CARES=OFF ^
 -DgRPC_RE2_PROVIDER=package -Dre2_DIR="%OUTPUT_FOLDER%/re2/lib/linux/cmake" ^
 -DgRPC_PROTOBUF_PROVIDER=package -DgRPC_PROTOBUF_PACKAGE_TYPE=CONFIG ^
 -DProtobuf_DIR="%OUTPUT_FOLDER%/protobuf/lib/linux/cmake" ^
 -DgRPC_ZLIB_PROVIDER=package ^
 -DZLIB_INCLUDE_DIR="%UE_THIRD_PARTY_PATH%/zlib/zlib-1.2.5/Inc" ^
 -DZLIB_LIBRARY_RELEASE="%UE_THIRD_PARTY_PATH%/zlib/zlib-1.2.5/Lib/Linux/x86_64-unknown-linux-gnu/libz.a" ^
 -DZLIB_LIBRARY_DEBUG="%UE_THIRD_PARTY_PATH%/zlib/zlib-1.2.5/Lib/Linux/x86_64-unknown-linux-gnu/libz.a" ^
 -DgRPC_SSL_PROVIDER=package ^
 -DOPENSSL_INCLUDE_DIR="%UE_THIRD_PARTY_PATH%/OpenSSL/1.1.1c/include/Unix/x86_64-unknown-linux-gnu" ^
 -DOPENSSL_SSL_LIBRARY="%UE_THIRD_PARTY_PATH%/OpenSSL/1.1.1c/lib/Unix/x86_64-unknown-linux-gnu/libssl.a" ^
 -DOPENSSL_CRYPTO_LIBRARY="%UE_THIRD_PARTY_PATH%/OpenSSL/1.1.1c/lib/Unix/x86_64-unknown-linux-gnu/libcrypto.a" ^
 -DgRPC_BUILD_CODEGEN=OFF -DgRPC_BUILD_CSHARP_EXT=OFF ^
 -DgRPC_BUILD_GRPC_CPP_PLUGIN=OFF -DgRPC_BUILD_GRPC_CSHARP_PLUGIN=OFF ^
 -DgRPC_BUILD_GRPC_NODE_PLUGIN=OFF -DgRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN=OFF ^
 -DgRPC_BUILD_GRPC_PHP_PLUGIN=OFF -DgRPC_BUILD_GRPC_PYTHON_PLUGIN=OFF ^
 -DgRPC_BUILD_GRPC_RUBY_PLUGIN=OFF -DgRPC_BUILD_TESTS=OFF ^
 %TL_LIBRARIES_PATH%/Source/grpc/grpc
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --target install --config Debug
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --target install --config Release
if %errorlevel% neq 0 exit /b %errorlevel%