//
//  UIView+ZHFrame.m
//  Test1
//
//  Created by 张行 on 15/12/24.
//  Copyright © 2015年 张行. All rights reserved.
//

#import "UIView+ZHFrame.h"

@implementation UIView (ZHFrame)
-(CGFloat)ZH_minX{
    return CGRectGetMinX(self.frame);
}
-(CGFloat)ZH_minY{
    return CGRectGetMaxY(self.frame);
}
-(CGFloat)ZH_midX{
    return CGRectGetMidX(self.frame);
}
-(CGFloat)ZH_midY{
    return CGRectGetMidY(self.frame);
}
-(CGFloat)ZH_mixX{
    return CGRectGetMaxX(self.frame);
}
-(CGFloat)ZH_mixY{
    return CGRectGetMaxY(self.frame);
}
-(CGFloat)ZH_width{
    return CGRectGetWidth(self.frame);
}
-(CGFloat)ZH_height{
    return CGRectGetHeight(self.frame);
}
@end
