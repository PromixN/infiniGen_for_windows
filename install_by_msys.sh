#!/bin/bash

NURBS_SCRIPT="setup_linux.py"
BLENDER_DIR='TODO::PATH_TO_BLENDER'
BLENDER_PYTHON="${BLENDER_DIR}/3.3/python/bin/python.exe"
BLENDER_INCLUDE="${BLENDER_DIR}/3.3/python/Include"
BLENDER_LIB="${BLENDER_DIR}/3.3/python/libs"
REQUIREMENTS_PATH='./requirements.txt'

# # Install Blender dependencies
"${BLENDER_PYTHON}" -m ensurepip
CFLAGS="-I$(realpath ${BLENDER_INCLUDE}) -L$(realpath ${BLENDER_LIB}) ${CFLAGS}" 
"${BLENDER_PYTHON}" -m pip install -r "${REQUIREMENTS_PATH}" -i https://pypi.tuna.tsinghua.edu.cn/simple/

# Build terrain
cd ./worldgen/terrain
# USE_CUDA=1 bash install_terrain.sh
"${BLENDER_PYTHON}" setup.py build_ext --inplace --force
cd -

# Build NURBS
cd ./worldgen/assets/creatures/geometry/cpp_utils
rm -f *.so
rm -rf build
"${BLENDER_PYTHON}" "${NURBS_SCRIPT}" build_ext --inplace
cd -

# if [ "$1" = "opengl" ]; then
#     bash ./worldgen/tools/install/compile_opengl.sh
# fi


# # Build Flip Fluids addon
# if [ "$1" = "flip_fluids" ] || [ "$2" = "flip_fluids" ]; then
#     bash ./worldgen/tools/install/compile_flip_fluids.sh
# fi