//
//  CarouselViewController.m
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import "CarouselViewController.h"
#import "MyProtocols.h"
@interface CarouselViewController ()
{
    NSMutableArray *items;
}

@end

@implementation CarouselViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
/*
    CGRect gridRect = self.view.bounds;
    UIImage *img =
    [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CoffeeCup" ofType:@"jpg"]];
    UIImageView * myImageView = [[UIImageView alloc] initWithImage: img];
    [self.view addSubview:myImageView];
  */
    
    //*******************  Add the carousel view  **************
    [self createViews];
    
    CGRect r = CGRectMake(self.view.bounds.origin.x,
                         self.view.bounds.origin.y,
                         self.view.bounds.size.width,
                         self.view.bounds.size.height - 70
                         );
    carouselControl = [[SEssentialsCarouselCylindrical alloc]initWithFrame:r];
    carouselControl.dataSource = self;
    carouselControl.delegate = self;
    carouselControl.orientation = SEssentialsCarouselOrientationHorizontal;
    carouselControl.frontFacing = NO;
    carouselControl.widthRatio = 0.92;
    carouselControl.depthRatio = 0.37;
    carouselControl.itemSpacingFactor = 1.05;
    carouselControl.tiltFactor = 0.84;
    carouselControl.fadeDepth = 0.8;
    carouselControl.fadeAlpha = 0.11;
    
    
    [self.view addSubview:carouselControl];
}

-(void)createViews
{
    items = [[NSMutableArray alloc] init];
    
    NSArray *dashboardTitles = [[NSArray alloc]initWithObjects:@"Point of Sale Dashboard",
                                    @"Sales Management",
                                     @"Regional Performance",
                                     @"Employee Morale",
                                     @"Market Penetration",
                                     @"Manufacturing Efficiency",
                                     @"Audit & Compliance",
                                     @"Plant Utilization",
     nil];
    
    for (int i = 0; i < 8; i++)
    {
        CGRect gridRect = CGRectMake(0, 0, 341, 300);  // rect to contain each view
        
        UIView *viewPtr = [[UIView alloc]  initWithFrame:gridRect];
/*
        //created a Button and added to UIView
        UIButton *btnPointer = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnPointer.frame = cgframe; // provides both a position and a size
        [btnPointer setTitle:btnLabelText forState:UIControlStateNormal];
        [btnPointer addTarget:self action:@selector(generate:) forControlEvents:UIControlEventTouchUpInside];
        [viewPtr addSubview:btnPointer];
        
        //Now need to add this UIView to a controller
        self.view = viewPtr;
  */
        //**********************  Add image to the view  ****************
        NSString *dashboardImageName = [NSString stringWithFormat:@"Dashboard%d", i+1];
        
        UIImage *img =
        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:dashboardImageName ofType:@"png"]];
        /*
        UIImage *scaledImage =
        [UIImage imageWithCGImage:[img CGImage]
                            scale:(img.scale * 3.0)
                      orientation:(img.imageOrientation)];
        */
        UIImageView * myImageView = [[UIImageView alloc] initWithImage: img];
        
        [viewPtr addSubview:myImageView];
        
        //********************  Add label to the view  ***************
        CGRect rectLabel = CGRectMake(0,265,341,18);
        UILabel *lbl = [[UILabel alloc]initWithFrame:rectLabel];
        lbl.text = [dashboardTitles objectAtIndex:i];
        lbl.textColor  = [UIColor whiteColor];
        lbl.font = [UIFont fontWithName:@"Arial" size: 20.0];
        lbl.textAlignment = NSTextAlignmentCenter;
        [viewPtr addSubview:lbl];
        viewPtr.tag = i;
        
        [items addObject:viewPtr];

    }
}

-(NSUInteger)numberOfItemsInCarousel:(SEssentialsCarousel *)carousel
{
    return [items count];
}

-(UIView *)carousel:(SEssentialsCarousel *)carousel itemAtIndex:(NSInteger)index
{
    return [items objectAtIndex:index];
}

-(void)carousel:(SEssentialsCarousel *)carousel didTapItem:(UIView *)item atOffset:(CGFloat)offset
{
    NSLog(@"Tapped on Tage=%lu", (unsigned long)item.tag);
    [carousel setContentOffset:offset animated:YES withDuration:1.f];
    
    if([_delegate respondsToSelector:@selector(gotoOtherForm:)])
    {
        //send the delegate function with the amount entered by the user
        [_delegate gotoOtherForm:(int)item.tag];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
