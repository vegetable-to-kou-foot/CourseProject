import torch
import torch.nn as nn
import pandas as pd
import numpy as np
import torch.utils.data as Data
import matplotlib.pyplot as plt


class LinearNet(nn.Module):
    def __init__(self):
        super(LinearNet, self).__init__()
        self.net0 = nn.Sequential(
            nn.Linear(4, 32),
            nn.ReLU(True),
            nn.Linear(32, 64),
            nn.ReLU(True),
            nn.Linear(64, 64),
            nn.ReLU(True),
            nn.Linear(64, 32),
            nn.ReLU(True),
            nn.Linear(32, 4),
            nn.ReLU(True),
            nn.Linear(4, 2),
            nn.ReLU(True),
            nn.Linear(2, 1)
        )

    def forward(self, x):
        out = self.net0(x)
        return out


def load_data():
    data_csv = pd.read_csv(data_path)
    month = ['', 'jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec']
    day = ['', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']
    for i in range(1, 13):
        data_csv.replace(month[i], i, inplace=True)
    for i in range(1, 8):
        data_csv.replace(day[i], i, inplace=True)
    data_tensor = torch.from_numpy(np.array(data_csv.iloc[:, 8:12]).astype(np.float32))
    label_tensor = torch.log(1+torch.from_numpy(np.expand_dims(np.array(data_csv.iloc[:, -1]), axis=1).astype(np.float32)))
    # label_tensor = torch.from_numpy(np.expand_dims(np.array(data_csv.iloc[:, -1]), axis=1).astype(np.float32))
    length = data_tensor.size(0)
    cut_point = length * 7 // 10
    data_train = data_tensor[:cut_point]
    data_test = data_tensor[cut_point:]
    label_train = label_tensor[:cut_point]
    label_test = label_tensor[cut_point:]

    loader_train = Data.DataLoader(
        dataset=Data.TensorDataset(data_train, label_train),
        batch_size=cut_point // 7,
        shuffle=True
    )
    loader_test = Data.DataLoader(
        dataset=Data.TensorDataset(data_test, label_test),
        batch_size=cut_point // 7,
        shuffle=True
    )
    return loader_train, loader_test


def train():
    for step, (data_batch, label_batch) in enumerate(loader_train):
        optimizer.zero_grad()
        pred = linearNet(data_batch)
        loss = loss_fun(pred, label_batch)
        loss /= label_batch.size(0)
        loss.backward()
        optimizer.step()


def test():
    loss_test = []
    with torch.no_grad():
        for step, (data_batch, label_batch) in enumerate(loader_test):
            pred = linearNet(data_batch)
            pred = torch.exp(pred) - 1
            label_batch = torch.exp(label_batch) - 1
            loss = loss_fun(pred, label_batch)
            loss /= label_batch.size(0)
            loss_test.append(loss.item())
    return np.mean(np.array(loss_test))


if __name__ == '__main__':
    data_path = r'F:\jupyter-ML\MachineLearning\CH4\forestfires.csv'
    loader_train, loader_test = load_data()

    linearNet = LinearNet()
    optimizer = torch.optim.SGD(linearNet.parameters(), lr=1e-4)
    loss_fun = nn.MSELoss()
    print(linearNet)

    EPOCHS = 1000
    loss_his = []
    for i in range(EPOCHS):
        train()
        loss_test = test()
        loss_his.append(loss_test)
        if i % 20 == 0:
            print("当前处于第{}/{}({}%)个epoch\t损失loss={}\n".format(i, EPOCHS, i * 100 / EPOCHS, loss_test))
    print("历史平均损失：{}".format(np.mean(np.array(loss_his))))

    plt.rcParams['font.sans-serif'] = ['SimHei']  # 用来正常显示中文标签
    plt.rcParams['axes.unicode_minus'] = False  # 用来正常显示负号
    plt.plot(list(range(1,EPOCHS+1)),loss_his, color='blue')
    plt.title(u'损失变化曲线')
    plt.xlabel(u'Epoch')
    plt.ylabel(u'Loss')
    plt.show()
