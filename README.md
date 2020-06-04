# JustPractice
Interesting but useless
查到这里的同学参考一下就行了，千万不要抄哦 (ゝ∀･)

## Course project
### C语言课程设计
#### 高精度计算工具
 高精度计算，有较好的鲁棒性。
 使用方式：编译并运行，按照提示操作即可使用。
#### BMP图像缩放工具
 实现BMP图像的缩放，支持1/4/8/24/32深度的BMP文件。
 使用方式：编译，在.exe文件同目录下打开cmd，输入指令**BMPImageScaler in.bmp 150 out.bmp**，即可得到in放大1.5倍后的图像。 
 
### 数字媒体大作业
#### 矢量量化
 将[corel数据集](https://languageresources.github.io/2018/06/24/%E5%88%98%E6%99%93_Corel%20Image%20Features%E6%95%B0%E6%8D%AE%E9%9B%86/)矢量量化，并降维显示。下载数据集后与.m文件放在同目录下，直接运行VQ.m即可。
#### LSH
 局部敏感哈希方法，具有对高维数据进行高效查询的功能。
 将高维数据仿照[corel数据集](https://languageresources.github.io/2018/06/24/%E5%88%98%E6%99%93_Corel%20Image%20Features%E6%95%B0%E6%8D%AE%E9%9B%86/)存储，然后将LSH.m中corel的文件名改成刚才存储的文件，即可看到以前1000个点的top10近邻点查询为例的运行结果（在32维下，10近邻查询精确率=召回率>98%，耗时减少50%+）。下周将更新python特供版，可以实现对高维数据集以及特定请求数据的查询。
