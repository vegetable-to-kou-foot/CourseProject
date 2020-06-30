import torch
import torch.nn as nn
import torch.nn.functional as F
import numpy as np
from torchvision import datasets, transforms
import torch.utils.data as Data


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


if __name__ == '__main__':
    train_loader, test_loader = load_data()
