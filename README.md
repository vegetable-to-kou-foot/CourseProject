# Course project
## 机器学习
请看./CourseProject/MachineLearning。
## C语言课程设计
### 高精度计算工具
 高精度计算，有较好的鲁棒性。
 
 使用方式：编译并运行，按照提示操作即可使用。
### BMP图像缩放工具
 实现BMP图像的缩放，支持1/4/8/24/32深度的BMP文件。
 
 使用方式：编译，在.exe文件同目录下打开cmd，输入指令**BMPImageScaler in.bmp 150 out.bmp**，即可得到in放大1.5倍后的图像。
### RLE压缩工具
 使用RLE压缩算法实现的压缩工具，对于有连续相同数据的文件可以有效地压缩。如背景色为黑色/白色的bmp图片，或大面积相同颜色的1/4/8深度bmp文件。
 
 使用方式：在.exe文件同目录下打开cmd，输入指令**rle UNI.bmp -c UNI.hgp**可以进行文件压缩，输入指令**rle UNI.hgp -d UNI_unpack.bmp**可以进行文件解压。
 
## 数字媒体大作业
### 矢量量化
 将[corel数据集](https://languageresources.github.io/2018/06/24/%E5%88%98%E6%99%93_Corel%20Image%20Features%E6%95%B0%E6%8D%AE%E9%9B%86/)矢量量化，并降维显示。下载数据集后与.m文件放在同目录下，直接运行VQ.m即可。
### LSH
 局部敏感哈希方法，具有对高维数据进行高效查询的功能。
 
 将高维数据仿照[corel数据集](https://languageresources.github.io/2018/06/24/%E5%88%98%E6%99%93_Corel%20Image%20Features%E6%95%B0%E6%8D%AE%E9%9B%86/)存储，然后将LSH.m中corel的文件名改成刚才存储的文件，即可看到以前1000个点的top10近邻点查询为例的运行结果（在32维下，10近邻查询精确率=召回率>98%，耗时减少50%+）。下周将更新python特供版，可以实现对高维数据集以及特定请求数据的查询。
### KDTree
 针对空间数据的一种高效KNN查询方法，相比于BF能够提高50%-70%的查询速度。考虑到numpy做矩阵运算时，矩阵太大会炸内存，因此实现时不建议像代码中一样使用矩阵对矩阵的L2距离计算，因此BF在实际使用时会更慢，相对的KDTree就更好了一些。
 
 real.txt是一个名为CA的数据集中的详细数据（没找到数据来源），最后两列是经纬度，就用这两维作为数据点的横纵坐标值。KDTree.py能够得到前1000个点的最近邻，并统计并对比算法效率。

## 数据挖掘大作业
### Apriori算法
基于“非频繁项集的超集一定是非频繁项集”进行的关联规则挖掘，因为这条定理的存在，该算法实现了指数级的剪枝，并具有一定的实用价值。

运行work3.py，即可得到形如“对问题A和B投票yes，则他是共和党”的规则。这些规则有至少0.3的支持度与至少0.9的置信度。
### 社团发现
基于层次聚类，寻找空手道数据集的社团。

相似度使用“点A到点B的路径数的对数”，因为直接用路径数的话画出来的树状图不便于观察所以要取对数；评价指标是模块度Q值。当Q值最大时，点集被聚为5个社团，用Cytoscape可以看到出现聚类错误的只有一个3号点。

运行main.m，即可看到聚类结果。也可以直接查看文件夹中的图片。
