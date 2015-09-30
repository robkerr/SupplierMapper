//
//  MyProtocols.h
//  Created by Rob Kerr on 3/25/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.

#ifndef GreenMountainDemo_MyProtocols_h
#define GreenMountainDemo_MyProtocols_h


@protocol EmbeddedSceenDelegate

@optional
-(void)childClosingItself:(int)whichForm;
-(void)gotoOtherForm:(int)whichForm;
@end


#endif
