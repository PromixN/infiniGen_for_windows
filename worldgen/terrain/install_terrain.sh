#!/bin/bash

# Copyright (c) Princeton University.
# This source code is licensed under the BSD 3-Clause license found in the LICENSE file in the root directory of this source tree.

# Authors: Zeyu Ma


shopt -s expand_aliases
set -e

elements=(
    "voronoi_rocks"
    "upsidedown_mountains"
    "ground"
    "warped_rocks"
    "mountains"
    "landtiles"
    "atmosphere"
    "waterbody"
)

surfaces=(
    "chunkyrock"
    "cobble_stone"
    "cracked_ground"
    "dirt"
    "ice"
    "mountain"
    "mud"
    "sand"
    "sandstone"
    "snow"
    "soil"
    "stone"
)
#nx = path_to_nvcc flags -Ipath_to_ucrt_include -Lpath_to_ucrt_include path_to_vs_hostx64(init compiler environment for cl.exe)
alias nx="/c/'Program Files'/'NVIDIA GPU Computing Toolkit'/CUDA/v12.2/bin/nvcc.exe -O3 -Xcompiler -IE:/repos/include/ucrt -LE:/repos/libs -shared --compiler-bindir  /c/'Program Files'/'Microsoft Visual Studio'/2022/Community/VC/Tools/MSVC/14.35.32215/bin/Hostx64" 

# cuda part
if [[ $USE_CUDA -eq 0 ]]; then
    echo "skipping cuda"
    rm -rf lib/cuda/utils/FastNoiseLite.dll
    for element in "${elements[@]}"; do
        rm -rf lib/cuda/elements/${element}*.dll
    done
    for surface in "${surfaces[@]}"; do
        rm -rf lib/cuda/surfaces/${surface}*.dll
    done
else
    mkdir -p lib/cuda/utils
    nx -o lib/cuda/utils/FastNoiseLite.dll source/cuda/utils/FastNoiseLite.cu
    echo "compiled lib/cuda/utils/FastNoiseLite.dll"
    mkdir -p lib/cuda/elements
    for element in "${elements[@]}"; do
        nx -o lib/cuda/elements/${element}.dll source/cuda/elements/${element}.cu
        cp lib/cuda/elements/${element}.dll lib/cuda/elements/${element}_1.dll
        echo "compiled lib/cuda/elements/${element}.dll"
    done
    mkdir -p lib/cuda/surfaces
    for surface in "${surfaces[@]}"; do
        nx -o lib/cuda/surfaces/${surface}.dll source/cuda/surfaces/${surface}.cu
        echo "compiled lib/cuda/surfaces/${surface}.dll"
    done
fi

# cpu part
OS=$(uname -s)
ARCH=$(uname -m)

# gx1 = g++ flags -Ipath to glm
alias gx1="g++ -O3 -c -fpic -fopenmp -IE:/repos/infinigen/process_mesh/dependencies/glm"
alias gx2="g++ -O3 -shared -fopenmp "

mkdir -p lib/cpu/utils
gx1 -o lib/cpu/utils/FastNoiseLite.o source/cpu/utils/FastNoiseLite.cpp
gx2 -o lib/cpu/utils/FastNoiseLite.dll lib/cpu/utils/FastNoiseLite.o
echo "compiled lib/cpu/utils/FastNoiseLite.dll"
mkdir -p lib/cpu/elements
for element in "${elements[@]}"; do
    gx1 -o lib/cpu/elements/${element}.o source/cpu/elements/${element}.cpp
    gx2 -o lib/cpu/elements/${element}.dll lib/cpu/elements/${element}.o
    cp lib/cpu/elements/${element}.dll lib/cpu/elements/${element}_1.dll
    echo "compiled lib/cpu/elements/${element}.dll"
done
mkdir -p lib/cpu/surfaces
for surface in "${surfaces[@]}"; do
    gx1 -o lib/cpu/surfaces/${surface}.o source/cpu/surfaces/${surface}.cpp
    gx2 -o lib/cpu/surfaces/${surface}.dll lib/cpu/surfaces/${surface}.o
    echo "compiled lib/cpu/surfaces/${surface}.dll"
done

mkdir -p lib/cpu/meshing
gx1 -o lib/cpu/meshing/cube_spherical_mesher.o source/cpu/meshing/cube_spherical_mesher.cpp
gx2 -o lib/cpu/meshing/cube_spherical_mesher.dll lib/cpu/meshing/cube_spherical_mesher.o
echo "compiled lib/cpu/meshing/cube_spherical_mesher.dll"
gx1 -o lib/cpu/meshing/frontview_spherical_mesher.o source/cpu/meshing/frontview_spherical_mesher.cpp
gx2 -o lib/cpu/meshing/frontview_spherical_mesher.dll lib/cpu/meshing/frontview_spherical_mesher.o
echo "compiled lib/cpu/meshing/frontview_spherical_mesher.dll"
gx1 -o lib/cpu/meshing/uniform_mesher.o source/cpu/meshing/uniform_mesher.cpp
gx2 -o lib/cpu/meshing/uniform_mesher.dll lib/cpu/meshing/uniform_mesher.o
echo "compiled lib/cpu/meshing/uniform_mesher.dll"
gx1 -o lib/cpu/meshing/utils.o source/cpu/meshing/utils.cpp
gx2 -o lib/cpu/meshing/utils.dll lib/cpu/meshing/utils.o
echo "compiled lib/cpu/meshing/utils.dll"

if [ "${OS}" = "Darwin" ]; then
    if [ "${ARCH}" = "arm64" ]; then
        alias gx1="CPATH=/opt/homebrew/include:${CPATH} g++ -O3 -c -fpic -std=c++17"
        alias gx2="CPATH=/opt/homebrew/include:${CPATH} g++ -O3 -shared -std=c++17"
    else
        alias gx1="CPATH=/usr/local/include:${CPATH} g++ -O3 -c -fpic -std=c++17"
        alias gx2="CPATH=/usr/local/include:${CPATH} g++ -O3 -shared -std=c++17"
    fi
fi
mkdir -p lib/cpu/soil_machine
gx1 -o lib/cpu/soil_machine/SoilMachine.o source/cpu/soil_machine/SoilMachine.cpp
gx2 -o lib/cpu/soil_machine/SoilMachine.dll lib/cpu/soil_machine/SoilMachine.o
echo "compiled lib/cpu/soil_machine/SoilMachine.dll"
