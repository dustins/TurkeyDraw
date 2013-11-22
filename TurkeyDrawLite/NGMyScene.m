//
//  NGMyScene.m
//  TurkeyDraw
//
//  Created by Dustin Sweigart on 11/20/13.
//  Copyright (c) 2013 Dustin Sweigart. All rights reserved.
//

#import "NGMyScene.h"

@implementation NGMyScene

@synthesize texture;
@synthesize shouldDraw;
@synthesize counter;
@synthesize turkeyNode;
@synthesize turkeyCount;
@synthesize targetTurkeyCount;
@synthesize labelNode;
@synthesize labelTurkeyCount;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        turkeyNode = [SKNode node];
        [self addChild:turkeyNode];
        
        shouldDraw = false;
        turkeyCount = 0;
        targetTurkeyCount = 100;
        
        labelNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelNode.text = @"";
        labelNode.fontSize = 16;
        labelNode.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        [self addChild:self.labelNode];
        
        labelTurkeyCount = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelTurkeyCount.text = [NSString stringWithFormat:@"%i tps", targetTurkeyCount];
        labelTurkeyCount.fontSize = 12;
        labelTurkeyCount.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        [self addChild:labelTurkeyCount];
        
        texture = [SKTexture textureWithImageNamed:@"turkey"];
    }
    
    return self;
}

- (void)addTurkeyNode {
    if (!shouldDraw) {
        return;
    }
    
    for (int i=0; i<(targetTurkeyCount-turkeyCount); i++) {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:texture];
        sprite = [self randomize:sprite];
        
        [self performSelector:@selector(addSprite:) withObject:sprite afterDelay:(float)rand()/RAND_MAX*1];
        
        turkeyCount++;
    }
    
    [self performSelector:@selector(addTurkeyNode) withObject:Nil afterDelay:1];
}

- (void)addSprite:(SKNode *)sprite {
    [self.turkeyNode addChild:sprite];
}

- (SKSpriteNode *)randomize:(SKSpriteNode *)sprite {
    sprite.position = CGPointMake((self.size.width) * ((float)rand()/RAND_MAX), (self.size.height) * ((float)rand()/RAND_MAX));
    sprite.scale = .15;
    sprite.alpha = 0;
    sprite.color = [SKColor colorWithCGColor:[[UIColor colorWithRed:1*((float)rand()/RAND_MAX) green:1*((float)rand()/RAND_MAX)blue:1*((float)rand()/RAND_MAX) alpha:1.0] CGColor]];
    sprite.colorBlendFactor = 1.0;
    
    NSTimeInterval duration = 0.25 * ((float)rand()/RAND_MAX) + 0.75;
    SKAction *effects = [SKAction group:@[
                                          [SKAction fadeAlphaTo:0.05 duration:duration],
                                          [SKAction scaleTo:0 duration:duration],
                                          [SKAction rotateToAngle:((float)rand()/RAND_MAX)*(M_PI/3)-M_PI/6 duration:duration shortestUnitArc:true]
                                          ]];
    
    [sprite runAction:[SKAction sequence:@[
        [SKAction runBlock:^{
            counter++;
        }],
        [SKAction fadeInWithDuration:0],
        effects,
        [SKAction runBlock:^{
            BOOL shouldRemove = (int)[[NSDate date] timeIntervalSince1970] % 2 == 0;
            if (!shouldDraw || (turkeyCount > targetTurkeyCount && shouldRemove)) {
                [sprite removeFromParent];
                turkeyCount--;
            } else {
                [self randomize:sprite];
            }
        }]
    ]]];
    
    return sprite;
}

-(void)update:(CFTimeInterval)currentTime {
    if (counter > 0) {
        labelNode.text = [NSString stringWithFormat:@"%i turkeys!", counter];
    }
}

- (void)displayGestureForPanRecognizer:(UIPanGestureRecognizer *)recognizer {
    targetTurkeyCount+= (int)([recognizer velocityInView:self.view].y * -1 / 100);
    if (targetTurkeyCount < 10) {
        targetTurkeyCount = 10;
    }
    
    labelTurkeyCount.text = [NSString stringWithFormat:@"%i tps", targetTurkeyCount];
}

- (void)displayGestureForTapRecognizer:(UITapGestureRecognizer *)recognizer {
    shouldDraw = !shouldDraw;
    [self addTurkeyNode];
}

- (void)didMoveToView:(SKView *)view {
    UIPanGestureRecognizer *panRecognizer =[[UIPanGestureRecognizer alloc] initWithTarget:self action:(@selector(displayGestureForPanRecognizer:))];
    panRecognizer.maximumNumberOfTouches = 1;
    panRecognizer.minimumNumberOfTouches = 1;
    [view addGestureRecognizer:panRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:(@selector(displayGestureForTapRecognizer:))];
    tapRecognizer.numberOfTapsRequired = 2;
    [view addGestureRecognizer:tapRecognizer];
}

@end
