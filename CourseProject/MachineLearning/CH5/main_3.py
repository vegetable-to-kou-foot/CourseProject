import matplotlib.pyplot as plt
import numpy as np
import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.utils.data as Data


class LinearNet1(nn.Module):
    def __init__(self, num):
        super(LinearNet1, self).__init__()
        self.net0 = nn.Sequential(
            nn.Linear(2, num),
            nn.ReLU(True),
            nn.Linear(num, 2)
        )

    def forward(self, x):
        return F.softmax(self.net0(x), dim=1)


class LinearNet2(nn.Module):
    def __init__(self, num):
        super(LinearNet2, self).__init__()
        self.net0 = nn.Sequential(
            nn.Linear(2, num),
            nn.ReLU(True),
            nn.Linear(num, num),
            nn.ReLU(True),
            nn.Linear(num, 2)
        )

    def forward(self, x):
        return F.softmax(self.net0(x), dim=1)


def load_data():
    np.random.seed(0)
    # 生成数据与标签
    num_p, num_n = 200, 800
    mu_p, mu_n = np.array([[2, 3]]), np.array([[5, 6]])
    x_p, x_n = np.random.randn(num_p, 2), np.random.randn(num_n, 2)
    x_p, x_n = x_p + mu_p, x_n + mu_n
    x_p, x_n = torch.from_numpy(x_p.astype(np.float32)), torch.from_numpy(x_n.astype(np.float32))
    label_p, label_n = torch.ones(num_p).long(), torch.zeros(num_n).long()
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
    # 转换为DataLoader
    BATCH_SIZE = 16
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
    return train_loader, vali_loader, test_loader


def train(linearNet, optimizer, loss_fun):
    loss_train = []
    for step, (data_batch, label_batch) in enumerate(train_loader):
        optimizer.zero_grad()
        pred = linearNet(data_batch)
        loss = loss_fun(pred, label_batch)
        loss.backward()
        optimizer.step()
        loss_train.append(loss.item())
    return np.mean(np.array(loss_train))


def vali(linearNet, loss_fun):
    loss_vali = []
    with torch.no_grad():
        for step, (data_batch, label_batch) in enumerate(vali_loader):
            pred = linearNet(data_batch)
            loss = loss_fun(pred, label_batch)
            loss_vali.append(loss.item())
    return np.mean(np.array(loss_vali))


def vali_performance(net_id):
    EPOCHS = 200
    loss_vali_his = []
    loss_train_his = []
    for num in range(4, 257, 4):
        loss_vali_num = []
        loss_train_num = []
        linearNet = LinearNet1(num) if net_id == 1 else LinearNet2(num)
        optimizer = torch.optim.SGD(linearNet.parameters(), lr=0.001)
        loss_fun = nn.CrossEntropyLoss()
        for i in range(EPOCHS):
            loss_train = train(linearNet, optimizer, loss_fun)
            loss_vali = vali(linearNet, loss_fun)
            loss_train_num.append(loss_train)
            loss_vali_num.append(loss_vali)
        loss_train_his.append([num, np.mean(np.array(loss_train_num))])
        loss_vali_his.append([num, np.mean(np.array(loss_vali_num))])
        print("对于net_id={}的网络，隐层宽度为{}时，训练集损失为{}，验证集损失为{}".format(
            net_id, num, np.mean(np.array(loss_train_num)), np.mean(np.array(loss_vali_num))))
    return np.array(loss_train_his), np.array(loss_vali_his)


if __name__ == '__main__':
    train_loader, vali_loader, test_loader = load_data()

    loss_train_his_1, loss_vali_his_1 = vali_performance(1)
    loss_train_his_2, loss_vali_his_2 = vali_performance(2)

    np.save(r"F:\jupyter-ML\MachineLearning\CH5\loss_train_his_1.npy", loss_train_his_1)
    np.save(r"F:\jupyter-ML\MachineLearning\CH5\loss_vali_his_1.npy", loss_vali_his_1)
    np.save(r"F:\jupyter-ML\MachineLearning\CH5\loss_train_his_2.npy", loss_train_his_2)
    np.save(r"F:\jupyter-ML\MachineLearning\CH5\loss_vali_his_2.npy", loss_vali_his_2)
