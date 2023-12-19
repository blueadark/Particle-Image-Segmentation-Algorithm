# Particle-Image-Segmentation-Algorithm

数据集说明：
dataset1为谷粒数据集，dataset2为红色色母颗粒数据集，dataset3为NucleusSegData细胞数据集
文件说明：
1、改进SLIC算法代码              SLIC_0文件夹
2、谷粒、色母、细胞的高斯模型建立代码      Train_grain文件夹、Train_masterbatch文件夹、Train_cell文件夹
3、输出结果            Output文件夹
4、集成学习代码       ensemble.m
5、指标计算代码       f_index.m
6、主函数代码          f_keli.m      
7、超像素分类代码     （谷粒train_grain.m  色母粒train_master.m  细胞train_cell.m ）
8、二次分割代码      slic_m_2.m
9、测试代码    test.m


输入：彩色图像（.jpg）
输出：黑白二值图（.jpg）
