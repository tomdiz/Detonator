//
//  DetonatorWorldLayer.m
//  Detonator
//
//  Created by Thomas DiZoglio on 4/1/12.
//  Copyright Virgil Software 2011. All rights reserved.
//


// Import the interfaces
#import "DetonatorWorldLayer.h"
#import "ShatteredSprite.h"

#define CAMERA_ICON_TAG     97
#define CAMERA_ICON_S_TAG   96
#define NAV_ICON_TAG  95
#define NAV_ICON_S_TAG  94

// DetonatorWorldLayer implementation
@implementation DetonatorWorldLayer

@synthesize icons;
@synthesize sound1;
@synthesize sound2;
@synthesize sound3;

+(NSString *) getAppVersionNumber
{
    NSString    *myVersion, *buildNum, *versText;
    
    myVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    buildNum = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
    if (myVersion) {
        if (buildNum)
            versText = [NSString stringWithFormat:@"Version: %@ (%@)", myVersion, buildNum];
        else
            versText = [NSString stringWithFormat:@"Version: %@", myVersion];
    }
    else if (buildNum)
        versText = [NSString stringWithFormat:@"Version: %@", buildNum];

    return versText;
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	DetonatorWorldLayer *layer = [DetonatorWorldLayer node];
	
    layer.isTouchEnabled = YES;
    
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void)registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [self convertTouchToNodeSpace:touch];

    for (NSDictionary *icon in icons) {
        int tag = [[icon objectForKey:@"tag"] intValue];
        CCNode *node = [self getChildByTag:tag];
        if (CGRectContainsPoint(node.boundingBox, location)) {
            NSString *pngName = [icon objectForKey:@"png_name"];
            int x = [[icon objectForKey:@"x"] intValue];
            int y = [[icon objectForKey:@"y"] intValue];
            int stag = [[icon objectForKey:@"stag"] intValue];
            [self doIconShatter:pngName tag:tag stag:stag pt_x:x pt_y:y];
            return YES;
        }
    }
    
    if (bShattered == NO) {        
		[self doBackgroundShatter];
        bShattered = YES;
    }
    else {
        [self removeEverything];
		[self doShowSprite];
        bShattered = NO;
    }

    // default to not consume touch
    return NO;
}

- (void)doShowSprite {
	CCSprite *sprite = [CCSprite spriteWithFile:@"background.png"];
	sprite.position = ccp(160, 240);
	[self addChild:sprite z:1 tag:98];	

    icons = [[self dataFromPlist:@"icon_layout"] retain];

    for (NSDictionary *icon in icons) {
        NSString *pngName = [icon objectForKey:@"png_name"];
        int x = [[icon objectForKey:@"x"] intValue];
        int y = [[icon objectForKey:@"y"] intValue];
        int tag = [[icon objectForKey:@"tag"] intValue];
        CCSprite *sprite = [CCSprite spriteWithFile:pngName];
        sprite.position = ccp(x, y);
        [self addChild:sprite z:2 tag:tag];	
    }
}

- (void)removeEverything {
	//Remove any previous ones
	[self removeChildByTag:98 cleanup:YES];
	[self removeChildByTag:99 cleanup:YES];

    for (NSDictionary *icon in icons) {
        int tag = [[icon objectForKey:@"tag"] intValue];
        [self removeChildByTag:tag cleanup:YES];
    }
}

- (void)doBackgroundShatter {
	//Remove any previous ones
	[self removeChildByTag:98 cleanup:YES];
	[self removeChildByTag:99 cleanup:YES];
	
	ShatteredSprite	*shatter;
	if (showType==0) {
		shatter = [ShatteredSprite shatterWithSprite:[CCSprite spriteWithFile:@"background.png"] piecesX:4 piecesY:5 speed:2.0 rotation:0.01 radial:YES];	
        shatter.position = ccp(160, 240);
        [shatter runAction:[CCEaseSineIn actionWithAction:[CCMoveBy actionWithDuration:5.0 position:ccp(0, -1000)]]];
        shatter.subShatterPercent = 100;
	} else if (showType==1) {
		shatter = [ShatteredSprite shatterWithSprite:[CCSprite spriteWithFile:@"background.png"] piecesX:2 piecesY:2 speed:0.2 rotation:0.01 radial:NO];	
        shatter.position = ccp(160, 240);
        [shatter runAction:[CCEaseSineIn actionWithAction:[CCMoveBy actionWithDuration:5.0 position:ccp(0, -1000)]]];
        shatter.subShatterPercent = 100;
	} else if (showType==2) {
		shatter = [ShatteredSprite shatterWithSpriteSlow:[CCSprite spriteWithFile:@"background.png"] piecesX:5 piecesY:7 speed:0.2 rotation:0.01 radial:NO fallPerSec:10];	
        shatter.position = ccp(160, 240);
        shatter.gravity = ccp(0, -0.5);
        shatter.subShatterPercent = 0;
	} 
	[self addChild:shatter z:1 tag:99];	
    
    //Show each type in a loop...
    showType = (showType+1)%3;
}

- (void)doIconShatter:(NSString *)icon_image tag:(int)tag stag:(int)stag pt_x:(int)x pt_y:(int)y {
	//Remove any previous ones
	[self removeChildByTag:tag cleanup:YES];
	[self removeChildByTag:stag cleanup:YES];

	ShatteredSprite	*shatter;
	if (showType==0) {
		shatter = [ShatteredSprite shatterWithSprite:[CCSprite spriteWithFile:icon_image] piecesX:4 piecesY:5 speed:2.0 rotation:0.01 radial:YES];	
        shatter.position = ccp(x, y);
        [shatter runAction:[CCEaseSineIn actionWithAction:[CCMoveBy actionWithDuration:5.0 position:ccp(0, -1000)]]];
        shatter.subShatterPercent = 100;
        
        [sound1 play];
    } else if (showType==1) {
		shatter = [ShatteredSprite shatterWithSprite:[CCSprite spriteWithFile:icon_image] piecesX:2 piecesY:2 speed:0.2 rotation:0.01 radial:NO];	
        shatter.position = ccp(x, y);
        [shatter runAction:[CCEaseSineIn actionWithAction:[CCMoveBy actionWithDuration:5.0 position:ccp(0, -1000)]]];
        shatter.subShatterPercent = 100;
        
        [sound2 play];
	} else if (showType==2) {
		shatter = [ShatteredSprite shatterWithSpriteSlow:[CCSprite spriteWithFile:icon_image] piecesX:5 piecesY:7 speed:0.2 rotation:0.01 radial:NO fallPerSec:10];	
        shatter.position = ccp(x, y);
        shatter.gravity = ccp(0, -0.5);
        shatter.subShatterPercent = 0;
        
        [sound3 play];
	} 
	[self addChild:shatter z:2 tag:stag];	
    
    //Show each type in a loop...
    showType = (showType+1)%3;
}

-(id) init {

	if( (self=[super init])) {
        NSString *verText = [DetonatorWorldLayer getAppVersionNumber];
        
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Detonator" fontName:@"Marker Felt" fontSize:64];
		CCLabelTTF *resetLabel = [CCLabelTTF labelWithString:@"[Press to Reset]" fontName:@"Arial" fontSize:18];
		CCLabelTTF *versionLabel = [CCLabelTTF labelWithString:verText fontName:@"Arial" fontSize:14];
		CGSize size = [[CCDirector sharedDirector] winSize];
		label.position =  ccp( size.width /2 , size.height/2 );
		resetLabel.position =  ccp( size.width /2 , size.height/2 - 60 );
		versionLabel.position =  ccp( size.width /2 , size.height/2 - 80 );
		[self addChild: label];
		[self addChild: resetLabel];
		[self addChild: versionLabel];
        [self doShowSprite];
        bShattered = NO;

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"glass_breaking_1" ofType: @"aiff"];        
        if ([fileManager fileExistsAtPath:soundFilePath])
        { 
            NSURL *fileURL = [[[NSURL alloc] initFileURLWithPath:soundFilePath] autorelease];
            sound1 = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
            [sound1 setVolume:1.0f];
            soundFilePath = [[NSBundle mainBundle] pathForResource:@"glass_breaking_2" ofType: @"aiff"];        
            fileURL = [[[NSURL alloc] initFileURLWithPath:soundFilePath] autorelease];
            sound2 = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
            [sound2 setVolume:1.0f];
            soundFilePath = [[NSBundle mainBundle] pathForResource:@"glass_breaking_3" ofType: @"aiff"];        
            fileURL = [[[NSURL alloc] initFileURLWithPath:soundFilePath] autorelease];
            sound3 = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
            [sound3 setVolume:1.0f];
        }
    }
	return self;
}

- (void) dealloc {
	[super dealloc];
    [icons release], icons = nil;
}

-(NSArray*) dataFromPlist:(NSString *) filename
{
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    NSLog(@"plist = %@", path);
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile: path];
    NSArray *array = [NSArray arrayWithArray:[dict objectForKey:@"icons"]];
    return array;
}

@end
