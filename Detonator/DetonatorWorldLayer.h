//
//  DetonatorWorldLayer.h
//  Detonator
//
//  Created by Thomas DiZoglio on 4/1/12.
//  Copyright Virgil Software 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import <AVFoundation/AVFoundation.h>

// DetonatorWorldLayer
@interface DetonatorWorldLayer : CCLayer
{
    NSInteger   showType;
    BOOL        bShattered;
    NSArray     *icons;
    AVAudioPlayer *sound1;
    AVAudioPlayer *sound2;
    AVAudioPlayer *sound3;
}

@property (nonatomic, retain) NSArray *icons;
@property (nonatomic, retain) AVAudioPlayer *sound1;
@property (nonatomic, retain) AVAudioPlayer *sound2;
@property (nonatomic, retain) AVAudioPlayer *sound3;

// returns a CCScene that contains the DetonatorWorldLayer as the only child
+(CCScene *) scene;

- (void)doShowSprite;
- (void)doBackgroundShatter;
- (void)doIconShatter:(NSString *)icon_image tag:(int)tag stag:(int)stag pt_x:(int)x pt_y:(int)y;
-(NSMutableArray*) dataFromPlist:(NSString *) filename;
- (void)removeEverything;

@end
