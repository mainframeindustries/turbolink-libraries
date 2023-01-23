# [re2](https://github.com/google/re2)
RE2 is a fast, safe, thread-friendly alternative to backtracking regular expression engines like those used in PCRE, Perl, and Python. It is a C++ library.

## Patch
```
cd %TL_LIBRARIES_PATH%/Source/re2/re2
git apply --whitespace=nowarn ../patch/*.patch
```

## Build

### 1. Windows
```
cd build_tools
./build_for_windows.bat
```
### 2. Android(armv7, arm64, x64)
```
mkdir %TL_LIBRARIES_PATH%\_build\android\re2 & cd %TL_LIBRARIES_PATH%\_build\android\re2
for /d %a in (armeabi-v7a arm64-v8a x86_64) do (
mkdir %a & pushd %a ^
 & "%ANDROID_HOME%\cmake\%NDK_CMAKE_VERSION%\bin\cmake.exe" -G "Ninja Multi-Config" ^
 -DCMAKE_TOOLCHAIN_FILE="%NDKROOT%\build\cmake\android.toolchain.cmake" ^
 -DCMAKE_MAKE_PROGRAM=%ANDROID_HOME%\cmake\%NDK_CMAKE_VERSION%\bin\ninja.exe ^
 -DANDROID_ABI=%a ^
 -DCMAKE_INSTALL_PREFIX=%TL_LIBRARIES_PATH%/output/re2 ^
 -DCMAKE_INSTALL_LIBDIR="lib/android/%a/$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>" ^
 -DCMAKE_INSTALL_CMAKEDIR=lib/android/%a/cmake -DRE2_BUILD_TESTING=OFF ^
 %TL_LIBRARIES_PATH%/Source/re2/re2 ^
 & "%ANDROID_HOME%\cmake\%NDK_CMAKE_VERSION%\bin\cmake.exe" --build . --target install --config Debug ^
 & "%ANDROID_HOME%\cmake\%NDK_CMAKE_VERSION%\bin\cmake.exe" --build . --target install --config Release ^
 & popd
)
```
### 3. Linux
```
cd build_tools
./build_for_linux.bat
```
### 4. Mac
```
mkdir -p $TL_LIBRARIES_PATH/_build/mac/re2 && cd $TL_LIBRARIES_PATH/_build/mac/re2
cmake -G "Unix Makefiles" \
 -DCMAKE_INSTALL_PREFIX=$TL_LIBRARIES_PATH/output/re2 \
 -DCMAKE_INSTALL_LIBDIR=lib/mac -DCMAKE_OSX_DEPLOYMENT_TARGET=10.14 \
 -DCMAKE_INSTALL_CMAKEDIR=lib/mac/cmake \
 -DCMAKE_CXX_STANDARD=14 -DRE2_BUILD_TESTING=OFF \
 $TL_LIBRARIES_PATH/Source/re2/re2
cmake --build . --target install --config Release
```
### 5. iOS
```
mkdir -p $TL_LIBRARIES_PATH/_build/ios/re2 && cd $TL_LIBRARIES_PATH/_build/ios/re2
cmake -G "Unix Makefiles" \
 -DCMAKE_INSTALL_PREFIX=$TL_LIBRARIES_PATH/output/re2 \
 -DCMAKE_TOOLCHAIN_FILE=$TL_LIBRARIES_PATH/BuildTools/iOS/ios.toolchain.cmake \
 -DCMAKE_INSTALL_LIBDIR=lib/ios -DPLATFORM=OS64 \
 -DCMAKE_INSTALL_CMAKEDIR=lib/ios/cmake \
 -DCMAKE_CXX_STANDARD=17 -DRE2_BUILD_TESTING=OFF \
 $TL_LIBRARIES_PATH/Source/re2/re2
cmake --build . --target install --config Release
```
