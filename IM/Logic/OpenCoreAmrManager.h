//
//  OpenCoreAmrManager.h
//  IM
//
//  Created by zuo guoqing on 14-10-21.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import <Foundation/Foundation.h>


int EncodeWAVEFileToAMRFile(const char* pchWAVEFilename, const char* pchAMRFileName, int nChannels, int nBitsPerSample);

// 将AMR文件解码成WAVE文件
int DecodeAMRFileToWAVEFile(const char* pchAMRFileName, const char* pchWAVEFilename);

@interface OpenCoreAmrManager : NSObject
+ (int)amrToWav:(NSString*)_amrPath wavSavePath:(NSString*)_savePath;

+ (int)wavToAmr:(NSString*)_wavPath amrSavePath:(NSString*)_savePath;
@end



