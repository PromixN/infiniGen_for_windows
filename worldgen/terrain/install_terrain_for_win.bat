
@REM nx = path_to_nvcc flags -Ipath_to_ucrt_include -Lpath_to_ucrt_include
set nx=c:/"Program Files"/"NVIDIA GPU Computing Toolkit"/CUDA/v12.2/bin/nvcc.exe -O3 -Xcompiler -IE:/repos/include/ucrt -LE:/repos/libs -shared 


%nx% -o lib/cuda/utils/FastNoiseLite.dll source/cuda/utils/FastNoiseLite.cu
for %%e in (voronoi_rocks,upsidedown_mountains,ground,warped_rocks,mountains,landtiles,atmosphere,waterbody) do %nx% -o lib/cuda/elements/%%e.dll source/cuda/elements/%%e.cu
echo "compiled lib/cuda/elements/*.dll"
for %%s in (chunkyrock,cobble_stone,cracked_ground,dirt,ice,mountain,mud,sand,sandstone,snow,soil,stone) do %nx% -o lib/cuda/surfaces/%%s.dll source/cuda/surfaces/%%s.cu
echo "compiled lib/cuda/surfaces/*.dll"

@REM gx1 = g++ flags -Ipath to glm
set gx1=g++ -O3 -c -fpic -fopenmp -IE:/repos/infinigen/process_mesh/dependencies/glm
set gx2=g++ -O3 -shared -fopenmp 
%gx1% -o lib/cpu/utils/FastNoiseLite.o source/cpu/utils/FastNoiseLite.cpp
%gx2% -o lib/cpu/utils/FastNoiseLite.dll lib/cpu/utils/FastNoiseLite.o
echo "compiled lib/cpu/utils/FastNoiseLite.dll"

for %%e in (voronoi_rocks,upsidedown_mountains,ground,warped_rocks,mountains,landtiles,atmosphere,waterbody) do %gx1% -o lib/cpu/elements/%%e.o source/cpu/elements/%%e.cpp
for %%e in (voronoi_rocks,upsidedown_mountains,ground,warped_rocks,mountains,landtiles,atmosphere,waterbody) do %gx2% -o lib/cpu/elements/%%e.dll lib/cpu/elements/%%e.o
echo "compiled lib/cpu/elements/*.dll"


for %%s in (chunkyrock,cobble_stone,cracked_ground,dirt,ice,mountain,mud,sand,sandstone,snow,soil,stone) do %gx1% -o lib/cpu/surfaces/%%s.o source/cpu/surfaces/%%s.cpp
for %%s in (chunkyrock,cobble_stone,cracked_ground,dirt,ice,mountain,mud,sand,sandstone,snow,soil,stone) do %gx2% -o lib/cpu/surfaces/%%s.dll lib/cpu/surfaces/%%s.o
echo "compiled lib/cpu/surfaces/*.dll"

%gx1% -o lib/cpu/meshing/cube_spherical_mesher.o source/cpu/meshing/cube_spherical_mesher.cpp
%gx2% -o lib/cpu/meshing/cube_spherical_mesher.dll lib/cpu/meshing/cube_spherical_mesher.o
echo "compiled lib/cpu/meshing/cube_spherical_mesher.dll"
%gx1% -o lib/cpu/meshing/frontview_spherical_mesher.o source/cpu/meshing/frontview_spherical_mesher.cpp
%gx2% -o lib/cpu/meshing/frontview_spherical_mesher.dll lib/cpu/meshing/frontview_spherical_mesher.o
echo "compiled lib/cpu/meshing/frontview_spherical_mesher.dll"
%gx1% -o lib/cpu/meshing/uniform_mesher.o source/cpu/meshing/uniform_mesher.cpp
%gx2% -o lib/cpu/meshing/uniform_mesher.dll lib/cpu/meshing/uniform_mesher.o
echo "compiled lib/cpu/meshing/uniform_mesher.dll"
%gx1% -o lib/cpu/meshing/utils.o source/cpu/meshing/utils.cpp
%gx2% -o lib/cpu/meshing/utils.dll lib/cpu/meshing/utils.o
echo "compiled lib/cpu/meshing/utils.dll"


%gx1% -o lib/cpu/soil_machine/SoilMachine.o source/cpu/soil_machine/SoilMachine.cpp
%gx2% -o lib/cpu/soil_machine/SoilMachine.dll lib/cpu/soil_machine/SoilMachine.o
echo "compiled lib/cpu/soil_machine/SoilMachine.dll"
