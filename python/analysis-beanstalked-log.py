# -*- coding: utf-8 -*-

# 本脚本是用于解析 beanstalkd 的 binlog 文件
# 根据 https://segmentfault.com/a/1190000009604082 文档提供的解析策略编写

import sys
import getopt
import os
import re
import struct

def usage():
    """ 脚本使用说明 """
    print("python %s -i [binlog所在的文件夹] -o [保存的文件夹]" % (__file__))

def parse(dict_options):
    """ 解析"""
    input_dir = dict_options['-i']
    output_dir = dict_options['-o']
    # 读取 输入文件夹下的文件
    input_files = os.listdir(input_dir)
    for i in range(0, len(input_files)):
        # 对文件夹过滤 匹配 binlog.* , 同时是文件
        input_file = os.path.join(input_dir, input_files[i])
        if re.match('binlog.*', input_files[i]) and os.path.isfile(input_file):
            with open(os.path.join(output_dir, input_files[i]), 'w') as output_file:
                convert(input_file, output_file)

def convert(input_file, output_file):
    # 读取文件内容，同时写入到输出文件夹的同文件名中
    with open(input_file, 'rb') as fd:
        # 版本号
        version = struct.unpack('i', fd.read(4))
        while True:
            # 管道名的长度
            tuplename_num = int(struct.unpack('i', fd.read(4))[0])
            if tuplename_num > 201:
                return 0
            if tuplename_num > 0:
                # 管道名
                tuplename = fd.read(tuplename_num)
                # job 记录
                job = readJob(fd)
                if not job:
                    break
                # 保存 tuplename
                job['tuplename'] = tuplename
                # 读取 body 内容
                job['body'] = fd.read(int(job['body_size'])).replace("\r\n", "")
                output_file.writelines("{id: %(id)s, pri: %(pri)s, state: '%(state)s', delay: %(delay)s, ttr: %(ttr)s, "
                      "created_at: %(created_at)s, deadline_at: %(deadline_at)s, reserve_ct: %(reserve_ct)s, "
                      "timeout_ct: %(timeout_ct)s, release_ct: %(release_ct)s, bury_ct: %(bury_ct)s, "
                      "kick_ct: %(kick_ct)s, body_size: %(body_size)s, body: '%(body)s}' \n" % job)
            else:
                # 直接读取 record
                job = readJob(fd)
                if not job:
                    break
                output_file.writelines("{id: %(id)s, pri: %(pri)s, state: '%(state)s', delay: %(delay)s, ttr: %(ttr)s, "
                      "created_at: %(created_at)s, deadline_at: %(deadline_at)s, reserve_ct: %(reserve_ct)s, "
                      "timeout_ct: %(timeout_ct)s, release_ct: %(release_ct)s, bury_ct: %(bury_ct)s, "
                      "kick_ct: %(kick_ct)s, body_size: %(body_size)s \n" % job)

def readJob(fd):
    """ 读出一条 job """
    job = {}
    job['id']           = struct.unpack("Q", fd.read(8))[0]
    # 解析到 id 为 0 的 job 时，意味着该 binlog 已经全部解析完毕，可以开始解析下一个 binlog 文件
    if job['id'] == 0:
        return False
    job['pri']          = struct.unpack("I", fd.read(4))[0]
    _ = struct.unpack("I", fd.read(4))[0]
    #     精确到纳秒
    job['delay']        = struct.unpack("q", fd.read(8))[0]
    #     精确到纳秒
    job['ttr']          = struct.unpack("q", fd.read(8))[0]
    job['body_size']   = struct.unpack("i", fd.read(4))[0]
    _ = struct.unpack("I", fd.read(4))[0]
    #     创建时间， epoch 纪年，精确到纳秒
    job['created_at']  = struct.unpack("Q", fd.read(8))[0]
    #     下一个会因超时而产生状态变迁的时间
    job['deadline_at'] = struct.unpack("Q", fd.read(8))[0]
    job['reserve_ct']  = struct.unpack("I", fd.read(4))[0]
    job['timeout_ct']  = struct.unpack("I", fd.read(4))[0]
    job['release_ct']  = struct.unpack("I", fd.read(4))[0]
    job['bury_ct']     = struct.unpack("I", fd.read(4))[0]
    job['kick_ct']     = struct.unpack("I", fd.read(4))[0]
    job['state']       =  getStateDesc(struct.unpack("b", fd.read(1))[0])
    #     对齐用的
    _ = struct.unpack("3s", fd.read(3))[0]
    return job

def getStateDesc(state):
    """根据状态的 flag 返回描述"""
    state_map = {0: "Invalid", 1: "Ready", 2: "Reserved", 3: "Buried", 4: "Delayed", 5: "Copy"}
    return state_map[state]

if __name__ == '__main__':
    try:
        options, args = getopt.getopt(sys.argv[1:], "i:o:")
        # 列表转字典
        dict_options = {}
        for key, value in options:
            dict_options[key] = value
        # 读取 i 判断是否是文件夹
        if not dict_options.has_key('-i') or not os.path.isdir(dict_options['-i']):
            print("-i 参数 文件夹不存在")
            sys.exit()
        # 读取 o 判断是否是文件夹
        if not dict_options.has_key('-o') or not os.path.isdir(dict_options['-o']):
            print("-o 参数 文件夹不存在")
            sys.exit()

        # 解析
        parse(dict_options)
    except getopt.GetoptError:
        usage()
        sys.exit()