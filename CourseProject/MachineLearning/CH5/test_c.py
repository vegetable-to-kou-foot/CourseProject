import numpy as np
import matplotlib.pyplot as plt

if __name__ == '__main__':
    tpr_vali_his_1 = np.load(r"F:\jupyter-ML\MachineLearning\CH5\tpr_vali_his_1.npy")
    fpr_vali_his_1 = np.load(r"F:\jupyter-ML\MachineLearning\CH5\fpr_vali_his_1.npy")
    tpr_vali_his_2 = np.load(r"F:\jupyter-ML\MachineLearning\CH5\tpr_vali_his_2.npy")
    fpr_vali_his_2 = np.load(r"F:\jupyter-ML\MachineLearning\CH5\fpr_vali_his_2.npy")

    plt.rcParams['font.sans-serif'] = ['SimHei']  # 用来正常显示中文标签
    plt.rcParams['axes.unicode_minus'] = False  # 用来正常显示负号
    plt.plot(fpr_vali_his_1[:, 1], tpr_vali_his_1[:, 1], color='blue', label='单隐层网络')
    plt.plot(fpr_vali_his_2[:, 1], tpr_vali_his_2[:, 1], color='green', label='双隐层网络')
    plt.legend()
    plt.title(u'ROC曲线')
    plt.xlabel(u'FPR')
    plt.ylabel(u'TPR')
    plt.show()
