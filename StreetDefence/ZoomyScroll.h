//
//  ZoomyScroll.h
//  StreetDefence
//
//  Created by Freddie on 29/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomyScroll : UIScrollView {
    NSObject *parent;
}

- (id) initWithFrame:(CGRect)frame Parent:(NSObject*)_parent;

@end
