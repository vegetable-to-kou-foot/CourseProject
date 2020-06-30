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
    for step, (data_batch, label_batch) in enumerate(train_loader):
        optimizer.zero_grad()
        pred = linearNet(data_batch)
        loss = loss_fun(pred, label_batch)
        loss.backward()
        optimizer.step()
    return


def test(linearNet, loss_fun):
    loss_test = []
    acc_test = []
    with torch.no_grad():
        for step, (data_batch, label_batch) in enumerate(test_loader):
            pred = linearNet(data_batch)
            loss = loss_fun(pred, label_batch)
            loss_test.append(loss)
            acc_test.append(torch.sum(torch.argmax(pred, dim=1) == label_batch).item() / label_batch.size(0))
    return np.mean(np.array(loss_test)), np.mean(np.array(acc_test))


def vali(linearNet, loss_fun):
    loss_test = []
    acc_test = []
    with torch.no_grad():
        for step, (data_batch, label_batch) in enumerate(vali_loader):
            pred = linearNet(data_batch)
            loss = loss_fun(pred, label_batch)
            loss_test.append(loss)
            acc_test.append(torch.sum(torch.argmax(pred, dim=1) == label_batch).item() / label_batch.size(0))
    return np.mean(np.array(loss_test)), np.mean(np.array(acc_test))


def vali_performance(net_id):
    EPOCHS = 400
    loss_vali = []
    acc_vali = []
    for num in range(4, 129, 4):
        loss_test = []
        acc_test = []
        linearNet = LinearNet1(num) if net_id == 1 else LinearNet2(num)
        optimizer = torch.optim.SGD(linearNet.parameters(), lr=0.01)
        loss_fun = nn.CrossEntropyLoss()
        for i in range(EPOCHS):
            train(linearNet, optimizer, loss_fun)
            loss, acc = vali(linearNet, loss_fun)
            loss_test.append(loss)
            acc_test.append(acc)
        loss_vali.append(np.mean(np.array(loss_test)))
        acc_vali.append(np.mean(np.array(acc_test)))
        print("对于net_id={}的网络，隐层宽度为{}时，损失为{}，准确率为{}".format(
            net_id, num, np.mean(np.array(loss_test)), np.mean(np.array(acc_test))))
    loss_vali, acc_vali = np.array(loss_vali), np.array(acc_vali)
    print("--->对于net_id={}的网络，使得准确率最高的隐层宽度为{}，使得损失最小的隐层宽度为{}".format(
        net_id, 4 * (np.argmax(acc_vali) + 1), 4 * (np.argmin(loss_vali) + 1)))
    return loss_vali, acc_vali


def test_perfoemance(net_id, num):
    EPOCHS = 400
    loss_test = []
    acc_test = []
    linearNet = LinearNet1(num) if net_id == 1 else LinearNet2(num)
    optimizer = torch.optim.SGD(linearNet.parameters(), lr=0.01)
    loss_fun = nn.CrossEntropyLoss()
    for i in range(EPOCHS):
        train(linearNet, optimizer, loss_fun)
        loss, acc = vali(linearNet, loss_fun)
        loss_test.append(loss)
        acc_test.append(acc)
    return np.mean(np.array(loss_test)), np.mean(np.array(acc_test))


if __name__ == '__main__':
    train_loader, vali_loader, test_loader = load_data()

    loss_vali_1, acc_vali_1 = vali_performance(1)
    loss_vali_2, acc_vali_2 = vali_performance(2)

    loss_test_1, acc_test_1 = test_perfoemance(1, 2 * (np.argmax(acc_vali_1) + 1))
    loss_test_2, acc_test_2 = test_perfoemance(2, 2 * (np.argmax(acc_vali_2) + 1))
    print("===>网络1隐层宽度为{}，准确率为{}\n===>网络2隐层宽度为{}，准确率为{}".format(
        4 * (np.argmax(acc_vali_1) + 1), acc_test_1, 4 * (np.argmax(acc_vali_2) + 1), acc_test_2))
