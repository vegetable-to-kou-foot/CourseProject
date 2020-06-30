import matplotlib.pyplot as plt
import numpy as np
import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.utils.data as Data


class LinearNet1(nn.Module):
    def __init__(self):
        super(LinearNet1, self).__init__()
        self.net0 = nn.Sequential(
            nn.Linear(2, 256),
            nn.ReLU(True),
            nn.Linear(256, 1)
        )

    def forward(self, x):
        return torch.sigmoid(self.net0(x))


class LinearNet2(nn.Module):
    def __init__(self):
        super(LinearNet2, self).__init__()
        self.net0 = nn.Sequential(
            nn.Linear(2, 256),
            nn.ReLU(True),
            nn.Linear(256, 256),
            nn.ReLU(True),
            nn.Linear(256, 1)
        )

    def forward(self, x):
        return torch.sigmoid(self.net0(x))


def load_data():
    np.random.seed(0)
    # 生成数据与标签
    num_p, num_n = 200, 800
    mu_p, mu_n = np.array([[2, 3]]), np.array([[5, 6]])
    x_p, x_n = np.random.randn(num_p, 2), np.random.randn(num_n, 2)
    x_p, x_n = x_p + mu_p, x_n + mu_n
    x_p, x_n = torch.from_numpy(x_p.astype(np.float32)), torch.from_numpy(x_n.astype(np.float32))
    label_p, label_n = torch.ones(num_p, 1), torch.zeros(num_n, 1)
    # 合并数据和标签，打乱
    data = torch.cat((x_p, x_n), dim=0)
    label = torch.cat((label_p, label_n), dim=0)
    idx = torch.randperm(num_p + num_n)
    data, label = data[idx], label[idx]
    # 切分成训练集、验证集、测试集
    cut_pt_1 = 60 * (num_n + num_p) // 100
    cut_pt_2 = 80 * (num_n + num_p) // 100
    data_train, data_vali, data_test = data[:cut_pt_1], data[cut_pt_1:cut_pt_2], data[cut_pt_2:]
    label_train, label_vali, label_test = label[:cut_pt_1], label[cut_pt_1:cut_pt_2], label[cut_pt_2:]
    vali_true = torch.sum(label_vali > 0.5).item()
    vali_false = torch.sum(label_vali < 0.5).item()

    # 转换为DataLoader
    BATCH_SIZE = 32
    train_loader = Data.DataLoader(
        dataset=Data.TensorDataset(data_train, label_train), batch_size=BATCH_SIZE, shuffle=True
    )
    vali_loader = Data.DataLoader(
        dataset=Data.TensorDataset(data_vali, label_vali), batch_size=BATCH_SIZE, shuffle=True
    )
    test_loader = Data.DataLoader(
        dataset=Data.TensorDataset(data_test, label_test), batch_size=BATCH_SIZE, shuffle=True
    )
    # # 支持中文
    # plt.rcParams['font.sans-serif'] = ['SimHei']  # 用来正常显示中文标签
    # plt.rcParams['axes.unicode_minus'] = False  # 用来正常显示负号
    # plt.scatter(x_p[:, 0], x_p[:, 1], c='r', marker='+')
    # plt.scatter(x_n[:, 0], x_n[:, 1], c='b', marker='+')
    # plt.title(r'数据集散点图')
    # plt.xlabel(r'X')
    # plt.ylabel(r'Y')
    # plt.show()
    return train_loader, vali_loader, test_loader, vali_true, vali_false


def train(linearNet, optimizer, loss_fun):
    for step, (data_batch, label_batch) in enumerate(train_loader):
        optimizer.zero_grad()
        pred = linearNet(data_batch)
        loss = loss_fun(pred, label_batch)
        loss.backward()
        optimizer.step()
    return


def vali(linearNet, thres):
    tp, fp = 0, 0
    with torch.no_grad():
        for step, (data_batch, label_batch) in enumerate(vali_loader):
            pred = linearNet(data_batch)
            tp += torch.sum((pred > thres).bool() & (label_batch > 0.5).bool()).item()
            fp += torch.sum((pred > thres).bool() & (label_batch < 0.5).bool()).item()
    return tp / vali_true, fp / vali_false


def vali_performance(net_id):
    # 训练网络
    EPOCHS = 400
    linearNet = LinearNet1() if net_id == 1 else LinearNet2()
    optimizer = torch.optim.SGD(linearNet.parameters(), lr=0.001)
    loss_fun = nn.MSELoss()
    for i in range(EPOCHS):
        train(linearNet, optimizer, loss_fun)
    print("训练完成，准备计算TPR与FPR")

    # 尝试不同的阈值，得到TPR和FPR
    tpr_vali_his = []
    fpr_vali_his = []
    for thres in np.linspace(0, 1, 50):
        tpr_vali, fpr_vali = vali(linearNet, thres)
        tpr_vali_his.append([thres, tpr_vali])
        fpr_vali_his.append([thres, fpr_vali])
    return np.array(tpr_vali_his), np.array(fpr_vali_his)


if __name__ == '__main__':
    train_loader, vali_loader, test_loader, vali_true, vali_false = load_data()

    tpr_vali_his_1, fpr_vali_his_1 = vali_performance(1)
    print(tpr_vali_his_1)
    print(fpr_vali_his_1)
    tpr_vali_his_2, fpr_vali_his_2 = vali_performance(2)

    np.save(r"F:\jupyter-ML\MachineLearning\CH5\tpr_vali_his_1.npy", tpr_vali_his_1)
    np.save(r"F:\jupyter-ML\MachineLearning\CH5\fpr_vali_his_1.npy", fpr_vali_his_1)
    np.save(r"F:\jupyter-ML\MachineLearning\CH5\tpr_vali_his_2.npy", tpr_vali_his_2)
    np.save(r"F:\jupyter-ML\MachineLearning\CH5\fpr_vali_his_2.npy", fpr_vali_his_2)
