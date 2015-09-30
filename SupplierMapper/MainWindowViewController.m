//
//  MainWindowViewController.m
//  Created by Rob Kerr on 3/25/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.

#import "MainWindowViewController.h"
#import "CarouselViewController.h"
#import "MapOverlayViewController.h"


@interface MainWindowViewController ()

@end

@implementation MainWindowViewController

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
    
    // Load up the dashboard page
    self.posTrendsViewController = [[MapOverlayViewController alloc]initWithNibName:@"MainWindow_iPad" bundle:nil];
    self.posTrendsViewController.delegate = self;
    [self.view addSubview:self.posTrendsViewController.view];
    
    // On load fill this window with the carousel menu
    self.carouselViewController = [[CarouselViewController alloc] initWithNibName:@"CarouselViewController" bundle:nil];
    self.carouselViewController.delegate = self;
    [self.view addSubview:self.carouselViewController.view];
}

-(void)childClosingItself:(int)whichForm
{
    NSLog(@"Child Closing self");

    [UIView transitionFromView:self.posTrendsViewController.view toView:self.carouselViewController.view duration:0.2 options:UIViewAnimationOptionTransitionFlipFromRight completion:nil];

}

-(void)gotoOtherForm:(int)whichForm
{
    NSLog(@"Commanded to go to other form: %d", whichForm);
    
    [UIView transitionFromView:self.carouselViewController.view toView:self.posTrendsViewController.view duration:0.2 options:UIViewAnimationOptionTransitionFlipFromRight completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
