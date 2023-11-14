##### 0. 准备msys2
flop_fluids 库必须要mingw64编译

##### 1. 准备infinigen源码、各submodule 以及 flip_fluids 源码 
将本仓库脚本合并到infinigen仓库
##### 2. 准备Blender
安装blender
修改infinigen目录下install_by_msys.sh中的Blender_Path 为 blender 安装路径
后续使用的 python 均为 blender_python， 即 blender安装目录下 \{blender_version}\/python/bin/python.exe
##### 3. 准备 python310 源码，UCRT 库以及 pyconfig.h
下载python310源码，复制Include文件夹至 blender_python 父目录下
PS:如果没有安装python310，需要使用release配置编译python310源码
从python310安装/编译输出目录分别复制python310.lib 和pyconfig.h 到 blender_python 的 libs文件夹（需要新建） 和 include 文件夹。

安装UCRT 库 （源码编译或通过VS installer 安装）
PS：可以选择复制UCRT的 include 和 lib 到 自定义文件夹方便安装
修改 infinigen/worldgen/terrain 文件夹下的 install_terrain_for_win.bat 和 install_terrain.sh
修改其中的 nx 和 gx1 配置，分别指定 UCRT include 、 lib 和 glm include文件夹
##### 4. 编译terrain 库
建议在VS Developer powershell 环境下 执行 install_terrain_for_win.bat
也可以选择在msys2 中执行 install_terrain.sh（该版本编译后需要在msys2 中启动infinigen）

##### 5-7 只需执行在 msys2 中切换到infinigen目录执行 install.sh即可
##### 也可以使用命令行分别执行以下过程
##### 5. 安装 Python 依赖
1.  设置 CFLAGS 
2.  执行 blender_python -m pip install -r requirement.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/ # 必要时换源
   
PS:
+ windows下，numpy 和 scipy 有兼容性问题，numpy不能使用 1.21.5，需使用1.22版本

##### 6. 安装blender python 扩展

##### 7. 安装 bnurbs

##### 8. 安装Flop_fluids 库
在mingw 中切换到Flop_fluids目录执行 fuild 安装程序即可

##### tips
若全程使用 msys2，第四步开始，取消install.sh 17 行注释并执行即可