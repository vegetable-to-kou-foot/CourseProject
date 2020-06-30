import torch
import torch.nn as nn
import torch.nn.functional as F
import numpy as np
from torchvision import datasets, transforms
import torch.utils.data as Data


class LeNet5(nn.Module):
    def __init__(self):
        super(LeNet5, self).__init__()
        self.net0 = nn.Sequential(
            nn.Conv2d(in_channels=1, out_channels=6, kernel_size=5, stride=1),
            nn.ReLU(True),
            nn.AvgPool2d(kernel_size=2, stride=2),
            nn.Conv2d(in_channels=6, out_channels=16, kernel_size=5, stride=1),
            nn.ReLU(True),
            nn.AvgPool2d(kernel_size=2, stride=2)
        )
        self.net1 = nn.Sequential(
            nn.Linear(4 * 4 * 16, 120),
            nn.ReLU(True),
            nn.Linear(120, 84),
            nn.ReLU(True),
            nn.Linear(84, 10),
            nn.ReLU(True)
        )

    def forward(self, x):
        in_size = x.size(0)
        x = self.net0(x)
        x = x.view(in_size, -1)
        x = self.net1(x)
        x = F.softmax(x, dim=1)
        return x


def load_data():
    transform = transforms.Compose(
        [transforms.ToTensor(), transforms.Normalize(mean=[0.5], std=[0.5])])
    data_train = datasets.MNIST(root=r"F:\\jupyter-ML\\MachineLearning\\CH4\\",
                                transform=transform,
                                train=True)
    data_test = datasets.MNIST(root=r"F:\\jupyter-ML\\MachineLearning\\CH4\\",
                               transform=transform,
                               train=False)
    train_loader = Data.DataLoader(dataset=data_train,
                                   batch_size=64,
                                   shuffle=True)
    test_loader = Data.DataLoader(dataset=data_test,
                                  batch_size=64,
                                  shuffle=True)
    return train_loader, test_loader


def train():
    for step, (data_batch, label_batch) in enumerate(train_loader):
        optimizer.zero_grad()
        pred = lenet5(data_batch)
        loss = loss_fun(pred, label_batch)
        loss.backward()
        optimizer.step()
        if step % 100 == 0:
            print("正在训练第{}/{}({}%)批图像，当前损失loss={}".format(step, train_loader.__len__(),
                                                          100 * step / train_loader.__len__(), loss.item()))


def test():
    loss_test = []
    acc_test = []
    with torch.no_grad():
        for step, (data_batch, label_batch) in enumerate(test_loader):
            pred = lenet5(data_batch)
            loss = loss_fun(pred, label_batch)
            acc = torch.sum(torch.argmax(pred, dim=1) == label_batch).item() / label_batch.size(0)
            loss_test.append(loss)
            acc_test.append(acc)
            if step % 100 == 0:
                print("正在测试第{}/{}({}%)批图像，损失loss={}，准确率acc={}".format(
                    step, test_loader.__len__(), 100 * step / test_loader.__len__(), loss, acc))
    return np.mean(np.array(loss_test)), np.mean(np.array(acc_test))


if __name__ == '__main__':
    train_loader, test_loader = load_data()
    EPOCHS = 50
    lenet5 = LeNet5()
    print(lenet5)
    optimizer = torch.optim.SGD(lenet5.parameters(), lr=0.01, momentum=0.8)
    loss_fun = nn.CrossEntropyLoss()
    # lenet5.load_state_dict(torch.load(r'F:\jupyter-ML\MachineLearning\CH4\checkpoint\checkpoint_49')['model_state_dict'])
    for i in range(49, EPOCHS):
        train()
        loss_test, acc_test = test()
        print("--->当前处于第{}/{}({}%)个epoch\t损失loss={}\t准确率acc={}\n".format(
            i, EPOCHS, i * 100 / EPOCHS, loss_test, acc_test))
        torch.save({'epoch': i,
                    'model_state_dict': lenet5.state_dict(),
                    'loss': loss_test},
                   r'F:\jupyter-ML\MachineLearning\CH4\checkpoint\checkpoint_{}'.format(i))
