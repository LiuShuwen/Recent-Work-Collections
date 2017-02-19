# -*- coding: utf-8 -*-
import StuDrop
import csv
import numpy as np
import CommonVideo
import scipy.cluster.hierarchy as sc
import scipy.spatial.distance as ssd
import matplotlib.pyplot as plt

    


def elbow_pt(Z, vis = False):
    num_curve = []
    slope = []

    interval= 8
    for i in range(450, 100, -interval):

        pre = len(np.unique(sc.fcluster(Z, i + interval ,criterion='distance' ).tolist()))
        now = len(np.unique(sc.fcluster(Z, i ,criterion='distance' ).tolist()))
        s = (now -pre) / interval
        num_curve.append( now )
        slope.append(s)

    diff_slope = np.diff(np.array(slope)).tolist()
    ep = diff_slope.index(max(diff_slope))
    ep_thres = 450 - interval * ep
    if(vis):
        print(ep_thres)
        plt.figure();
        plt.axvline(x=ep)
        plt.plot(num_curve)
    return ep_thres

def comparison(stu1, stu2):
    commonList ,sim = CommonVideo.CommonVideoList(stuList[stu1], stuList[stu2])
    for i in commonList:
        print(i)
        print('%4d'%stu1 + ":", end = '')
        for j in CommonVideo.StuVideoDict[stuList[stu1]]:
            if(i == j[0]):
                print('%3d'% j[1] + " ", end = '')
        print()
        print('%4d'%stu2 + ":", end = '')
        for j in CommonVideo.StuVideoDict[stuList[stu2]]:
            if(i == j[0]):
                print('%3d'% j[1] + " ", end = '')
        print('\n------\n') 

def get_clustered_data(clusters):
    cluster_idx = np.unique(clusters).tolist()
    stu_clusters = []
    for idx in cluster_idx:
        tmp_list = []
        cnadi = np.where(np.asarray(clusters) == idx)[0].tolist()
        for mem_id in cnadi:
            tmp_list.append(mem_id)
        stu_clusters.append(tmp_list)

    stu_clusters.sort(key = lambda s: len(s), reverse=True)    
    return stu_clusters

def proximity_matrix(stuList, thres_commonlist, extreme):
    # Initialization
    proximity_matrix = []
    stu_size = len(stuList)
    for i in range (0, stu_size):
        new = []                
        for j in range (0, stu_size):
            new.append((-1,-1))
        proximity_matrix.append(new)
        
    # Compute
    for i in range(0, stu_size):
        for j in range(i, stu_size):
            if(i == j):
                proximity_matrix[i][j] = 0
            else:               
                proximity_matrix[i][j] = proximity_dist(stuList, thres_commonlist, i, j, extreme)
                proximity_matrix[j][i] = proximity_matrix[i][j]
    return proximity_matrix
                
def proximity_dist(stuList, thres_commonlist, i, j, extreme):
    commonList ,sim =  CommonVideo.CommonVideoList(stuList[i], stuList[j])
    
    dist = extreme # value for the most unlike ones
    if((len(commonList) >= thres_commonlist) and not(np.isnan(sim))):
            dist =(round(sim, 5) + 2) 
    return dist

def hirarchical_clustering(stuList, thres_commonlist, method, extreme):
    pm = proximity_matrix(stuList , thres_commonlist, extreme)
    upper = ssd.squareform(pm) 
    Z = sc.linkage(upper , method)
    return Z

def model_selection(Z, thres, vis = False):
    if(thres == 'auto'):
        thres = elbow_pt(Z, vis)
        clusters = sc.fcluster(Z, thres,criterion='distance' ).tolist()
    else:
        clusters = sc.fcluster(Z, thres,criterion='distance' ).tolist()
        
    if(vis):
        
        plt.figure()
        plt.axhline(y=thres, c='k')
        sc.dendrogram(Z)
        plt.show()
        
    
    return clusters

def clustering_model(stuList, threshold_commonlist=4, method = 'complete', thres = 'auto', vis = False, extreme = 500):
    
    Z = hirarchical_clustering(stuList, threshold_commonlist, method, extreme)
    clusters = model_selection(Z,thres, vis)
    stu_cluster = get_clustered_data(clusters)
    print('# of clusters=>', len(stu_cluster))
    return stu_cluster

def find_closerclusering(memberid, clustering , stuList):
    
    #closer_list = [0]*len(clustering)
    #print(closer_list)
    closer_dict = {}
    
    for i in range(len(clustering)):
        avg_cos = 0
        for list_no in clustering[i]:
            Common ,cos = CommonVideo.CommonVideoList(memberid, stuList[list_no])
            avg_cos +=cos
        avg_cos = avg_cos/ len(clustering[i])
        closer_dict[str(i)] = avg_cos
        
        
    closer_dict = [(k, closer_dict[k]) for k in sorted(closer_dict, key=closer_dict.get)]
        
    return  closer_dict[0][0]

def ReplaceWithSameLevel(level , StuId , stuList,video_data):
    StudentList = list(set(CommonVideo.video_order[stuList[StuId]]))
    DropRate = []
    DropRate.extend([y for (x,y) in StuDrop.DropList(stuList[StuId]) if GetLevel(x,video_data) == level])
    if len(DropRate) > 0 :
        return np.mean(DropRate)
    else :
        return 0 

def GetLevel(ID , video_data):
    for row in video_data:
        if row["postId"] == ID:
            return row["Level"]
def Prediction( TargetList , belong , stu_clusters , stuList ,video_data):
    # 取最長的作為預測基準
    LongestCommonElement = 0 
    for StuId in stu_clusters[int(belong)]:
        StudentList = list(set(CommonVideo.video_order[stuList[StuId]]))
        Common = CommonVideo.common_elements(TargetList,StudentList)
        if len(Common) > LongestCommonElement:
            LongestCommonElement = StuId
        else :
            continue

    Score = 0
    for element in TargetList[-5:]:
        DropRate = []
        DropRate.extend([y for (x,y) in StuDrop.DropList(stuList[LongestCommonElement]) if x == element])
        if len(DropRate) > 0 :
            Score = (Score + DropRate[0])/2
        else:
            level = GetLevel(element,video_data)
            Score = (Score + ReplaceWithSameLevel(level,LongestCommonElement,stuList,video_data))/2 
    
    return Score