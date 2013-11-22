//
//  NGMyScene.h
//  TurkeyDraw
//

//  Copyright (c) 2013 Dustin Sweigart. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface NGMyScene : SKScene

@property (retain) SKTexture *texture;
@property (atomic) BOOL shouldDraw;
@property (atomic) int counter;
@property (atomic) int turkeyCount;
@property (atomic) int targetTurkeyCount;
@property (retain) SKNode *turkeyNode;
@property (retain) SKLabelNode *labelNode;
@property (retain) SKLabelNode *labelTurkeyCount;

@end
