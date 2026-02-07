export ARCHITECTURE=arm64

export LINUXSOURCEDIR=/opt/atom01/orangepi-build/kernel/kernel

export KERNEL_COMPILER=aarch64-none-linux-gnu-

export KERNEL_USE_GCC=">=11.0"

export KERNEL_ONLY=yes

export CTHREADS=-j$(nproc)



# 1. 内核原生架构变量（替换你的ARCHITECTURE，make编译必须用ARCH）
export ARCH=arm64
# 2. 内核原生交叉编译前缀（直接复用你的KERNEL_COMPILER，make核心变量）
export CROSS_COMPILE=${KERNEL_COMPILER}
# 3. 把框架的GCC11.2编译器加入系统PATH（让make能找到aarch64-none-linux-gnu-gcc，关键！）
export PATH=/opt/atom01/orangepi-build/toolchains/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu/bin:$PATH


make rockchip_linux_defconfig

