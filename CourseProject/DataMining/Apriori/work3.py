import numpy as np
import os


def read_data(path):
    file = open(path)
    lines = file.readlines()
    data = np.zeros((len(lines), 17))
    idx = 0
    for line in lines:
        line_list = line.split(',')
        # n替换成0，y替换成1，？替换成2，democrat替换成0，republican替换成1
        line_list = [0 if item == 'n' or item == 'n\n' else item for item in line_list]
        line_list = [1 if item == 'y' or item == 'y\n' else item for item in line_list]
        line_list = [2 if item == '?' or item == '?\n' else item for item in line_list]
        line_list = [0 if item == 'democrat' else item for item in line_list]
        line_list = [1 if item == 'republican' else item for item in line_list]
        data[idx, :] = np.array(line_list)
        idx += 1
    return data


def get_freq(freq_set, data):
    n, m = data.shape
    for i in range(len(freq_set)):
        idx = freq_set[i][0]
        # 利用numpy进行快速统计
        check = np.sum(data[:, idx] == 1, axis=1)
        freq_tmp = np.sum(check == len(idx)) * 1.0 / n
        freq_set[i][1] = freq_tmp
    return freq_set


def create_freq_set(data, minsup):
    # 生成长度为18的集合，用于存放频繁1-项集~频繁17-项集
    freq_set = [[] for _ in range(18)]
    n, m = data.shape
    # 先生成,list of [idxs,freq]
    freq_set[1] = [[[i], 0] for i in range(0, m)]
    freq_set[1] = get_freq(freq_set[1], data)
    # 后筛选
    freq_set[1] = [it for it in freq_set[1] if it[1] >= minsup]
    for set_size in range(2, m + 1):
        # 创建set_size-项集，基于(set_size-1)-项集
        freq_set_tmp = []
        for i in range(len(freq_set[set_size - 1])):
            for j in range(i + 1, len(freq_set[set_size - 1])):
                # 取出上一组频繁项集
                freq_set_1 = freq_set[set_size - 1][i][0]
                freq_set_2 = freq_set[set_size - 1][j][0]
                freq_set_tmp_tmp = []
                # 判断除了最后一个元素以外是否相等，注意要维护好字典序
                if freq_set_1[:-1] == freq_set_2[:-1]:
                    # 这样插入不会破坏字典序
                    freq_set_tmp_tmp.extend(freq_set_1)
                    freq_set_tmp_tmp.append(freq_set_2[-1])
                    freq_set_tmp.append([freq_set_tmp_tmp, 0])
        freq_set_tmp = get_freq(freq_set_tmp, data)
        # 先生成
        freq_set[set_size] = freq_set_tmp
        freq_set[set_size] = get_freq(freq_set[set_size], data)
        # 后筛选
        freq_set[set_size] = [it for it in freq_set[set_size] if it[1] >= minsup]
    return freq_set


def apriori_gen(freq_set_k,hm):
    h_new = []
    # 初始情况做特判
    if hm == [[]]:
        return [[it] for it in freq_set_k]
    for h in hm:
        # None标记就是要删除的
        if h is None:
            continue
        # 后件的最后一个元素不是频繁项集的最后一个元素，就还能扩展
        for freq_idx in range(freq_set_k.index(h[-1])+1, len(freq_set_k)):
            tmp = h
            tmp.append(freq_set_k[freq_idx])
            h_new.append(h)
    return h_new


def sigma(freq_set_k_no_hm):
    # 不可能不是频繁项集，因为freq_set_k是频繁项集，它的子集肯定也是频繁项集
    k = len(freq_set_k_no_hm)
    for freq_set_k, freq in freq_set[k]:
        if freq_set_k == freq_set_k_no_hm:
            return freq


def ap_genrules(freq_set_k, hm, m):
    # 传m是因为hm中可能出现None，不好计算hm中非None元素的长度
    k = len(freq_set_k)
    # 书上可能是笔误？
    if k >= m+1:
        # 由m项后件生成m+1项后件
        hm = apriori_gen(freq_set_k,hm)
        for i in range(len(hm)):
            h = hm[i]
            freq_set_k_no_hm = [it for it in freq_set_k if it not in h]
            conf = freq/sigma(freq_set_k_no_hm)
            if conf >= minconf:
                return [freq_set_k_no_hm, h, conf]
            else:
                # 置为None在下一次apriori_gen就会被删掉
                hm[i] = None
        rules_set[k].append(ap_genrules(freq_set_k, hm, m+1))


if __name__ == '__main__':
    # 将文本转化为numpy数组
    data = read_data(r'F:\jupyter-ML\DataMining\house-votes-84.data')
    minsup = 0.3
    minconf = 0.9
    # 生成频繁1-项集~频繁17-项集
    # freq_set:[ [ [idx_0,idx_1,...,idx_n] freq ],[...] ] ,length=18
    freq_set = create_freq_set(data, minsup)

    # 挖掘出全部的关联规则
    rules_set = [[] for _ in range(18)]
    # Apriori算法
    for k in range(2, 18):
        for freq_set_k, freq in freq_set[k]:
            # h是后件，用list of list表示
            h = [[]]
            rules_set[k].append(ap_genrules(freq_set_k, h, 0))
    # 去掉None
    for k in range(2, 18):
        rules_set[k] = [it for it in rules_set[k] if it is not None]

    # 显示关联规则
    for k in range(2, 18):
        for rules_f, rules_b, conf in rules_set[k]:
            if 0 in rules_b:
                print("规则{}=>{},置信度{:.5f}".format(rules_f,rules_b,conf))
