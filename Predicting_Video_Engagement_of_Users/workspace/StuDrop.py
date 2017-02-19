#!/usr/bin/env python
# -*- coding: utf-8 -*-
import CommonVideo
import json
stu_behavior = CommonVideo.stu_behavior
def DropList(stuId):
    student_drop_dict = {}
    total_score = 0
    now_postId = 0
    video_count = 0
    drop_count = 0
    drop_flag = 0
    stulist = []
    for i,data in enumerate(stu_behavior):
        if(stuId == data['memberId']):
            for j,v in enumerate(data['listenScore']):
                if(v['postId']!=now_postId):
                    if(now_postId != 0):
                        if (drop_flag == 0):
                            drop_count = video_count
                        if (total_score == 0):
                            drop_count = 0
                        avgscore = float(drop_count)/float(video_count)
                        stulist.append([now_postId,avgscore])
                        #print now_postId
                        #print avgscore
                    total_score = v['score']
                    now_postId = v['postId']
                    drop_flag = 0
                    video_count = 1
                    if(v['score']==-1 and drop_flag ==0):
                        drop_count = video_count -1
                        drop_flag = 1
                else:
                    total_score += v['score']
                    video_count += 1
                    if(v['score']==-1 and drop_flag == 0):
                        drop_count = video_count -1
                        drop_flag = 1
            #不加最后一个
            #if(now_postId != 0):
            #    avgscore = float(drop_count)/float(video_count)
                #print now_postId
                #print avgscore
            #    stulist.append([now_postId,avgscore])

    return stulist

def SplitList(stuId):
    now_postId = 0
    video_count = 0
    stulist = []
    total_score = 0
    for i,data in enumerate(stu_behavior):
        if(stuId == data['memberId']):
            for j,v in enumerate(data['listenScore']):
                if(v['postId']!= now_postId):
                    if(now_postId != 0):
                    	if (drop_flag == 0 and total_score != 0):
                        	stulist.append((now_postId,video_count))
                        #print now_postId
                        #print avgscore
                    total_score = v['score']
                    now_postId = v['postId']
                    drop_flag = 0
                    video_count = 1
                    if(v['score'] == -1):
                        drop_flag = 1
                else:
                    total_score += v['score']
                    video_count += 1
            #不加最后一个
            #if(now_postId != 0):
            #    avgscore = float(drop_count)/float(video_count)
                #print now_postId
                #print avgscore
            #    stulist.append([now_postId,avgscore])
    return stulist

def SplitPoint(stuId,sptNum):
    # Prepocessing
    SplitValue = 0
    ListLen = len(SplitList(stuId))
    SplitNumber = round(float(sptNum)*float(ListLen))
    if(SplitNumber == ListLen):
        SplitNumber = ListLen - 1
    SplitNumber = int(SplitNumber)
    for i in range(SplitNumber):
        SplitValue += SplitList(stuId)[i][1]
    NextValue = SplitList(stuId)[SplitNumber][0]
    return (SplitValue,NextValue)

def SplitPointNum(stuId,sptNum):
    # Prepocessing
    SplitValue = 0
    ListLen = len(SplitList(stuId))
    SplitNumber = ListLen - sptNum
    for i in range(SplitNumber):
        SplitValue += SplitList(stuId)[i][1]
    NextValue = SplitList(stuId)[SplitNumber][0]
    return (SplitValue,NextValue)

#def SplitSection(stuId,sptNum):
#    # Prepocessing
#    ListLen = len(CommonVideo.video_order[stuId])
#    SplitNumber = round(float(sptNum)*float(ListLen))
#    if(SplitNumber == ListLen):
#        SplitNumber = ListLen - 1
#    NextValue = CommonVideo.video_order[stuId][SplitNumber]
#    return (SplitNumber,NextValue)

def SplitSection(stuId,sptNum):
    # Prepocessing
    ListLen = len(CommonVideo.video_order[stuId])
    SplitNumber = round(sptNum*ListLen)
    if(SplitNumber == len(CommonVideo.video_order[stuId])):
        SplitNumber = len(CommonVideo.video_order[stuId]) - 1
    TestNum = SplitNumber
    NowI = 0
    for i in range(len(SplitList(stuId))):
        TestNum = TestNum - SplitList(stuId)[i][1]
        if(TestNum <=0):
            TestNum = TestNum + SplitList(stuId)[i][1]
            NowI = i
            break
    NextValue = CommonVideo.video_order[stuId][SplitNumber]
    NowSection = SplitList(stuId)[NowI][0]
    SectionTotal = SplitList(stuId)[NowI][1]
    NowPer = float(TestNum)/float(SectionTotal)
    return (SplitNumber,NowSection,NowPer,NextValue)