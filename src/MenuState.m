//
//  MenuState.m
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

#import "MenuState.h"

#import "PlayState.h"

static NSString * RUN_MUSIC = @"run.mp3";
static NSString * RUN_TITLE_MUSIC = @"run-title.mp3";
static NSString * PANIC_MUSIC = @"daringescape.mp3";
static NSString * PANIC_TITLE_MUSIC = @"daringescape-title.mp3";
static NSString * TRACK3_MUSIC = @"machrunner.mp3";
static NSString * TRACK3_TITLE_MUSIC = @"machrunner-title.mp3";

static NSString * MUSIC_SELECTION = @"CanabaltTrack";

enum {
  RUN_TRACK,
  PANIC_TRACK,
  TRACK3_TRACK,
};

static NSString * RUN_TITLE = @"RUN";
static NSString * PANIC_TITLE = @"DARING ESCAPE";
static NSString * TRACK3_TITLE = @"MACH RUNNER";

static NSString * ImgButton = @"button.png";
static NSString * ImgBack = @"back.png";
static NSString * ImgBar = @"bar.png";
static NSString * ImgBarIPad = @"ipad/bar.png";

static NSString * ImgTitle = @"title.png";
static NSString * ImgTitleIPad = @"ipad/title.png";
static NSString * ImgTitle2 = @"title2.png";


static CGFloat duration = 1.0;

enum {
  MENU,
  ABOUT,
  PLAY,
};

enum {
  LOCAL,
  DAILY,
  WEEKLY,
  MONTHLY,
  GLOBAL,
};

@interface MenuState ()
- (void) showMusic;
- (void) hideMusic;
- (void) move:(FlxObject *)obj toPoint:(CGPoint)pnt duration:(CGFloat)dur;
@end


@implementation MenuState

- (id) init
{
  if ((self = [super init])) {
    self.bgColor = 0xff35353d;
    moving = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void) create
{
  
  state = MENU;
  scoreState = LOCAL;

  if (FlxG.iPad)
    title = [FlxSprite spriteWithGraphic:ImgTitleIPad];
  else
    title = [FlxSprite spriteWithGraphic:ImgTitle];
  title.y = -FlxG.height;
  title.velocity = CGPointMake(0, 254);
  title.drag = CGPointMake(title.drag.x, 100);
  [self add:title];

  title2 = [FlxSprite spriteWithGraphic:ImgTitle2];
  title2.x = ([FlxG width]-title2.width)/2;
  title2.y = 109;
  title2.alpha = 0.0;
  [self add:title2];

  about = [[[FlxButton alloc] initWithX:8
			      y:FlxG.height-36
			      callback:[FlashFunction functionWithTarget:self
						      action:@selector(onAbout)]] autorelease];
  [about loadGraphic:[FlxSprite spriteWithGraphic:ImgButton]];
  [about loadText:[FlxText textWithWidth:about.width
			   text:NSLocalizedString(@"About", @"About")
			   font:nil
			   size:16.0]];
  about.visible = NO;
  [self add:about];

  play = [[[FlxButton alloc] initWithX:FlxG.width-128
			     y:FlxG.height-36
			     callback:[FlashFunction functionWithTarget:self
						     action:@selector(onPlay)]] autorelease];
  [play loadGraphic:[FlxSprite spriteWithGraphic:ImgButton]];
  [play loadText:[FlxText textWithWidth:play.width
			  text:NSLocalizedString(@"PLAY", @"PLAY")
			  font:nil
			  size:16.0]];
  play.visible = NO;
  [self add:play];

  back = [[[FlxButton alloc] initWithX:8+FlxG.width
			     y:FlxG.height-36-4
			     callback:[FlashFunction functionWithTarget:self
						     action:@selector(onBack)]] autorelease];
  [back loadGraphic:[FlxSprite spriteWithGraphic:ImgBack]];
  [self add:back];
  back.visible = NO;
  
  if (FlxG.iPad)
    bar = [FlxSprite spriteWithGraphic:ImgBarIPad];
  else
    bar = [FlxSprite spriteWithGraphic:ImgBar];
  bar.x = 0;
  bar.y = -bar.height;
  [self add:bar];

  aboutTitle = [FlxText textWithWidth:FlxG.width
			text:NSLocalizedString(@"About Canabalt", @"About Canabalt")
			font:nil
			size:16.0];
  aboutTitle.color = 0xffffffff;
  aboutTitle.alignment = @"center";
  aboutTitle.x = 0;
  aboutTitle.y = -bar.height+4+2+2;
  [self add:aboutTitle];

  CGFloat textIndent = 2;

  aboutText = [FlxText textWithWidth:FlxG.width-textIndent
		       text:NSLocalizedString(@"Canabalt began as a 5-day experimental game for the Kyles’ Experimental Gameplay Project. Adam Atomic spent two weekends designing the gameplay, writing the code, drawing the artwork, and recording and designing the sound effects.  Danny Baranowsky wrote the music in one night and Adam released it into the wild.  It was slightly more popular than expected.\n\nThe original Flash game is available for free online at http://www.adamatomic.com/canabalt/\n\nEric ported Canabalt to the iPhone the following week.  Canabalt was developed and published independently for the iPhone by Eric and Adam Atomic under their Semi Secret imprint.",
					      @"Canabalt began as a 5-day experimental game for the Kyles’ Experimental Gameplay Project. Adam Atomic spent two weekends designing the gameplay, writing the code, drawing the artwork, and recording and designing the sound effects.  Danny Baranowsky wrote the music in one night and Adam released it into the wild.  It was slightly more popular than expected.\n\nThe original Flash game is available for free online at http://www.adamatomic.com/canabalt/\n\nEric ported Canabalt to the iPhone the following week.  Canabalt was developed and published independently for the iPhone by Eric and Adam Atomic under their Semi Secret imprint.")
		       font:nil
		       size:8.0];
  aboutText.color = 0xffffffff;
  aboutText.x = FlxG.width+textIndent;
  aboutText.y = bar.height+textIndent;
  [self add:aboutText];


  thanksText = [FlxText textWithWidth:FlxG.width-8
			text:NSLocalizedString(@"Adam would like to thank some people who contributed to the success of Canabalt:", @"Adam would like to thank some people who contributed to the success of Canabalt:")
			font:nil
			size:8.0];
  thanksText.color = 0xffffffff;
  thanksText.x = FlxG.width + textIndent;
  thanksText.y = 216.0;
  [self add:thanksText];

  CGFloat indent = 70;

  FlxText * txt = nil;
  NSArray * people = [NSArray arrayWithObjects:NSLocalizedString(@"...Steve Swink",@"...Steve Swink"),
			      NSLocalizedString(@"...Bekah (my wife!)",@"...Bekah (my wife!)"),
			      NSLocalizedString(@"...Janessa (Eric’s wife!)",@"...Janessa (Eric’s wife!)"),
			      NSLocalizedString(@"...Ben Ruiz",@"...Ben Ruiz"),
			      NSLocalizedString(@"...Kyle Pulver",@"...Kyle Pulver"),
			      NSLocalizedString(@"...and Farbs",@"...and Farbs"),
			      nil];
  NSArray * reasons = [NSArray arrayWithObjects:NSLocalizedString(@"for introducing the idea of obstacles",@" for introducing the idea of obstacles"),
			       NSLocalizedString(@"for her tolerance and assistance",@" for her tolerance and assistance"),
			       NSLocalizedString(@"for giving him the time to port this thing so fast!",@" for giving him the time to port this thing so fast!"),
			       NSLocalizedString(@"for playtesting, feedback, and encouragement",@" for playtesting, feedback, and encouragement"),
			       NSLocalizedString(@"for feedback",@" for feedback"),
			       NSLocalizedString(@"for creating Captain Forever, my favorite game of 2009",@" for creating Captain Forever, my favorite game of 2009"),
			       nil];
  

  CGFloat y = thanksText.y+thanksText.height-4;
  NSMutableArray * pplTxts = [NSMutableArray array];
  for (NSString * person in people) {
    txt = [FlxText textWithWidth:FlxG.width-8-indent
		   text:person
		   font:nil
		   size:8.0];
    txt.color = 0xffffffff;
    txt.x = FlxG.width+textIndent+indent;
    txt.y = y;
    [txt sizeToFit];
    [self add:txt];
    [pplTxts addObject:txt];
    y += txt.height-4-4;
  }
  peopleTexts = [[NSArray alloc] initWithArray:pplTxts];

  int index = 0;
  NSMutableArray * rsnTxts = [NSMutableArray array];
  for (NSString * reason in reasons) {
    FlxText * personText = [peopleTexts objectAtIndex:index];
    txt = [FlxText textWithWidth:-(personText.x+personText.width)
		   text:reason
		   font:nil
		   size:8.0];
    txt.color = 0x838383;
    txt.x = personText.x + personText.width-4;
    txt.y = personText.y;
    [txt sizeToFit];
    [self add:txt];
    [rsnTxts addObject:txt];
    index++;
  }
  reasonTexts = [[NSArray alloc] initWithArray:rsnTxts];

  
  NSNumber * musicSelection = [[NSUserDefaults standardUserDefaults] objectForKey:MUSIC_SELECTION];
  NSString * musicTitle = nil;
  if (musicSelection == nil || [musicSelection intValue] == RUN_TRACK) {
    [FlxG playMusic:RUN_TITLE_MUSIC];
    musicTitle = RUN_TITLE;
  } else if ([musicSelection intValue] == PANIC_TRACK) {
    [FlxG playMusic:PANIC_TITLE_MUSIC];
    musicTitle = PANIC_TITLE;
  } else {
    [FlxG playMusic:TRACK3_TITLE_MUSIC];
    musicTitle = TRACK3_TITLE;
  }

  if ([FlxG isOtherMusicPlaying]) {
    nowPlaying = nil;
    danny = nil;
  } else {
    nowPlaying = [FlxText textWithWidth:300
			  text:[NSString stringWithFormat:NSLocalizedString(@"Now Playing: \"%1$@\"", @"Now Playing: \"%1$@\""), musicTitle]
			  font:nil
			  size:8];
    nowPlaying.color = 0xffffffff;
    nowPlaying.alignment = @"right";
    nowPlaying.x = FlxG.width-300-4;
    nowPlaying.y = 4;
    [self add:nowPlaying];
    danny = [FlxText textWithWidth:300
		     text:@"Danny Baranowsky"
		     font:nil
		     size:8];
    danny.color = 0xffffffff;
    danny.alignment = @"right";
    danny.x = FlxG.width-300-4;
    danny.y = 15+4;
    [self add:danny];

    nowPlaying.visible = NO;
    danny.visible = NO;
  }
  
}

- (void) dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [peopleTexts release];
  [reasonTexts release];
  [moving release];
  [super dealloc];
}


- (void) update
{
  //move the moving objects...

  for (FlxObject * obj in [[[moving allKeys] copy] autorelease]) {
    NSMutableDictionary * md = [moving objectForKey:obj];
    float timer = [[md objectForKey:@"timer"] floatValue];
    float duration = [[md objectForKey:@"duration"] floatValue];
    CGPoint fromPoint = [[md objectForKey:@"fromPoint"] CGPointValue];
    CGPoint toPoint = [[md objectForKey:@"toPoint"] CGPointValue];
    timer += FlxG.elapsed;
    float delta = timer/duration - sin(timer/duration*2*M_PI)/(2*M_PI);
    if (delta < 1.0) {
      obj.x = delta * (toPoint.x-fromPoint.x) + fromPoint.x;
      obj.y = delta * (toPoint.y-fromPoint.y) + fromPoint.y;
      [md setObject:[NSNumber numberWithFloat:timer] forKey:@"timer"];
    } else {
      obj.x = toPoint.x;
      obj.y = toPoint.y;
      [moving removeObjectForKey:obj];
    }
  }
  
  [super update];

  BOOL switchMusic = NO;
  if (nowPlaying) {
    if (FlxG.touches.touchesBegan) {
      if (CGRectContainsPoint(CGRectMake(nowPlaying.x, nowPlaying.y,
					 nowPlaying.width, nowPlaying.height*2.3),
			      FlxG.touches.touchPoint))
	touchBeganInMusic = YES;
      else
	touchBeganInMusic = NO;
    } else if (FlxG.touches.touchesEnded && touchBeganInMusic && touchEndedInMusic) {
      switchMusic = YES;
    } else if (FlxG.touches.touching) {
      if (CGRectContainsPoint(CGRectMake(nowPlaying.x, nowPlaying.y,
					 nowPlaying.width, nowPlaying.height*2.3),
			      FlxG.touches.touchPoint))
	touchEndedInMusic = YES;
      else
	touchEndedInMusic = NO;
    }
  }

  if (switchMusic) {
    NSNumber * musicSelection = [[NSUserDefaults standardUserDefaults] objectForKey:MUSIC_SELECTION];
    int nowPlayingSelection = [musicSelection intValue];
    //    BOOL playingRun = NO;
    if (musicSelection == nil || [musicSelection intValue] == RUN_TRACK)
      nowPlayingSelection = RUN_TRACK;
      //playingRun = YES;

    //change music...
    NSString * musicTitle = nil;
    if (nowPlayingSelection == RUN_TRACK) {
      [FlxG playMusic:PANIC_TITLE_MUSIC];
      musicTitle = PANIC_TITLE;
      [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:PANIC_TRACK]
					     forKey:MUSIC_SELECTION];
      [[NSUserDefaults standardUserDefaults] synchronize];
    } else if (nowPlayingSelection == PANIC_TRACK) {
      [FlxG playMusic:TRACK3_TITLE_MUSIC];
      musicTitle = TRACK3_TITLE;
      [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:TRACK3_TRACK]
					     forKey:MUSIC_SELECTION];
      [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
      [FlxG playMusic:RUN_TITLE_MUSIC];
      musicTitle = RUN_TITLE;
      [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:RUN_TRACK]
					     forKey:MUSIC_SELECTION];
      [[NSUserDefaults standardUserDefaults] synchronize];
    }
    nowPlaying.text = [NSString stringWithFormat:NSLocalizedString(@"Now Playing: \"%1$@\"", @"Now Playing: \"%1$@\""), musicTitle];
  }

  if (title.velocity.y == 0 && title2.alpha < 1)
    title2.alpha += FlxG.elapsed;

  if (!play.visible && title.velocity.y == 0 && state == MENU) {
    play.visible = YES;
    about.visible = YES;
    if (nowPlaying) {
      nowPlaying.visible = YES;
      danny.visible = YES;
    }
  }

}


- (void) move:(FlxObject *)obj toPoint:(CGPoint)pnt duration:(CGFloat)dur
{
  [moving setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
					   [NSValue valueWithCGPoint:pnt], @"toPoint",
					 [NSValue valueWithCGPoint:CGPointMake(obj.x, obj.y)], @"fromPoint",
					 [NSNumber numberWithFloat:dur], @"duration",
					 [NSNumber numberWithFloat:0.0], @"timer",
					 nil]
	  forKey:obj];
}

- (void) onPlay
{
  if (state != MENU)
    return;

  state = PLAY;

  FlxG.state = [[[PlayState alloc] init] autorelease];

  NSNumber * musicSelection = [[NSUserDefaults standardUserDefaults] objectForKey:MUSIC_SELECTION];
  if (musicSelection == nil || [musicSelection intValue] == RUN_TRACK)
    [FlxG playMusic:RUN_MUSIC];
  else if ([musicSelection intValue] == PANIC_TRACK)
    [FlxG playMusic:PANIC_MUSIC];
  else
    [FlxG playMusic:TRACK3_MUSIC];
}

- (void) onAbout
{
  back.visible = YES;
  if (state != MENU)
    return;
  state = ABOUT;

  [self move:title2 toPoint:CGPointMake(title2.x-FlxG.width, title2.y)
	duration:duration];
  [self move:play toPoint:CGPointMake(play.x-FlxG.width, play.y)
	duration:duration];
  [self move:about toPoint:CGPointMake(about.x-FlxG.width, about.y)
	duration:duration];

  [self hideMusic];

  [self move:bar toPoint:CGPointMake(bar.x, bar.y+bar.height)
       duration:duration];
  [self move:aboutTitle toPoint:CGPointMake(aboutTitle.x, aboutTitle.y+bar.height)
	duration:duration];
  [self move:aboutText toPoint:CGPointMake(aboutText.x-FlxG.width, aboutText.y)
	duration:duration];

  [self move:thanksText toPoint:CGPointMake(thanksText.x-FlxG.width, thanksText.y)
	duration:duration];

  for (FlxText * txt in peopleTexts)
    [self move:txt toPoint:CGPointMake(txt.x-FlxG.width, txt.y)
	  duration:duration];
  for (FlxText * txt in reasonTexts)
    [self move:txt toPoint:CGPointMake(txt.x-FlxG.width, txt.y)
	  duration:duration];

  [self move:back toPoint:CGPointMake(back.x-FlxG.width, back.y)
	duration:duration];
  
}

- (void) onBack
{
  if (state == ABOUT) {

    [self move:title2 toPoint:CGPointMake(title2.x+FlxG.width, title2.y)
	  duration:duration];
    [self move:play toPoint:CGPointMake(play.x+FlxG.width, play.y)
	  duration:duration];
    [self move:about toPoint:CGPointMake(about.x+FlxG.width, about.y)
	  duration:duration];

    [self showMusic];

    [self move:bar toPoint:CGPointMake(bar.x, bar.y-bar.height)
	  duration:duration];
    [self move:aboutTitle toPoint:CGPointMake(aboutTitle.x, aboutTitle.y-bar.height)
	  duration:duration];
    [self move:aboutText toPoint:CGPointMake(aboutText.x+FlxG.width, aboutText.y)
	  duration:duration];

    [self move:thanksText toPoint:CGPointMake(thanksText.x+FlxG.width, thanksText.y)
	  duration:duration];
    
    [self move:back toPoint:CGPointMake(back.x+FlxG.width, back.y)
	  duration:duration];

    for (FlxText * txt in peopleTexts)
      [self move:txt toPoint:CGPointMake(txt.x+FlxG.width, txt.y)
	    duration:duration];
    for (FlxText * txt in reasonTexts)
      [self move:txt toPoint:CGPointMake(txt.x+FlxG.width, txt.y)
	    duration:duration];
    
    state = MENU;
  }

}

- (void) hideMusic
{
  if (nowPlaying) {
    nowPlaying.visible = NO;
    danny.visible = NO;
  }
}

- (void) showMusicDelayed
{
  if (nowPlaying) {
    nowPlaying.visible = YES;
    danny.visible = YES;
  }
}

- (void) showMusic
{
  [self performSelector:@selector(showMusicDelayed)
	withObject:nil
	afterDelay:1.0];
}


@end

