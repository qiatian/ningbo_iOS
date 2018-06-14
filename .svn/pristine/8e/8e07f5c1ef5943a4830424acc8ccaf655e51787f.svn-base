//
//  fileclass.m
//  TrainConference
//
//  Created by 季 海萍 on 13-10-28.
//  Copyright (c) 2013年 季 海萍. All rights reserved.
//

#import "fileclass.h"

@implementation fileclass
@synthesize name;
@synthesize time;
@synthesize url;
@synthesize size;



//把类实例里的内容编码到xml文件中
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:name    forKey:@"name"];
    [aCoder encodeObject:time   forKey:@"time"];
    [aCoder encodeObject:url   forKey:@"url"];
    [aCoder encodeObject:size   forKey:@"size"];
    
    return;
}

//把xml文件内容解码到类实例中

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.time = [aDecoder decodeObjectForKey:@"time"];
    self.url = [aDecoder decodeObjectForKey:@"url"];
    self.size = [aDecoder decodeObjectForKey:@"size"];
    
    return self;
}

@end
