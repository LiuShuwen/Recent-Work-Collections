# -*- coding: utf-8 -*-

import json
with open('studentBehaviorInfoOver40Class_1213.json') as tmp_file:
    stu_behavior = json.load(tmp_file) 


StuVideoDict = {}
for item in stu_behavior:
    List = []
    for pair in item['listenScore']:
        List.append((pair['postId'], pair['score']))
    StuVideoDict[item['memberId']]=List
    List = []

video_order = {}
for student in stu_behavior:
    student_video =[]
    for item in student['listenScore']:
        student_video.append(item['postId']) 
    video_order[student['memberId']] = student_video


# Prepocessing
for student in StuVideoDict:  #對於每個學生來說
    Unseen = []
    for video in set(video_order[student]): 
        flag = 0   # 對於每個影片給予一個ＴＡＧ
        for pair in StuVideoDict[student]:
            if pair[0] == video and (pair[1] != -1 and pair[1] != 0):
                flag = 1
        if flag == 0:
            Unseen.append(video)
    # 修正
    StuVideoDict[student] = [pair  for pair  in StuVideoDict[student]  if pair[0] not in Unseen]
    video_order[student] = [video for video in video_order[student] if video not in Unseen]

def Str2List(STR):
    List = []
    for element in STR[1:-1].split(","):
        List.append(int(element))
    return(List)


def sublist(lst, n):
    result=[]
    # 長度為Ｎ的sublist
    for i in range(0,len(lst)-n):
        result.append(lst[i:i+n])
    return result


def SubOrder(SelfId):
    SubOrder = []
    for length in range(5,10):
        SubOrder.extend(sublist(list(set(video_order[SelfId])),length))
    return SubOrder


# 找與其他學生的 common order
def CommonOrder(SelfId):
    Self = SubOrder(SelfId)
    CommonOrderDict = {}
    # 查找其他人的order
    for StuId in video_order:
        if StuId != SelfId :
            orderlist = SubOrder(StuId) 
            for i in Self:
                for j in orderlist:
                    if i == j:
                        if str(list(set(i))) in CommonOrderDict:
                            CommonOrderDict[str(list(set(i)))].append(StuId)
                        else :
                            CommonOrderDict[str(list(set(i)))] = [StuId]
            
    return(CommonOrderDict)

def common_elements(list1, list2):
    return list(set(list1) & set(list2))

def difference(v1,v2):
    total = 0
    if len(v1) == len(v2):
        for i in range(len(v1)):
            total = total + abs(v1[i]-v2[i])
    return total/(len(v1)**0.5)

from scipy import spatial
import numpy as np



def CommonVideoList(s1,s2):
    Common= common_elements(video_order[s1],video_order[s2])
    if not Common : 
        return([],-1)
    
    ################### Similarity
    Comparision_s1 = []
    Comparision_s2 = []
    len_s1 = len(StuVideoDict[s1])
    len_s2 = len(StuVideoDict[s2])

    # 砍掉video list 的 最後一個
    for (x,y) in StuVideoDict[s1][:len_s1] :
            if x in Common:
                Comparision_s1.append(y)
    for (x,y) in StuVideoDict[s2][:len_s2]:
            if x in Common:
                Comparision_s2.append(y)
    
    
    ##AVG
    Avg_s1 = np.mean(Comparision_s1)
    Avg_s2 = np.mean(Comparision_s2)
    ##Vector
    Vector_s1 = []
    Vector_s2 = []
    
    for i in range(0,len(Comparision_s1)): 
        Vector_s1.append( Comparision_s1[i] - Avg_s1 )
        Vector_s2.append( Comparision_s2[i] - Avg_s2 )
    
#     for i in range(0,len(Comparision_s1)-1): 
#         if (Comparision_s1[i] != -1 and Comparision_s1[i+1] == -1) or (Comparision_s1[i] == -1 and Comparision_s1[i] != -1):
#             Vector_s1.append(50)
#         else :
#             Vector_s1.append(Comparision_s1[i+1] - Comparision_s1[i])
#     for i in range(0,len(Comparision_s2)-1): 
#         if (Comparision_s2[i] != -1 and Comparision_s2[i+1] == -1) or (Comparision_s2[i] == -1 and Comparision_s2[i] != -1):
#             Vector_s2.append(50)
#         else :
#             Vector_s2.append(Comparision_s2[i+1] - Comparision_s2[i])
            
          
    
    # Similarity
    if(len(Common) > 1):
        cos = difference(Vector_s1, Vector_s2) 
    else:
        cos = -1
    return(Common ,cos )

            
        


