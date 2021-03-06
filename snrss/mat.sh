#!/bin/bash

#SBATCH -p cpu4
#SBATCH -N 1-1
#SBATCH -n 1
#SBATCH -B *:10
#SBATCH -c 2
#SBATCH --mem 5G
#SBATCH -o job-%j.out # 注意可以修改"job"为与任务相关的内容方便以后查询实验结果

date
module load matlab
# 下面的 test_cpu.m 换成你的 MATLAB 脚本的路径
srun matlab -nodisplay -nosplash -nodesktop -r "run('new_two_nine_extract_main.m'); exit;"
date