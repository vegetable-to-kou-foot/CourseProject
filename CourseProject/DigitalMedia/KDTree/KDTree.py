import numpy as np
import time


class KDTree:
    def __init__(self, data, deep):
        data_l, data_m, data_r = splitData(data, deep)
        self.deep = deep
        self.val = data_m
        self.leftNode = setNode(data_l, deep + 1)
        self.rightNode = setNode(data_r, deep + 1)

    def printTree(self):
        print('-' * self.deep, end=' ')
        print("Node:deep={},val={}".format(self.deep, self.val))
        if self.leftNode is None and self.rightNode is None:
            return
        print('-' * self.deep + " LeftNode:")
        if self.leftNode is not None:
            self.leftNode.printTree()
        else:
            print('-' * (self.deep + 1), end=' ')
            print("None")
        print('-' * self.deep + " RightNode:")
        if self.rightNode is not None:
            self.rightNode.printTree()
        else:
            print('-' * (self.deep + 1), end=' ')
            print("None")


def setNode(data, deep):
    if data.size == 0:
        return None
    else:
        return KDTree(data, deep)


def splitData(data, deep):
    dim = 'x' if deep % 2 == 1 else 'y'

    # 找到data[dim]中第一个大于等于中位数的元素
    data_tmp = data[dim].copy()
    mid_tmp = np.median(data_tmp)
    data_tmp -= mid_tmp
    data_tmp[data_tmp < 0] = np.inf
    idx_min = np.argmin(data_tmp)
    mid = data[dim][idx_min]

    data_tmp = data[dim]
    idx_l = data_tmp < mid
    idx_m = data_tmp == mid
    idx_r = data_tmp > mid
    return data[idx_l], data[idx_m], data[idx_r]


def dist(x, y_all, queryNotSearched):
    dist_min, pt_min = np.inf, (0, 0)
    for y in y_all:
        dis = ((x[0] - y[0]) ** 2 + (x[1] - y[1]) ** 2) ** 0.5
        if dis < 1e-8 and queryNotSearched:
            queryNotSearched = False
            continue
        # 如果这个点就是查询点，则跳过，因为题目要求跳过被查询的点
        if dis < dist_min:
            dist_min = dis
            pt_min = y
    return dist_min, pt_min, queryNotSearched


def isIntersect(node, query, dis_min):
    # node.val的哪一列
    dim = 'x' if node.deep % 2 == 1 else 'y'
    # query中的哪一列
    idx = (node.deep + 1) % 2
    if abs(node.val[0][dim] - query[idx]) <= dis_min:
        return True
    else:
        return False


def findNN(node, query, dis_min, kpt_min, queryNotSearched):
    if node.leftNode is None and node.rightNode is None:
        # node.val可能有多个点
        dis, kpt, queryNotSearched = dist(query, node.val, queryNotSearched)
        if dis < dis_min:
            dis_min = dis
            kpt_min = kpt
        return dis_min, kpt_min
    # node.val的哪一列
    dim = 'x' if node.deep % 2 == 1 else 'y'
    # query中的哪一列
    idx = (node.deep + 1) % 2
    # 向左子节点走
    if node.val[0][dim] > query[idx]:
        dis, kpt, queryNotSearched = dist(query, node.val, queryNotSearched)
        if dis < dis_min:
            dis_min = dis
            kpt_min = kpt
        if node.leftNode is not None:
            dis_min, kpt_min = findNN(node.leftNode, query, dis_min, kpt_min, queryNotSearched)
        if isIntersect(node, query, dis_min) and node.rightNode is not None:
            dis_min, kpt_min = findNN(node.rightNode, query, dis_min, kpt_min, queryNotSearched)
        return dis_min, kpt_min
    # 向右子节点走
    elif node.val[0][dim] < query[idx]:
        dis, kpt, queryNotSearched = dist(query, node.val, queryNotSearched)
        if dis < dis_min:
            dis_min = dis
            kpt_min = kpt
        if node.rightNode is not None:
            dis_min, kpt_min = findNN(node.rightNode, query, dis_min, kpt_min, queryNotSearched)
        if isIntersect(node, query, dis_min) and node.leftNode is not None:
            dis_min, kpt_min = findNN(node.leftNode, query, dis_min, kpt_min, queryNotSearched)
        return dis_min, kpt_min
    elif node.val[0][dim] == query[idx]:
        dis, kpt, queryNotSearched = dist(query, node.val, queryNotSearched)
        if dis < dis_min:
            dis_min = dis
            kpt_min = kpt
        if node.rightNode is not None:
            dis_min, kpt_min = findNN(node.rightNode, query, dis_min, kpt_min, queryNotSearched)
        if node.leftNode is not None:
            dis_min, kpt_min = findNN(node.leftNode, query, dis_min, kpt_min, queryNotSearched)
        return dis_min, kpt_min


def dist_A_B(A, B):
    tmp = - 2 * np.dot(A.T, B) + np.transpose([np.sum(np.square(A), axis=0)]) + np.sum(np.square(B), axis=0)
    tmp[tmp < 0] = 0
    return np.sqrt(tmp)


if __name__ == '__main__':
    time_start = time.time()
    dt = np.dtype([('x', 'f8'), ('y', 'f8')])
    # data = np.array([(5, 4), (7, 2), (8, 1), (4, 7), (2, 3), (9, 6)], dtype=dt)
    # data_np = np.array([[5, 7, 8, 4, 2, 9], [4, 2, 1, 7, 3, 6]])
    data_raw = np.loadtxt('real.txt').tolist()
    data = [(k[6], k[7]) for k in data_raw]
    data_np = np.array(data).T
    data = np.array(data, dtype=dt)
    root = KDTree(data, 1)
    # root.printTree()
    time_end = time.time()
    print("准备阶段耗时{:.5f}s".format(time_end - time_start))

    time_start = time.time()
    find_num = 1000
    dis_all, kpt_all = [], []
    for i in range(find_num):
        q = data[i]
        dis, kpt = findNN(root, q, np.inf, (0, 0), True)
        dis_all.append(dis)
        kpt_all.append(kpt)
        # print("第{}个点的最近邻为{}，距离为{}".format(i, kpt, dis))
    time_end = time.time()
    time_kdt = time_end - time_start
    print("KDTree查询前{}个点最近邻耗时{:.5f}s".format(find_num,time_kdt))

    time_start = time.time()
    idx_all = []
    dist_d_q = dist_A_B(data_np, data_np[:, 0:find_num])
    for i in range(len(dist_d_q[0])):
        idx = np.argmin(dist_d_q[:, i])
        dist_d_q[idx, i] = np.inf
        idx = np.argmin(dist_d_q[:, i])
        idx_all.append(idx)
    time_end = time.time()
    time_np = time_end - time_start
    print("Numpy查询前{}个点最近邻耗时{:.5f}s".format(find_num,time_np))
    print("KDTree比Numpy用时减少{:.5f}%".format((time_np - time_kdt)*100.0/time_np))

    for i in range(find_num):
        dis = ((data[i][0] - data[idx_all[i]][0]) ** 2 + (data[i][1] - data[idx_all[i]][1]) ** 2) ** 0.5
        if abs(dis - dis_all[i]) > 1e-6:
            print("第{}个点两次计算结果不匹配".format(i))
            break
    else:
        print("前{}个点最近邻查询结果完全正确！".format(find_num))
