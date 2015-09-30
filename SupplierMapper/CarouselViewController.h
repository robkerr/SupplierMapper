//
//  CarouselViewController.h
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiEssentials/SEssentialsCarouselCylindrical.h>

@interface CarouselViewController : UIViewController<SEssentialsCarouselDataSource, SEssentialsCarouselDelegate>
{
    SEssentialsCarouselCylindrical *carouselControl;
}

@property(nonatomic,assign)id delegate;

@end
