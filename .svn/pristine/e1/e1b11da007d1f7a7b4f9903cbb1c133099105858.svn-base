//
//  LKStoreTableViewCell.m
//  IM
//
//  Created by  pipapai_tengjun on 15/7/6.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "NewsLeaderTableViewCell.h"

#define KModeWith   [UIScreen mainScreen].bounds.size.width/3

#define IconWidth    83
#define IconHegith   42

#define RowDefaultTag  100000

@implementation NewsLeaderTableViewCell
@synthesize titleLabel1,logoImageView1,lineImageView1,button1,titleLabel2,titleLabel3,logoImageView2,logoImageView3,lineImageView2,button2,button3,delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, KModeWith-36, KModeWith, 18)];
        titleLabel1.textAlignment = NSTextAlignmentCenter;
        titleLabel1.textColor = [UIColor hexChangeFloat:@"848686"];
        titleLabel1.backgroundColor = [UIColor clearColor];
        titleLabel1.font = [UIFont systemFontOfSize:18.0f];
        [self.contentView addSubview:titleLabel1];
        
        logoImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake((KModeWith-IconWidth)/2, titleLabel1.frame.origin.y - IconHegith - 20, IconWidth, IconHegith)];
        logoImageView1.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:logoImageView1];
        
        lineImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(KModeWith-0.5, 0, 0.5, KModeWith)];
        lineImageView1.backgroundColor = [UIColor hexChangeFloat:@"DBDDDD"];
        [self.contentView addSubview:lineImageView1];
        
        button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.backgroundColor = [UIColor clearColor];
        [button1 addTarget:self action:@selector(modeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button1.frame = CGRectMake(0, 0, KModeWith, KModeWith);
        [self.contentView addSubview:button1];
        
        
        titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(KModeWith, KModeWith-36, KModeWith, 18)];
        titleLabel2.textAlignment = NSTextAlignmentCenter;
        titleLabel2.textColor = [UIColor hexChangeFloat:@"848686"];
        titleLabel2.backgroundColor = [UIColor clearColor];
        titleLabel2.font = [UIFont systemFontOfSize:18.0f];
        [self.contentView addSubview:titleLabel2];
        
        logoImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(KModeWith+(KModeWith-IconWidth)/2, titleLabel1.frame.origin.y - IconHegith - 20, IconWidth, IconHegith)];
        logoImageView2.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:logoImageView2];
        
        lineImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(KModeWith*2-0.5, 0, 0.5, KModeWith)];
        lineImageView2.backgroundColor = [UIColor hexChangeFloat:@"DBDDDD"];
        [self.contentView addSubview:lineImageView2];
        
        button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.backgroundColor = [UIColor clearColor];
        [button2 addTarget:self action:@selector(modeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button2.frame = CGRectMake(KModeWith, 0, KModeWith, KModeWith);
        [self.contentView addSubview:button2];

        
        titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(KModeWith*2, KModeWith-36, KModeWith, 18)];
        titleLabel3.textAlignment = NSTextAlignmentCenter;
        titleLabel3.textColor = [UIColor hexChangeFloat:@"848686"];
        titleLabel3.backgroundColor = [UIColor clearColor];
        titleLabel3.font = [UIFont systemFontOfSize:18.0f];
        [self.contentView addSubview:titleLabel3];
        
        logoImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(KModeWith*2+(KModeWith-IconWidth)/2, titleLabel1.frame.origin.y - IconHegith - 20, IconWidth, IconHegith)];
        logoImageView3.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:logoImageView3];
        
        button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        button3.backgroundColor = [UIColor clearColor];
        [button3 addTarget:self action:@selector(modeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button3.frame = CGRectMake(KModeWith*2, 0, KModeWith, KModeWith);
        [self.contentView addSubview:button3];
    }
    return self;
}

- (void)loadDataWithTitleName:(NSArray *)titleArray ImageName:(NSArray *)imageArray IndexPath:(NSIndexPath *)path{
    button1.tag = RowDefaultTag*path.section+0;
    button2.tag = RowDefaultTag*path.section+1;
    button3.tag = RowDefaultTag*path.section+2;
    
    titleLabel1.text = [titleArray objectAtIndex:0];
    logoImageView1.image = [UIImage imageNamed:imageArray[0]];
    
    titleLabel2.text = [titleArray objectAtIndex:1];
    logoImageView2.image = [UIImage imageNamed:imageArray[1]];

    titleLabel3.text = [titleArray objectAtIndex:2];
    logoImageView3.image = [UIImage imageNamed:imageArray[2]];
}

- (void)modeButtonClick:(UIButton *)sender{
    if([delegate respondsToSelector:@selector(didButtonClicked:)])
    {
        NSInteger section = sender.tag/RowDefaultTag;
        NSInteger row = sender.tag%RowDefaultTag;
        NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
        [delegate didButtonClicked:path];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
