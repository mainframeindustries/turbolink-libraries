set TL_LIBRARIES_PATH=%CD%

set UE_THIRD_PARTY_PATH={SET UE FOLDER}\Engine\Source\ThirdParty
set NINJA_EXE_PATH={SET PATH TO NINJA}\ninja.exe
set LINUX_MULTIARCH_ROOT=C:\UnrealToolchains\v20_clang-13.0.1-centos7

set OUTPUT_FOLDER=%TL_LIBRARIES_PATH%\output\win64
set BUILD_FOLDER=%TL_LIBRARIES_PATH%\_build\win64

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
if %errorlevel% neq 0 exit /b %errorlevel%
cmake -G "Visual Studio 17 2022" -A x64 ^
 -DCMAKE_INSTALL_PREFIX=%OUTPUT_FOLDER%/abseil ^
 -DCMAKE_INSTALL_LIBDIR="lib/win64/$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>" ^
 -DCMAKE_INSTALL_CMAKEDIR=lib/win64/cmake ^
 -DCMAKE_POLICY_DEFAULT_CMP0091=NEW -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDLL ^
 %TL_LIBRARIES_PATH%/Source/abseil/abseil
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --target INSTALL --config Debug
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --target INSTALL --config Release
if %errorlevel% neq 0 exit /b %errorlevel%

:: re2
mkdir %BUILD_FOLDER%\re2 & cd %BUILD_FOLDER%\re2
if %errorlevel% neq 0 exit /b %errorlevel%
cmake -G "Visual Studio 17 2022" -A x64 ^
 -DCMAKE_INSTALL_PREFIX=%OUTPUT_FOLDER%/re2 ^
 -DCMAKE_INSTALL_LIBDIR="lib/win64/$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>" ^
 -DCMAKE_INSTALL_CMAKEDIR=lib/win64/cmake ^
 -DCMAKE_POLICY_DEFAULT_CMP0091=NEW -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDLL ^
 -DRE2_BUILD_TESTING=OFF ^
 %TL_LIBRARIES_PATH%/Source/re2/re2
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --target INSTALL --config Debug
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --target INSTALL --config Release
if %errorlevel% neq 0 exit /b %errorlevel%

:: Protofuf
mkdir %BUILD_FOLDER%\protobuf & cd %BUILD_FOLDER%\protobuf
cmake -G "Visual Studio 17 2022" -A x64 ^
 -DCMAKE_INSTALL_PREFIX=%OUTPUT_FOLDER%/protobuf ^
 -Dprotobuf_BUILD_TESTS=false -Dprotobuf_WITH_ZLIB=false ^
 -Dprotobuf_DEBUG_POSTFIX="" ^
 -DCMAKE_INSTALL_LIBDIR="lib/win64/$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>" ^
 -DCMAKE_INSTALL_CMAKEDIR=lib/win64/cmake ^
 -Dprotobuf_MSVC_STATIC_RUNTIME=false ^
 -DCMAKE_POLICY_DEFAULT_CMP0091=NEW -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDLL ^
 %TL_LIBRARIES_PATH%/Source/protobuf/protobuf/cmake
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --target INSTALL --config Debug
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --target INSTALL --config Release
if %errorlevel% neq 0 exit /b %errorlevel%

:: gRPC
mkdir %BUILD_FOLDER%\grpc & cd %BUILD_FOLDER%\grpc
cmake -G "Visual Studio 17 2022" -A x64 ^
 -DCMAKE_INSTALL_PREFIX=%OUTPUT_FOLDER%/grpc ^
 -DgRPC_INSTALL_LIBDIR="lib/win64/$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>" ^
 -DgRPC_INSTALL_CMAKEDIR=lib/win64/cmake -DgRPC_USE_CARES=OFF ^
 -DgRPC_ABSL_PROVIDER=package -Dabsl_DIR="%OUTPUT_FOLDER%/abseil/lib/win64/cmake" ^
 -DgRPC_RE2_PROVIDER=package -Dre2_DIR="%OUTPUT_FOLDER%/re2/lib/win64/cmake" ^
 -DgRPC_PROTOBUF_PROVIDER=package -DgRPC_PROTOBUF_PACKAGE_TYPE=CONFIG ^
 -DProtobuf_DIR="%OUTPUT_FOLDER%/protobuf/lib/win64/cmake" ^
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
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --target INSTALL --config Debug
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --target INSTALL --config Release
if %errorlevel% neq 0 exit /b %errorlevel%
