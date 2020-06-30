import numpy as np
import matplotlib.pyplot as plt

if __name__ == '__main__':
    loss_train_his_1 = np.load(r"F:\jupyter-ML\MachineLearning\CH5\loss_train_his_1.npy")
    loss_vali_his_1 = np.load(r"F:\jupyter-ML\MachineLearning\CH5\loss_vali_his_1.npy")
    loss_train_his_2 = np.load(r"F:\jupyter-ML\MachineLearning\CH5\loss_train_his_2.npy")
    loss_vali_his_2 = np.load(r"F:\jupyter-ML\MachineLearning\CH5\loss_vali_his_2.npy")

    plt.rcParams['font.sans-serif'] = ['SimHei']  # 用来正常显示中文标签
    plt.rcParams['axes.unicode_minus'] = False  # 用来正常显示负号
    plt.plot(list(range(4, 257, 4)), loss_train_his_2[:, 1], color='blue', label='train')
    plt.plot(list(range(4, 257, 4)), loss_vali_his_2[:, 1], color='green', label='validation')
    plt.legend()
    plt.title(u'双隐层网络损失变化曲线')
    plt.xlabel(u'隐层宽度num')
    plt.ylabel(u'Loss')
    plt.show()
