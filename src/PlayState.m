//
//  PlayState.m
//  Canabalt
//
//  Copyright Semi Secret Software 2009-2010. All rights reserved.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "PlayState.h"

#import "Sequence.h"
#import "Walker.h"
#import "BG.h"
#import "Jet.h"
#import "Player.h"
#import "Shard.h"
#import "Smoke.h"
#import "BG.h"

#import "HUD.h"

#import "MenuState.h"

static NSString * SndCrumble = @"crumble.caf";

static NSString * ImgMidground1 = @"midground1-trimmed.png";
static NSString * ImgMidground2 = @"midground2-trimmed.png";
static NSString * ImgBackground = @"background-trimmed.png";
static NSString * ImgMidground1IPad = @"ipad/midground1-trimmed.png";
static NSString * ImgMidground2IPad = @"ipad/midground2-trimmed.png";
static NSString * ImgBackgroundIPad = @"ipad/background-trimmed.png";
static NSString * ImgMothership = @"mothership-filled.png";
static NSString * ImgDarkTower = @"dark_tower-filled.png";
static NSString * ImgGirder1 = @"girder-tall.png";
static NSString * ImgGameOver = @"gameover.png";

static NSString * ImgPauseButton = @"pause.png";
static NSString * ImgPaused = @"paused.png";

static NSString * ImgExitOn = @"gameover_exit_on.png";
static NSString * ImgExitOff = @"gameover_exit_off.png";

#define GLASS_SHARDS
#define SMOKE

static CGRect pauseRect = { .origin = { .x = 0, .y = 0 },
			    .size = { .width = 50, .height = 50 }
};


@implementation PlayState

- (id) init
{
  if ((self = [super init])) {
    self.bgColor = 0xffb0b0bf;
    [[FlxG quake] setScale:CGPointMake(0, 1)];
  }
  return self;
}

- (void) doPause
{
  paused = YES;
  fadedSprite.visible = YES;
  pausedSprite.visible = YES;
  pauseButton.visible = NO;
  [FlxG pauseMusic];
}

- (void) setPaused:(BOOL)gamePaused;
{
  if (gamePaused) {
    [self doPause];
    //maybe do this on the next iteration?
    FlxG.pauseFollow = YES;
    player.pause = YES;
  }
}


- (void) create;
{

  firstTimeThroughUpdateLoop = YES;
  reallyJustPaused = NO;

  pauseVisibility = YES;

  int i;
  FlxSprite * s;

  //Far BG 'Easter Egg' objects
  s = [FlxSprite spriteWithGraphic:ImgMothership];
  s.enableBlend = NO;
  s.x = 900;
  s.scrollFactor = CGPointMake(0.015, 0);
  [self add:s];
  s = [FlxSprite spriteWithGraphic:ImgDarkTower];
  s.enableBlend = NO;
  s.x = 1700;
  s.scrollFactor = CGPointMake(0.015,0);
  [self add:s];

  FlxEmitter * e;


#ifdef SMOKE
  smoke = [NSMutableArray array];

  if (!FlxG.iPhone1G && !FlxG.iPodTouch1G) {
    int numSmokes = 4;
    if (FlxG.iPad)
      numSmokes = 8;
    if (FlxG.iPhone3G)
      numSmokes = 1;
    for (i=0; i<numSmokes; ++i) {
      int num_clouds = 15;
      if (FlxG.iPad)
	num_clouds = 25;
      if (FlxG.iPhone3G)
	num_clouds = 7;

      e = [SmokeEmitter smokeEmitterWithSmokeCount:num_clouds];
      for (Smoke * s in e.members) {
        [s randomFrame];
        s.scrollFactor = CGPointMake(0.1, 0.05);
        [self add:s];
      }
      
      e.delay = 0.6;
      e.minParticleSpeed = CGPointMake(-3,-15);
      e.maxParticleSpeed = CGPointMake(3,-15);
      if(FlxG.iPhone3G || FlxG.iPhone1G || FlxG.iPodTouch1G)
      {
        e.minRotation = 0;
        e.maxRotation = 0;
      }
      else
      {
        e.minRotation = -30;
        e.maxRotation = 30;
      }
      e.gravity = 0;
      e.particleDrag = CGPointMake(0,0);
      [self add:e];
      [smoke addObject:e];
    }
    [self add:[Walker walkerWithSmoke:smoke]];
    if (!FlxG.iPhone3G)
      [self add:[Walker walkerWithSmoke:smoke]];
  }
#endif

  BG * mg;
  FlxSprite * bg; //for solid background rectangle...
  if (FlxG.iPad)
    mg = [BG bgWithImage:ImgBackgroundIPad];
  else
    mg = [BG bgWithImage:ImgBackground];

  mg.x = 0;
  mg.y = 30;
  mg.scrollFactor = CGPointMake(0.15, 0.25);
  mg.y += 36;
  [self add:mg];
  background = mg;
  if (FlxG.iPad)
    mg = [BG bgWithImage:ImgBackgroundIPad];
  else
    mg = [BG bgWithImage:ImgBackground];
  mg.x = FlxG.width;
  mg.y = 30;
  mg.y += 36;
  mg.scrollFactor = CGPointMake(0.15, 0.25);
  [self add:mg];
  //add below - since these are trimmed images
  bg = [FlxSprite spriteWithX:0 y:30+36+48 graphic:nil];
  if (FlxG.iPad)
    [bg createGraphicWithParam1:FlxG.width param2:156 param3:0x868696];
  else
    [bg createGraphicWithParam1:FlxG.width param2:76+12 param3:0x868696];
  bg.scrollFactor = CGPointMake(0, 0.25); //don't scroll in the x direction at all!
  bg.enableBlend = NO;
  [self add:bg];
  backgroundRect = bg;
  
  if (FlxG.iPad)
    mg = [BG bgWithImage:ImgMidground1IPad];
  else
    mg = [BG bgWithImage:ImgMidground1];
  mg.x = 0;
  mg.y = 104+8;
  mg.scrollFactor = CGPointMake(0.4, 0.5);
  [self add:mg];
  midground = mg;
  if (FlxG.iPad)
    mg = [BG bgWithImage:ImgMidground2IPad];
  else
    mg = [BG bgWithImage:ImgMidground2];
  if (FlxG.iPad)
    mg.x = 512;
  else
    mg.x = 480;
  mg.y = 104+8;
  mg.scrollFactor = CGPointMake(0.4, 0.5);
  [self add:mg];
  bg = [FlxSprite spriteWithX:0 y:104+8+97 graphic:nil];
  [bg createGraphicWithParam1:FlxG.width param2:223 param3:0x646A7D];
  bg.scrollFactor = CGPointMake(0, 0.5); //don't scroll in the x direction at all!
  bg.enableBlend = NO;
  [self add:bg];
  
  [self add:[Jet jet]];

  focus = [[[FlxObject alloc] initWithX:0 y:0 width:1 height:1] autorelease];
  [FlxG followWithParam1:focus param2:15];
  [FlxG followBoundsWithParam1:0 param2:0 param3:INT_MAX param4:480];
  [FlxG followAdjustWithParam1:1.5 param2:0];

  player = [Player player];

  //Infinite level sequence objects
#ifdef GLASS_SHARDS
  int numShards = 40;
  if (FlxG.iPad || FlxG.retinaDisplay)
    numShards = 80;
  if (FlxG.iPhone1G)
    numShards = 20;
#else
  int numShards = 0;
#endif

  shardsA = [ShardEmitter shardEmitterWithShardCount:numShards];
  shardsB = [ShardEmitter shardEmitterWithShardCount:numShards];

  [Sequence setCurIndex:0];
  [Sequence setNextIndex:(int)([FlxU random]*3+3)];
  [Sequence setNextType:1];

  seqA = [Sequence sequenceWithPlayer:player shardsA:shardsA shardsB:shardsB];
  seqB = [Sequence sequenceWithPlayer:player shardsA:shardsA shardsB:shardsB];
  [self add:seqA];
  [self add:seqB];
  [seqA initSequence:seqB];
  [seqB initSequence:seqA];

  [self add:shardsA];
  [self add:shardsB];

  [self add:player];

  if (!([FlxG iPhone3G] || [FlxG iPhone1G] || [FlxG iPodTouch1G])) {
    mg = [BG bgWithImage:ImgGirder1];
    mg.random = YES;
    mg.x = 3000;
    mg.y = 0;
    mg.scrollFactor = CGPointMake(3, 0);
    [self add:mg];
  }
  mg = [BG bgWithImage:nil];
  [mg createGraphicWithWidth:32 height:FlxG.height color:0x35353d];
  mg.enableBlend = NO;
  mg.random = YES;
  mg.x = 3000;
  mg.y = 0;
  mg.scrollFactor = CGPointMake(4, 0);
  [self add:mg];
  
  dist = [HUD hudWithFrame:CGRectMake(FlxG.width-80-5,2+3,80,16)];
  dist.scrollFactor = CGPointMake(0, 0);
  dist.distance = 0;
  [self add:dist];

  //need this to be above everything else
  pauseButton = [FlxSprite spriteWithGraphic:ImgPauseButton];
  pauseButton.x = 8;
  pauseButton.y = 6;
  pauseButton.scrollFactor = CGPointMake(0, 0);
  if (pauseVisibility == NO)
    pauseButton.visible = NO;
  [self add:pauseButton];
  
  fadedSprite = [FlxSprite spriteWithX:0 y:0 graphic:nil];
  [fadedSprite createGraphicWithWidth:FlxG.width height:FlxG.height color:0xffffff];
  fadedSprite.scrollFactor = CGPointMake(0, 0);
  fadedSprite.alpha = 0.5;
  fadedSprite.visible = NO;
  [self add:fadedSprite];

  pausedSprite = [FlxSprite spriteWithGraphic:ImgPaused];
  pausedSprite.x = ([FlxG width]-pausedSprite.width)/2;
  pausedSprite.y = ([FlxG height]-pausedSprite.height)/2;
  pausedSprite.scrollFactor = CGPointMake(0, 0);
  pausedSprite.visible = NO;
  [self add:pausedSprite];
  paused = NO;

  if (FlxG.iPad)
    [[FlxG quake] startWithIntensity:0.007 duration:3.1];
  else
    [[FlxG quake] startWithIntensity:0.0065 duration:2.5];

  gameover = 0;

  [FlxG play:SndCrumble];

}

- (void) update
{
  if (reallyJustPaused) {
    [self doPause];
  }
  reallyJustPaused = NO;

  //check for pause touch
  if (gameover == 0) {
    if (!paused) {
      if (FlxG.touches.touchesBegan &&
	  CGRectContainsPoint(pauseRect, FlxG.touches.screenTouchBeganPoint) &&
	  !firstTimeThroughUpdateLoop) {
 	justPaused = YES;
	reallyJustPaused = YES;
	FlxG.pauseFollow = YES;
	player.pause = YES;
      }
    } else {
      if (FlxG.touches.touchesEnded) {
	if (justPaused) {
	  justPaused = NO;
	} else {
	  player.pause = NO;
	  paused = NO;
	  fadedSprite.visible = NO;
	  pausedSprite.visible = NO;
	  if (pauseVisibility == YES)
	    pauseButton.visible = YES;
	  //start following again
	  FlxG.pauseFollow = NO;
	  [FlxG unpauseMusic];
	}
      }
    }
  }

  if (pressedExit) {
    //still touching?
    //released in bounds?
    if (FlxG.touches.touchesEnded) {
      //switch state
      FlxG.state = [[[MenuState alloc] init] autorelease];
      return;
    }
  }
  pressedExit = NO;

  if (exitOn && exitOff) {
    exitOff.visible = YES;
    exitOn.visible = NO;
  }
  
  if (gameover > 0)
    gameover += FlxG.elapsed;
  if (gameover > 0.35 &&
      FlxG.touches.touching) {

    BOOL switchState = YES;

    if (exitOn && exitOff) {
      if (CGRectContainsPoint(CGRectInset(CGRectMake(exitOff.x, exitOff.y, exitOff.width, exitOff.height), -20, -20), FlxG.touches.screenTouchPoint)) {
 	//pressing button
 	exitOff.visible = NO;
 	exitOn.visible = YES;
 	pressedExit = YES;
	switchState = NO;
      }
    }

    if (switchState) {
      FlxG.state = [[[PlayState alloc] init] autorelease];
      return;
    }
  }

  focus.x = player.x + FlxG.width*0.5;
  focus.y = player.y + FlxG.height*0.18 + (player.onFloor ? 0 : 20);

  BOOL wasDead = player.dead;

  //only do this if we aren't paused...
  if (!paused)
    [super update];

  
  [FlxU collideObject:player withGroup:seqA.blocks];
  [FlxU collideObject:player withGroup:seqB.blocks];

  if(FlxG.iPad)
  {
    [FlxU alternateCollideWithParam1:seqA.blocks param2:shardsA];
    [FlxU alternateCollideWithParam1:seqA.blocks param2:shardsB];
    [FlxU alternateCollideWithParam1:seqB.blocks param2:shardsA];
    [FlxU alternateCollideWithParam1:seqB.blocks param2:shardsB];
  }
  else
  {
    Sequence* sq = (seqA.x < seqB.x)?seqA:seqB;
    FlxEmitter* sh;
    if(shardsA.exists && shardsB.exists)
      sh = (shardsA.x > shardsB.x)?shardsA:shardsB;
    else if(shardsB.exists)
      sh = shardsB;
    else
      sh = shardsA;
    [FlxU alternateCollideWithParam1:sq.blocks param2:sh];
  }

  dist.distance = (int)(player.x/10);

  if (player.dead && !wasDead) {

    //hide pause button
    pausedSprite.visible = NO;
    fadedSprite.visible = NO;
    pauseButton.visible = NO;
    
    distance = player.x/10;
    
    //Write player's epitaph based on special events and/or the environmental context
    if([player.epitaph compare:@"bomb"] == NSOrderedSame)
      player.epitaph = @"\nturning into a fine mist.";
    else if([player.epitaph compare:@"hit"] == NSOrderedSame)
    {
      if (distance < 105) {
        player.epitaph = @"just barely\nstumbling out of the first hallway.";
      }
      else {
        //ran into the front of the sequence in question
        Sequence * s;
        if(seqA.x < seqB.x) s = seqA;
        else s = seqB;
        int type = [s getType];
        switch(type)
        {
          case 1: //hallway
            player.epitaph = @"\nmissing another window.";
            break;
          case 2: //collapse
            player.epitaph = @"\nknocking a building down.";
            break;
          case 4: //crane
            player.epitaph = @"somehow\nhitting the edge of a crane.";
            break;
          case 5: //billboard
            player.epitaph = @"somehow\nhitting the edge of a billboard.";
            break;
          case 6: //leg
            player.epitaph = @"colliding\nwith some enormous obstacle.";
            break;
          default: //basic wall case
            player.epitaph = @"hitting\na wall and tumbling to your death.";
            break;
        }
      }
    }
    else {
      //fell off the screen
      int preType = [seqA lastType]; //These are static, player-dependent values
      int type = [seqA thisType];
      if(type > 0)
      {
        switch(type)
        {
          case 1: //hallway
            player.epitaph = @"completely\n missing the entire hallway.";
            break;
          case 4: //crane
            player.epitaph = @"\nmissing a crane completely.";
            break;
          case 5: //billboard
            player.epitaph = @"not\nquite reaching a billboard.";
            break;
          case 6: //leg
            player.epitaph = @"landing\nwhere a building used to be.";
            break;
          default: //basic fall case
            player.epitaph = @"\nfalling to your death.";
            break;            
        }
      }
      else {
        switch(preType)
        {
          case 1: //hallway
            player.epitaph = @"\nfalling out of a hallway.";
            break;
          case 2: //collapse
            player.epitaph = @"riding\na falling building all the way down.";
            break;
          case 3: //bomb
            player.epitaph = @"dodging\n a bomb only to miss the next roof.";
            break;
          case 4: //crane
            player.epitaph = @"\nfalling off a crane.";
            break;
          case 5: //billboard
            player.epitaph = @"\nstumbling off the edge of a billboard.";
            break;
          case 6: //leg
            player.epitaph = @"jumping\nclear over...something.";
            break;
          default: //basic fall case
            player.epitaph = @"\nfalling to your death.";
            break;            
        }
      }
    }
    //End epitaph decision tree


    //show exit button
    exitOn = [FlxSprite spriteWithGraphic:ImgExitOn];
    exitOff = [FlxSprite spriteWithGraphic:ImgExitOff];
    exitOn.x = FlxG.width-62;
    exitOn.y = 0;
    exitOn.scrollFactor = CGPointMake(0, 0);
    exitOff.x = exitOn.x;
    exitOff.y = exitOn.y;
    exitOff.scrollFactor = exitOn.scrollFactor;
    [self add:exitOn];
    [self add:exitOff];

    exitOff.visible = YES;
    exitOn.visible = NO;
    
    gameover = 0.01;
    int h = 88;
    FlxSprite * bigGray = [FlxSprite spriteWithGraphic:nil];
    [bigGray createGraphicWithParam1:FlxG.width param2:64 param3:0xff35353d];
    bigGray.x = 0;
    bigGray.y = h+35;
    bigGray.width = FlxG.width;
    bigGray.height = 64;
    bigGray.scrollFactor = CGPointMake(0, 0);
    [self add:bigGray];
    FlxSprite * littleWhite = [FlxSprite spriteWithGraphic:nil];
    [littleWhite createGraphicWithParam1:FlxG.width param2:2 param3:0xffffffff];
    littleWhite.x = 0;
    littleWhite.y = h+35+64;
    littleWhite.width = FlxG.width;
    littleWhite.height = 2;
    littleWhite.scrollFactor = CGPointMake(0, 0);
    [self add:littleWhite];
    FlxSprite * s = [FlxSprite spriteWithGraphic:nil];
    [s createGraphicWithParam1:FlxG.width param2:30 param3:0xff35353d];
    s.x = 0;
    s.y = FlxG.height-30;
    s.width = FlxG.width;
    s.height = 30;
    s.scrollFactor = CGPointMake(0, 0);
    [self add:s];
    FlxSprite * gameOver = [FlxSprite spriteWithGraphic:ImgGameOver];
    gameOver.x = ([FlxG width]-390)/2.0;
    gameOver.y = h;
    gameOver.scrollFactor = CGPointMake(0, 0);
    [self add:gameOver];
    [epitaph release];
    epitaph = [[NSString stringWithFormat:@"You ran %dm before %@", distance, player.epitaph] retain];

    FlxText * epitaphText = [FlxText textWithWidth:FlxG.width
				     text:epitaph
				     font:nil
				     size:16];
    epitaphText.x = 0;
    epitaphText.y = h+50;
    epitaphText.alignment = @"center";
    epitaphText.color = 0xffffffff;
    epitaphText.scrollFactor = CGPointMake(0, 0);
    [self add:epitaphText];

    FlxText * t;
    t = [FlxText textWithWidth:FlxG.width-3
		 text:NSLocalizedString(@"Tap to retry your daring escape.",@"Tap to retry your daring escape.")
		 font:nil
		 size:16];
    t.x = 0;
    t.y = FlxG.height-27;
    t.alignment = @"right";
    t.color = 0xffffffff;
    t.scrollFactor = CGPointMake(0, 0);
    [self add:t];
    
    dist.visible = NO;

  }

  if (firstTimeThroughUpdateLoop) {
    //don't set to no unless we aren't touching the screen
    if (FlxG.touches.touching == NO)
      firstTimeThroughUpdateLoop = NO;
  }
}

@end

