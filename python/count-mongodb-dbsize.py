# -*- coding: utf-8 -*-

# 本脚本是用于统计 mongodb 的数据空间

import pymongo
from pymongo import MongoClient
import sys

reload(sys)
sys.setdefaultencoding('utf8')

def enter():
    # 创建连接
    client= MongoClient('127.0.0.1',27017)

    #    保存统计数据
    statistics = {'total': 0, 'dbs': []}

    # all db
    for db_name in client.list_database_names():
        db = client.get_database(db_name)
        db_info = db.command('dbStats', 1)
        # 存储空间累加
        statistics['total'] += db_info['storageSize']
        statistics['dbs'].append({
            'db'          : db_info['db'],
            'avgObjSize' : bytes2human(db_info['avgObjSize']),
            'storageSize': bytes2human(db_info['storageSize']),
            'indexSize'  : bytes2human(db_info['indexSize']),
            'collections': db_info['collections'],
            'objects'    : db_info['objects'],
        })

        staticDB(client, db_name)

    formatTable(statistics)

def staticDB(client, db_name):
    statistics = {'db_name': db_name, 'total': 0, 'collections': []}
    db = client.get_database(db_name)

    try:
        # all collection in db
        for collection_name in db.collection_names():
            collection_info = db.command('collstats', collection_name)
            # 存储空间累加
            statistics['total'] += collection_info['storageSize']
            statistics['collections'].append({
                'collection'  : collection_name,
                'avgObjSize'  : bytes2human(collection_info['avgObjSize']) if collection_info.has_key('avgObjSize') else 0,
                'storageSize' : bytes2human(collection_info['storageSize']),
                'indexSize'   : bytes2human(collection_info['totalIndexSize']),
                'count'        : collection_info['count'],
            })

        formatCollectionTable(statistics)
    except:
        print(collection_info)
        raise

def bytes2human(n):
    """ 字节转换 """
    symbols = ('K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y')
    prefix = {}
    for i, s in enumerate(symbols):
        prefix[s] = 1 << (i + 1) * 10
    for s in reversed(symbols):
        if n >= prefix[s]:
            value = float(n) / prefix[s]
            return '%.1f%s' % (value, s)
    return '%sB' % n

def formatTable(statistics):
    """格式化表格输出"""
    print("====数据库总统计====" + "=" * 20)
    print("总占用空间（不包括索引）: %s" % (bytes2human(statistics['total'])))
    print("%(db)24s | %(storageSize)14s | %(indexSize)14s | %(collections)14s | %(objects)14s | %(avgObjSize)26s"
                % {"db": "数据库", "storageSize": "占用空间", "indexSize": "索引空间", "avgObjSize": "文件平均空间", "collections": "集合数", "objects": "文档数"})
    for statistic in statistics['dbs']:
        print("%(db)20s | %(storageSize)10s | %(indexSize)10s | %(collections)10s | %(objects)10s | %(avgObjSize)20s"
              % {"db": statistic['db'], "storageSize": statistic['storageSize'], "indexSize": statistic['indexSize'], "avgObjSize": statistic['avgObjSize'], "collections": statistic['collections'], "objects": statistic['objects']})

def formatCollectionTable(statistics):
    """格式化集合表格输出"""
    print("数据库：%s, 总占用空间（不包括索引）: %s" % (statistics['db_name'], bytes2human(statistics['total'])))
    print("%(db)42s | %(storageSize)14s | %(indexSize)14s | %(count)14s | %(avgObjSize)26s"
                % {"db": "集合", "storageSize": "占用空间", "indexSize": "索引空间", "avgObjSize": "文件平均空间", "count": "文档数"})
    for statistic in statistics['collections']:
        print("%(db)40s | %(storageSize)10s | %(indexSize)10s | %(count)10s | %(avgObjSize)20s"
              % {"db": statistic['collection'], "storageSize": statistic['storageSize'], "indexSize": statistic['indexSize'], "avgObjSize": statistic['avgObjSize'], "count": statistic['count']})


enter()

