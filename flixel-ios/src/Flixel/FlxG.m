//
//  FlxG.m
//  flixel-ios
//
//  Copyright Semi Secret Software 2009-2010. All rights reserved.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
#import <Flixel/Flixel.h>

#import <AudioToolbox/AudioToolbox.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <CoreAudio/CoreAudioTypes.h>

typedef struct {
  ALuint source;
  ALuint buffer;
  void * data;
  UInt32 byteCount;
  ALenum dataFormat;
  Float64 sampleRate;
} SoundParameters;

//for sysctlbyname
#include <sys/types.h>
#include <sys/sysctl.h>

@interface UIDevice (Platform)
- (NSString *) platform;
@end

@implementation UIDevice (Platform)
- (NSString *) platform;
{
  size_t size;
  sysctlbyname("hw.machine", NULL, &size, NULL, 0);
  char *machine = malloc(size);
  sysctlbyname("hw.machine", machine, &size, NULL, 0);
  NSString *platform = [NSString stringWithUTF8String:machine];
  free(machine);
  return platform;
}
@end

@implementation NSArray (IntArray)
+ (NSArray *) intArrayWithSize:(NSUInteger)size ints:(int)first, ...;
{
  va_list argumentList;
  NSMutableArray * array = [NSMutableArray array];
  va_start(argumentList, first);
  [array addObject:[NSNumber numberWithInt:first]];
  for (NSUInteger i=1; i<size; ++i) {
    int val = va_arg(argumentList, int);
    [array addObject:[NSNumber numberWithInt:val]];
  }
  va_end(argumentList);
  return array;
}   
@end

@implementation NSMutableArray (IntArray)
+ (NSMutableArray *) intArrayWithSize:(NSUInteger)size ints:(int)first, ...;
{
  va_list argumentList;
  NSMutableArray * array = [NSMutableArray array];
  va_start(argumentList, first);
  [array addObject:[NSNumber numberWithInt:first]];
  for (NSUInteger i=1; i<size; ++i) {
    int val = va_arg(argumentList, int);
    [array addObject:[NSNumber numberWithInt:val]];
  }
  va_end(argumentList);
  return array;
}   
@end

static int check_other_audio_count;

static BOOL checkedVibration = NO;
static BOOL doVibration = NO;

static FlxGame * _game;
static BOOL gameStarted = NO;
static BOOL _mute;
static FlashPoint * _scrollTarget;
static NSMutableDictionary * _cache;

static CGFloat screenScale;
static BOOL iPad;
static BOOL retinaDisplay;
static BOOL iPhone3GS;
static BOOL iPhone3G;
static BOOL iPhone1G;
static BOOL iPodTouch1G;
static BOOL iPodTouch2G;
static BOOL iPodTouch3G;

//static BOOL debug;
static float elapsed;
static float maxElapsed;
static float timeScale;
static int width;
static int height;
static NSMutableArray * levels;
static int level;
static NSMutableArray * scores;
static int score;
//static NSMutableArray * saves;
//static int save;
static FlxSound * music;
static NSMutableDictionary * sounds;
static FlxObject * followTarget;
static BOOL pauseFollow;
static FlashPoint * followLead;
static float followLerp;
static FlashPoint * followMin;
static FlashPoint * followMax;
static FlashPoint * scroll;
static FlxQuake * quake;
static FlxFlash * flash;
static FlxFade * fade;
//audio stuff
static AVAudioPlayer * audioPlayer;
static NSTimeInterval audioPlayerTime = 0;
//static float fadeTimer;
//static float fadeVolume;
//static float fadeDuration;
static float fadeOutDuration;
static float fadeOutTimer;
static float fadeOutVolume;
static ALCdevice * device;
static ALCcontext * context;
static UInt32 isOtherAudioPlaying;
static BOOL needToCheckForOtherAudio;
static BOOL musicPaused;
static FlxTouches * touches;
static float soundEffectsMasterVolume;
static float musicMasterVolume;




@interface FlxG (Sound)
+ (SoundParameters *) getSoundParameters:(NSString *)embeddedSound;
@end


@interface FlxG ()
+ (void) doFollow;
+ (void) unfollow;
+ (void) initAudio;
+ (void) checkForOtherAudio;
// + (void) audioSessionBeginInterruption;
// + (void) audioSessionEndInterruption;
+ (void) beginInterruption;
+ (void) endInterruption;
+ (void) setupOpenAL;
+ (void) teardownOpenAL;
+ (void) delayedCheckForOtherAudio;
+ (void) restartAudioPlayer;
@end

@interface FlxGame (PrivateGame)
@property (readonly) FlxState * state;
@end

@implementation FlxGame (PrivateGame)
- (FlxState *) state
{
  return _state;
}
@end


// void audioSessionInterruptHandler(void * userData, UInt32 interruptionState) {
//   if (interruptionState == kAudioSessionBeginInterruption) {
//     [FlxG audioSessionBeginInterruption];
//   } else if (interruptionState == kAudioSessionEndInterruption) {
//     [FlxG audioSessionEndInterruption];
//   }
// }

typedef ALvoid AL_APIENTRY (*alBufferDataStaticProcPtr) (const ALint bid, ALenum format, ALvoid* data, ALsizei size, ALsizei freq);

ALvoid alBufferDataStaticProc(const ALint bid, ALenum format, ALvoid* data, ALsizei size, ALsizei freq) {
  static alBufferDataStaticProcPtr proc = NULL;
  if (proc == NULL)
    proc = (alBufferDataStaticProcPtr) alcGetProcAddress(NULL, (const ALCchar*) "alBufferDataStatic");
  if (proc)
    proc(bid, format, data, size, freq);
  return;
}

typedef ALvoid AL_APIENTRY (*alcMacOSXMixerOutputRateProcPtr) (const ALfloat value);
ALvoid alcMacOSXMixerOutputRateProc(const ALfloat value) {
  static alcMacOSXMixerOutputRateProcPtr proc = NULL;
  if (proc == NULL)
    proc = (alcMacOSXMixerOutputRateProcPtr) alcGetProcAddress(NULL, (const ALCchar*) "alcMacOSXMixerOutputRate");
  if (proc)
    proc(value);
  return;
}


@implementation FlxG

+ (void) didEnterBackground;
{
//   //todo - turn off sounds? so that ipod music can play for example?
//   NSLog(@"preemptively setting sound to ambient sound");
//   UInt32 category = kAudioSessionCategory_AmbientSound;
//   AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
//  			  sizeof(category),
//  			  &category);
  
  if (_game)
    [_game didEnterBackground];
}
+ (void) willEnterForeground;
{
  if (_game)
    [_game willEnterForeground];
}
+ (void) willResignActive;
{
  @synchronized(self) {
    if (audioPlayer && audioPlayer.playing) {
      NSLog(@"forcing audioPlayer to pause");
      [audioPlayer pause];
      //save away playback location
      audioPlayerTime = [audioPlayer currentTime];
      [audioPlayer stop];
    }
  }
  NSError * error;
  [[AVAudioSession sharedInstance] setActive:NO error:&error];
  [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient
					 error:&error];
  
  needToCheckForOtherAudio = YES;
  if (_game)
    _game.paused = YES;
}
+ (void) didBecomeActive;
{
  //called once at application launch
  if (_game)
    _game.paused = NO;

  if (_game && !gameStarted) {
    [_game start];
    gameStarted = YES;
  }

  check_other_audio_count = 0;
  
  //check audio state again -> should we start playing background music?
  [self checkForOtherAudio];

  if (isOtherAudioPlaying) {
    NSLog(@"other audio is playing");
    [self delayedCheckForOtherAudio];
  } else {
    NSLog(@"no other audio playing");
    [self restartAudioPlayer];
  }
}

+ (void) delayedCheckForOtherAudio
{
  NSLog(@"delayed check for other audio");
  if (check_other_audio_count != 0) {
    needToCheckForOtherAudio = YES;
    [self checkForOtherAudio];
  }
  if (check_other_audio_count < 4 && isOtherAudioPlaying) {
    check_other_audio_count++;
    [self performSelector:@selector(delayedCheckForOtherAudio)
               withObject:nil
               afterDelay:2.0];
  } else {
    [self restartAudioPlayer];
  }
}

+ (void) restartAudioPlayer
{
  @synchronized(self) {
    if (!isOtherAudioPlaying) {
      NSError * error;
      //set fake category, so that we guarantee no software decoding...
      NSString * fakeCategory = AVAudioSessionCategoryPlayback;
      [[AVAudioSession sharedInstance] setCategory:fakeCategory
                                             error:&error];
      [[AVAudioSession sharedInstance] setActive:YES error:&error];
      [[AVAudioSession sharedInstance] setActive:NO error:&error];
      NSString * realCategory = AVAudioSessionCategorySoloAmbient;
      [[AVAudioSession sharedInstance] setCategory:realCategory
                                             error:&error];
      [[AVAudioSession sharedInstance] setActive:YES error:&error];
    }
    if (audioPlayer && !isOtherAudioPlaying && !audioPlayer.playing) {
      NSLog(@"trying to get audioPlayer to play again...");
      audioPlayer.volume = musicMasterVolume;
      [audioPlayer setCurrentTime:audioPlayerTime];
      [audioPlayer prepareToPlay];
      if (!musicPaused)
        [audioPlayer play];
    } else {
      if (audioPlayer == nil)
        NSLog(@"no audio player..");
      if (isOtherAudioPlaying)
        NSLog(@"thinks other audio is playing...");
      if (audioPlayer.playing)
        NSLog(@"thinks audio player is already playing...");
    }
  }
}



// {

//   NSError * error;
//   if (!isOtherAudioPlaying) {
//     //set fake category, so that we guarantee no software decoding...
//     NSString * fakeCategory = AVAudioSessionCategoryPlayback;
//     [[AVAudioSession sharedInstance] setCategory:fakeCategory
// 					   error:&error];
//     [[AVAudioSession sharedInstance] setActive:YES error:&error];
//     [[AVAudioSession sharedInstance] setActive:NO error:&error];
//     NSString * realCategory = AVAudioSessionCategorySoloAmbient;
//     [[AVAudioSession sharedInstance] setCategory:realCategory
// 					   error:&error];
//     [[AVAudioSession sharedInstance] setActive:YES error:&error];
//   }
  
//   @synchronized(self) {
//     if (audioPlayer && !isOtherAudioPlaying && !audioPlayer.playing) {
//       NSLog(@"trying to get audioPlayer to play again...");
//       //load it up to the right location
//       [audioPlayer setCurrentTime:audioPlayerTime];
//       [audioPlayer prepareToPlay];
//       if (!musicPaused)
// 	[audioPlayer play];
//     } else {
//       if (!audioPlayer)
// 	NSLog(@"no audio player..");
//       if (isOtherAudioPlaying)
// 	NSLog(@"thinks other audio is playing...");
//       if (audioPlayer.playing)
// 	NSLog(@"thinks audio player is already playing...");
//     }
//   }
// }


+ (void) initialize
{
  if (self == [FlxG class]) {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
      screenScale = [UIScreen mainScreen].scale;
    else
      screenScale = 1.0;

    if (_cache == nil)
      _cache = [[NSMutableDictionary alloc] init];

//     if ([[UIDevice currentDevice].model rangeOfString:@"iPad"].location != NSNotFound)
//       iPad = YES;
//     else
//       iPad = NO;
    if ([UIDevice instancesRespondToSelector:@selector(userInterfaceIdiom)] &&
        [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
      iPad = YES;
    else
      iPad = NO;
    //NSLog(@"iPad: %d", iPad);
    if ([UIScreen instancesRespondToSelector:@selector(scale)] &&
        [[UIScreen mainScreen] scale] == 2.0)
      retinaDisplay = YES;
    else
      retinaDisplay = NO;
    if ([[UIDevice currentDevice].platform isEqualToString:@"iPhone1,1"])
      iPhone1G = YES;
    else
      iPhone1G = NO;
    if ([[UIDevice currentDevice].platform isEqualToString:@"iPhone1,2"])
      iPhone3G = YES;
    else
      iPhone3G = NO;
    if ([[UIDevice currentDevice].platform isEqualToString:@"iPhone2,1"])
      iPhone3GS = YES;
    else
      iPhone3GS = NO;
    if ([[UIDevice currentDevice].platform isEqualToString:@"iPod1,1"])
      iPodTouch1G = YES;
    else
      iPodTouch1G = NO;
    if ([[UIDevice currentDevice].platform isEqualToString:@"iPod2,1"])
      iPodTouch2G = YES;
    else
      iPodTouch2G = NO;
    if ([[UIDevice currentDevice].platform isEqualToString:@"iPod3,1"])
      iPodTouch3G = YES;
    else
      iPodTouch3G = NO;
    timeScale = 1;
    maxElapsed = 1.0/20;
    touches = [[FlxTouches alloc] init];
    [self initAudio];
    
  }
}

+ (CGFloat) screenScale { return screenScale; }

+ (BOOL) iPad { return iPad; }
+ (BOOL) retinaDisplay { return retinaDisplay; }
+ (BOOL) iPhone1G { return iPhone1G; }
+ (BOOL) iPhone3G { return iPhone3G; }
+ (BOOL) iPhone3GS { return iPhone3GS; }
+ (BOOL) iPodTouch1G { return iPodTouch1G; }
+ (BOOL) iPodTouch2G { return iPodTouch2G; }
+ (BOOL) iPodTouch3G { return iPodTouch3G; }


+ (void) setMusic:(FlxSound *)newMusic; { [music autorelease]; music = [newMusic retain]; }
+ (FlxSound *) music; { return music; }
+ (void) setQuake:(FlxQuake *)newQuake; { [quake autorelease]; quake = [newQuake retain]; }
+ (FlxQuake *) quake; { return quake; }
+ (void) setLevel:(int)newLevel; { level = newLevel; }
+ (int) level; { return level; }
// + (void) setState:(FlxState *)newState; { [state autorelease]; state = [newState retain]; }
// + (FlxState *) state; { return state; }
+ (void) setElapsed:(float)newElapsed; { elapsed = newElapsed; }
+ (float) elapsed; { return elapsed; }
+ (void) setMaxElapsed:(float)newMaxElapsed; { maxElapsed = newMaxElapsed; }
+ (float) maxElapsed; { return maxElapsed; }
+ (void) setScroll:(FlashPoint *)newScroll; { [scroll autorelease]; scroll = [newScroll retain]; }
+ (FlashPoint *) scroll; { return scroll; }
+ (void) setScore:(int)newScore; { score = newScore; }
+ (int) score; { return score; }
+ (void) setFlash:(FlxFlash *)newFlash; { [flash autorelease]; flash = [newFlash retain]; }
+ (FlxFlash *) flash; { return flash; }
+ (void) setLevels:(NSMutableArray *)newLevels; { [levels autorelease]; levels = [newLevels copy]; }
+ (NSMutableArray *) levels; { return levels; }
+ (void) setFade:(FlxFade *)newFade; { [fade autorelease]; fade = [newFade retain]; }
+ (FlxFade *) fade; { return fade; }
+ (void) setHeight:(int)newHeight; { height = newHeight; }
+ (int) height; { return height; }
+ (void) setTimeScale:(float)newTimeScale; { timeScale = newTimeScale; }
+ (float) timeScale; { return timeScale; }
+ (FlxTouches *) touches; { return touches; }
+ (void) setScores:(NSMutableArray *)newScores; { [scores autorelease]; scores = [newScores copy]; }
+ (NSMutableArray *) scores; { return scores; }
+ (void) setWidth:(int)newWidth; { width = newWidth; }
+ (int) width; { return width; }

// + (void) setGame:(FlxGame *)newGame; { [game autorelease]; game = [newGame retain]; }
// + (FlxGame *) game; { return game; }



+ (void) initAudio
{
  [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1.0], @"MusicVolume",
									[NSNumber numberWithFloat:1.0], @"SoundEffectsVolume",
									nil]];
  soundEffectsMasterVolume = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SoundEffectsVolume"] floatValue];
  musicMasterVolume = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MusicVolume"] floatValue];
  [sounds autorelease];
  sounds = [[NSMutableDictionary alloc] init];

  NSError * error;

  //implicitly initialize audio session by referencing it
  [AVAudioSession sharedInstance];

  //set delegate
  [[AVAudioSession sharedInstance] setDelegate:self];
  
//   AudioSessionInitialize(NULL,
// 			 NULL,
//  			 audioSessionInterruptHandler,
//  			 self);
  isOtherAudioPlaying = 0;
  needToCheckForOtherAudio = YES;
  [self checkForOtherAudio];
  [self setupOpenAL];
  //make active
  if (!isOtherAudioPlaying)
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
}

+ (BOOL) isOtherMusicPlaying
{
  return isOtherAudioPlaying;
}

+ (void) vibrate;
{
  if (checkedVibration == NO) {
    doVibration = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Vibrate"] boolValue];
    checkedVibration = YES;
  }
  if (doVibration)
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


+ (FlxGame *) game
{
  return _game;
}

+ (void) loadTextureAtlas;
{
  // look for all png files
  NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
  NSMutableArray * dirs = [NSMutableArray arrayWithObject:resourcePath];

  NSMutableArray * pngs = [NSMutableArray array];

  while ([dirs count] > 0) {
    NSString * dir = [dirs lastObject];
    [dirs removeLastObject];
    NSDirectoryEnumerator * dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:dir];
    NSString * file;
    while (file = [dirEnum nextObject]) {
      //concat dir with file
      file = [NSString pathWithComponents:[NSArray arrayWithObjects:dir, file, nil]];
      BOOL isDir = NO;
      if ([[NSFileManager defaultManager] fileExistsAtPath:file isDirectory:&isDir]) {
	if (isDir) {
	  [dirs addObject:file];
	} else {
	  if ([[NSFileManager defaultManager] isReadableFileAtPath:file] &&
	      [[file pathExtension] isEqualToString:@"png"]) {
	    [pngs addObject:file];
	  }
	}
      }
    }
  }

  //compute overall area of pngs
  int totalArea = 0;
  for (NSString * png in pngs) {
    UIImage * image = [UIImage imageWithContentsOfFile:png];
    totalArea += (int)(image.size.width*image.size.height);
  }

}

+ (void) groupIntoTextureAtlases:(NSArray *)images ofSize:(CGSize)maxSize;
{
  NSMutableArray * toFit = [NSMutableArray arrayWithArray:images];
  
  while ([toFit count] > 0) {
    NSMutableArray * couldNotFit = [NSMutableArray array];
    while ([toFit count] > 0 &&
	   [self groupIntoTextureAtlas:toFit ofSize:maxSize] == NO) {
      if ([toFit count] > 1) //make sure we don't get stuck in an infinite loop
	[couldNotFit addObject:[toFit lastObject]];
      else {
	//at least load this image to it's own texture
	// 	NSLog(@"toFit lastObject: %@", [toFit lastObject]);
	//TODO:
      }
      [toFit removeLastObject];
    }
    toFit = couldNotFit;
  }
}

+ (BOOL) groupIntoTextureAtlas:(NSArray *)imageFiles
{
  GLint maxTextureSize = FlxGLView.maxTextureSize;
  CGSize size = CGSizeMake((float)maxTextureSize, (float)maxTextureSize);
  return [self groupIntoTextureAtlas:imageFiles ofSize:size];
}

+ (BOOL) groupIntoTextureAtlas:(NSArray *)imageFiles ofSize:(CGSize)size
{
//   fprintf(stderr, "\n\n\n");
  int totalArea = 0;
  for (NSString * imageFile in imageFiles) {
    //UIImage * image = [UIImage imageNamed:imageFile];
    NSString * filename = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], imageFile];
    UIImage * image = [UIImage imageWithContentsOfFile:filename];

    //NSLog(@"image:%@, size:%dx%d", imageFile, (int)(image.size.width), (int)(image.size.height));
    totalArea += (int)(image.size.width*image.size.height);
  }
  //NSLog(@"totalArea: %d", totalArea);
  //fprintf(stderr, "\n\n\n");

  if (totalArea > size.width*size.height) {
    //NSLog(@"bailing early, impossible to fit in requested size");
    return NO;
  }
  
  //try to pack all this stuff together into a 1024x1024 (maxTextureSize x maxTextureSize) texture, keeping track of offsets
  NSMutableArray * blocks = [NSMutableArray arrayWithArray:imageFiles];
  NSMutableArray * placedBlocks = [NSMutableArray array];

  NSMutableDictionary * placements = [NSMutableDictionary dictionary];
  
  CGRect enclosingRectangle = CGRectZero;
  
  //place the first image
  NSString * firstFile = [blocks lastObject];
  //UIImage * first = [UIImage imageNamed:firstFile];
  NSString * firstFilename = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], firstFile];
  UIImage * first = [UIImage imageWithContentsOfFile:firstFilename];
  [blocks removeLastObject];
  [placedBlocks addObject:firstFile];
  
  CGRect firstPlacement = CGRectMake(0, 0, first.size.width, first.size.height);
  [placements setObject:[NSValue valueWithCGRect:firstPlacement] forKey:firstFile];

  enclosingRectangle = firstPlacement;

  //GLint maxTextureSize = FlxGLView.maxTextureSize;
  GLint maxTextureWidth = (GLint)size.width;
  GLint maxTextureHeight = (GLint)size.height;
  
  //NSLog(@"MAX TEXTURE SIZE: (%d,%d)", maxTextureWidth, maxTextureHeight);
  
  for (NSString * block in blocks) {
    int objective = INT_MAX; //find the best placement for block, need to reset objective so that we can minimize
    CGRect bestPlacement = CGRectZero;
    //UIImage * image = [UIImage imageNamed:block];
    NSString * blockFilename = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], block];
    UIImage * image = [UIImage imageWithContentsOfFile:blockFilename];
    for (NSString * placed in placedBlocks) {
      CGRect placedRect = [[placements objectForKey:placed] CGRectValue];
      for (int a = 0; a < 4; ++a) {
	for (int b = 0; b < 4; ++b) {
	  //place corner b of block on corner a of placed
	  //corner 0: bottom left
	  //corner 1: bottom right
	  //corner 2: top left
	  //corner 3: top right
	  CGRect placement = CGRectZero;
	  placement.size = image.size;
	  //where do we put it?
	  CGPoint origin = CGPointZero;
	  switch (a) {
	  case 0:
	    origin = placedRect.origin;
	    break;
	  case 1:
	    origin = CGPointMake(placedRect.origin.x+placedRect.size.width, placedRect.origin.y);
	    break;
	  case 2:
	    origin = CGPointMake(placedRect.origin.x, placedRect.origin.y+placedRect.size.height);
	    break;
	  case 3:
	    origin = CGPointMake(placedRect.origin.x+placedRect.size.width, placedRect.origin.y+placedRect.size.height);
	    break;
	  }
	  switch (b) {
	  case 0:
	    //nothing, already in right place
	    break;
	  case 1:
	    origin = CGPointMake(origin.x-image.size.width, origin.y);
	    break;
	  case 2:
	    origin = CGPointMake(origin.x, origin.y-image.size.height);
	    break;
	  case 3:
	    origin = CGPointMake(origin.x-image.size.width, origin.y-image.size.height);
	    break;
	  }
	  //check boundary conditions
	  if (origin.x < 0 || origin.y < 0 ||
	      origin.x+image.size.width >= maxTextureWidth ||
	      origin.y+image.size.height >= maxTextureHeight)
	    break;
	  //check overlap conditions
	  CGRect potentialPlacement = CGRectMake(origin.x, origin.y, image.size.width, image.size.height);
	  BOOL overlaps = NO;
	  for (NSString * placed2 in placedBlocks) {
	    CGRect placedRect2 = [[placements objectForKey:placed2] CGRectValue];
	    if (CGRectIntersectsRect(potentialPlacement, placedRect2)) {
	      overlaps = YES;
	      break;
	    }
	  }
	  if (overlaps)
	    break;
	  //calculate newObjective
	  CGRect potentialEnclosingRectangle = enclosingRectangle;
	  if (potentialEnclosingRectangle.size.width < potentialPlacement.origin.x+potentialPlacement.size.width)
	    potentialEnclosingRectangle.size.width = potentialPlacement.origin.x + potentialPlacement.size.width;
	  if (potentialEnclosingRectangle.size.height < potentialPlacement.origin.y+potentialPlacement.size.height)
	    potentialEnclosingRectangle.size.height = potentialPlacement.origin.y + potentialPlacement.size.height;
	  int newObjective = potentialEnclosingRectangle.size.width*potentialEnclosingRectangle.size.height +
	    (potentialPlacement.origin.y + potentialEnclosingRectangle.size.width)/2;
	  if (newObjective < objective) {
	    objective = newObjective;
	    bestPlacement = potentialPlacement;
	  }
	}
      }
    }
    //check if we found a placement
    if (CGRectEqualToRect(bestPlacement, CGRectZero)) {
      //NSLog(@"Could not find a valid placement! bailing...");
      return NO;
    }
    
    //add best placement to placements
    [placements setObject:[NSValue valueWithCGRect:bestPlacement] forKey:block];
    [placedBlocks addObject:block];
    
    if (enclosingRectangle.size.width < bestPlacement.origin.x+bestPlacement.size.width)
      enclosingRectangle.size.width = bestPlacement.origin.x + bestPlacement.size.width;
    if (enclosingRectangle.size.height < bestPlacement.origin.y+bestPlacement.size.height)
      enclosingRectangle.size.height = bestPlacement.origin.y+bestPlacement.size.height;
  }
  
#if 0
  //would be cool to actually generate the atlas image...


  unsigned char * data = calloc(maxTextureWidth*maxTextureHeight*4, sizeof(unsigned char));
  CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
  CGContextRef imageContext = CGBitmapContextCreate(data,
						    maxTextureWidth,
						    maxTextureHeight,
						    8,
						    maxTextureWidth*4,
						    colorspace,
						    kCGImageAlphaPremultipliedLast);

  CGColorSpaceRelease(colorspace);

  //can i somehow erase everything in imageContext?
  CGContextClearRect(imageContext,
		     CGRectMake(0, 0, maxTextureWidth, maxTextureHeight));

  for (NSString * imageFile in placements) {
    //UIImage * image = [UIImage imageNamed:imageFile];
    NSString * imageFilename = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], imageFile];
    UIImage * image = [UIImage imageWithContentsOfFile:imageFilename];
    CGRect placement = [[placements objectForKey:imageFile] CGRectValue];
    CGContextDrawImage(imageContext,
		       placement,
		       image.CGImage);
  }

  //somehow render to a uiimage?
  CGImageRef atlasCGImage = CGBitmapContextCreateImage(imageContext);
  UIImage * atlasImage = [UIImage imageWithCGImage:atlasCGImage];
  //write it to the photo library?

  UIImageWriteToSavedPhotosAlbum(atlasImage, nil, NULL, NULL);

  CGImageRelease(atlasCGImage);
  
  CGContextRelease(imageContext);
  free(data);
  
#endif

  //create an opengl texture to hold all of these images
  //then set up texture objects to correspond to this opengl texture with
  //appropriate offsets and texture coordinates

//    NSLog(@"enclosingRectangle: [%f,%f,%f,%f]",
//  	enclosingRectangle.origin.x,
//  	enclosingRectangle.origin.y,
//  	enclosingRectangle.size.width,
//  	enclosingRectangle.size.height);
  
  SemiSecretTexture * atlasTexture = [SemiSecretTexture textureWithSize:enclosingRectangle.size
							images:imageFiles
							locations:placements];

//   NSLog(@"atlasTexture.texture: %d", atlasTexture.texture);
  
  for (NSString * imageFile in imageFiles) {
    CGRect placement = [[placements objectForKey:imageFile] CGRectValue];
    SemiSecretTexture * texture = [SemiSecretTexture textureWithAtlasTexture:atlasTexture
						     offset:placement.origin
						     size:placement.size];
    [_cache setObject:texture forKey:imageFile];
//     NSLog(@" -> %@", imageFile);
  }

  //NSLog(@"_cache: %@", [_cache description]);

  return YES;
}

+ (void) clearTextureCache
{
  [_cache removeAllObjects];
}


+ (void) log:(NSString *)Data;
{
  NSLog(@"FlxG.log: %@", Data);
  //    [_game._console log:(Data == nil) ? @"ERROR: null object" : [Data toString]];
}

// - (void) setElapsed:(float)newElapsed
// {
//   elapsed = newElapsed*timeScale;
// }

+ (void) setState:(FlxState *)State
{
  [_game switchState:State];
}

+ (FlxState *) state
{
  return _game.state;
}


// + (BOOL) pause;
// {
//    return _pause;
// }
// + (void) pause:(BOOL)Pause;
// {
//    BOOL op = _pause;
//    _pause = Pause;
//    if (_pause != op)
//       {
//          if (_pause)
//             {
//                [_game pauseGame];
//                [self pauseSounds];
//             }
//          else
//             {
//                [_game unpauseGame];
//                [self playSounds];
//             }
//       }
// }
// + (void) resetInput;
// {
//    [keys reset];
//    [mouse reset];
// }


+ (void) playMusic:(NSString *)Music;
{
  return [self playMusicWithParam1:Music param2:1];
}

+ (void) playMusicWithParam1:(NSString *)Music param2:(float)Volume;
{

//     if (isOtherAudioPlaying)
//       return;

//   [NSThread detachNewThreadSelector:@selector(reallyPlayMusic:) toTarget:self withObject:Music];

    [self performSelector:@selector(reallyPlayMusic:)
	  withObject:Music
	  afterDelay:0.0];
    
}

+ (void) reallyPlayMusic:(NSString *)Music
{
//   NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];  

  float volume = musicMasterVolume; //[[[NSUserDefaults standardUserDefaults] objectForKey:@"MusicVolume"] floatValue];

  if (volume > 0.0) {
    NSError * error;

    @synchronized(self) {
      if (audioPlayer)
	[audioPlayer release];
      audioPlayer =
	[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], Music] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
			       error:&error];
      if (audioPlayer) {
	audioPlayer.delegate = self;
	audioPlayer.numberOfLoops = -1;
	if (!isOtherAudioPlaying)
	  [audioPlayer play];
	audioPlayer.volume = volume;
      } else {
	NSLog(@"error!");
      }
      if (error) {
	NSLog(@"error: %@, %@", error, [error localizedDescription]);
      }
    }
  }
  
//   [pool release];
}


+ (void) fadeOutMusic:(float)duration;
{
  // float volume = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MusicVolume"] floatValue];
  float volume = musicMasterVolume;
  fadeOutVolume = volume;
  fadeOutTimer = fadeOutDuration = duration;
}


+ (void) updateSounds;
{

  if (fadeOutTimer <= 0)
    return;

  fadeOutTimer -= elapsed;
  if (fadeOutTimer < 0)
    fadeOutTimer = 0;

  @synchronized(self) {
    audioPlayer.volume = fadeOutVolume * (fadeOutTimer/fadeOutDuration);

    if (fadeOutTimer == 0) {
      [audioPlayer release];
      audioPlayer = nil;
    }
  }
}

+ (void) pauseMusic
{
  @synchronized(self) {
    if (audioPlayer) {
      [audioPlayer pause];
      musicPaused = YES;
    }
  }
}

+ (void) unpauseMusic
{
  @synchronized(self) {
    if (audioPlayer && !isOtherAudioPlaying && !audioPlayer.playing) {
      [audioPlayer play];
      musicPaused = NO;
    }
  }
}

// + (void) applicationWillResignActive:(NSNotification *)note
// {
//   @synchronized(self) {
//     if (audioPlayer && audioPlayer.playing) {
//       NSLog(@"forcing audioPlayer to pause");
//       [audioPlayer pause];
//     }
//   }
//   needToCheckForOtherAudio = YES;
// }

// + (void) applicationDidBecomeActive:(NSNotification *)note
// {
//   if (needToCheckForOtherAudio == NO)
//     return;
//   //check audio state again -> should we start playing background music?
//   [self checkForOtherAudio];
//   @synchronized(self) {
//     if (audioPlayer && !isOtherAudioPlaying && !audioPlayer.playing) {
//       NSLog(@"trying to get audioPlayer to play again...");
//       if (!musicPaused)
// 	[audioPlayer play];
//     } else {
//       if (!audioPlayer)
// 	NSLog(@"no audio player..");
//       if (isOtherAudioPlaying)
// 	NSLog(@"thinks other audio is playing...");
//       if (audioPlayer.playing)
// 	NSLog(@"thinks audio player is already playing...");
//     }
//   }
// }

//+ (void) audioSessionBeginInterruption
+ (void) beginInterruption
{
  [self teardownOpenAL]; // why was this commented out?
  NSError * error;
  [[AVAudioSession sharedInstance] setActive:NO error:&error];
  NSLog(@"beginInterruption");
  needToCheckForOtherAudio = YES;
}

//+ (void) audioSessionEndInterruption
+ (void) endInterruption
{
  NSLog(@"endInterruption");
  NSError * error;
  [self checkForOtherAudio];
  [self setupOpenAL];
  if (!isOtherAudioPlaying)
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
  
  //reload effects
  for (NSValue * sound in [sounds objectEnumerator]) {
    SoundParameters * sp = (SoundParameters *)[sound pointerValue];
    alGenSources(1, &sp->source);
    alGenBuffers(1, &sp->buffer);
    alBufferDataStaticProc(sp->buffer,
			   sp->dataFormat,
			   sp->data,
			   sp->byteCount,
			   sp->sampleRate);
    alSourcei(sp->source, AL_BUFFER, sp->buffer);
  }
}

+ (void) audioPlayerBeginInterruption:(AVAudioPlayer *)player;
{
  needToCheckForOtherAudio = YES;
  if (isOtherAudioPlaying)
    return;
  @synchronized(self) {
    [player pause];
  }
}

+ (void) audioPlayerEndInterruption:(AVAudioPlayer *)player;
{
  [self checkForOtherAudio];
  @synchronized(self) {
    if (player && !isOtherAudioPlaying && !player.playing)
      [player play];
  }
}

+ (void) checkForOtherAudio
{
  if (!needToCheckForOtherAudio)
    return;

  UInt32 sizeOfIsOtherAudioPlaying = sizeof(isOtherAudioPlaying);
  AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying,
 			  &sizeOfIsOtherAudioPlaying,
 			  &isOtherAudioPlaying);


  NSString * category = AVAudioSessionCategorySoloAmbient;
  if (isOtherAudioPlaying) {
    category = AVAudioSessionCategoryAmbient;
    NSLog(@"setting category to ambient sound");
  } else {
    NSLog(@"setting to solo ambient");
  }
  
  NSError * error;
  [[AVAudioSession sharedInstance] setCategory:category
					 error:&error];
  
  if (!isOtherAudioPlaying)
    AudioSessionSetActive(true); //this was commented out, need to comment again?

  needToCheckForOtherAudio = NO;
}

+ (void) setupOpenAL
{
  device = NULL;
  context = NULL;
  OSStatus result;
  device = alcOpenDevice(NULL);
  result = alGetError();
  if (result != AL_NO_ERROR)
    NSLog(@"Error opening output device: %x", (int)result);
  if (device == NULL)
    return;
  //alcMacOSXMixerOutputRateProc(44100);
  alcMacOSXMixerOutputRateProc(22050);
  context = alcCreateContext(device, 0);
  result = alGetError();
  if (result != AL_NO_ERROR)
    NSLog(@"Error creating OpenAL context: %x", (int)result);
  if (context == NULL)
    return;
  alcMakeContextCurrent(context);
  result = alGetError();
  if (result != AL_NO_ERROR)
    NSLog(@"Error setting current OpenAL context: %x", (int)result);
  alListener3f(AL_POSITION, 0.0, 0.0, 1.0);

  result = alGetError();
  if (result != AL_NO_ERROR)
    NSLog(@"Error setting listener position: %x", (int)result);

}

+ (void) teardownOpenAL
{
  for (NSValue * sound in [sounds objectEnumerator]) {
    SoundParameters * sp = (SoundParameters *)[sound pointerValue];
    alDeleteSources(1, &sp->source);
  }
  if (context)
    alcDestroyContext(context);
  if (device)
    alcCloseDevice(device);
}

+ (void) loadSound:(NSString *)filename
{

  NSValue * sound = [sounds objectForKey:filename];
  if (sound)
    return;
  
  NSString * path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename];

  ALuint source;
  ALuint soundBuffer;
  void * soundData;

  alGenSources(1, &source);

  AudioStreamBasicDescription dataFormat;
  AudioFileID audioFileID;
  UInt32 dataFormatSize = sizeof(dataFormat);
  UInt64 byteCount;
  UInt32 byteCountSize = sizeof(byteCount);
  CFURLRef url = (CFURLRef)[NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  OSStatus result = noErr;
#if TARGET_OS_IPHONE
  result = AudioFileOpenURL(url, kAudioFileReadPermission, 0, &audioFileID);
#else
  result = AudioFileOpenURL(url, fsRdPerm, 0, &audioFileID);
#endif
  //assert no error
  if (result != noErr)
    NSLog(@"Error opening file (%@): %d", filename, (int)result);

  result = AudioFileGetProperty(audioFileID, kAudioFilePropertyDataFormat, &dataFormatSize, &dataFormat);
  //assert no error
  if (result != noErr)
    NSLog(@"Error getting file format (%@): %d", filename, (int)result);

  result = AudioFileGetProperty(audioFileID, kAudioFilePropertyAudioDataByteCount, &byteCountSize, &byteCount);

  if (result != noErr)
    NSLog(@"Error getting file data size (%@): %d", filename, (int)result);

  UInt32 byteCount32 = (UInt32)byteCount;

  soundData = malloc(byteCount32);

  result = AudioFileReadBytes(audioFileID, false, 0, &byteCount32, soundData);

  if (result != noErr)
    NSLog(@"Error reading file data (%@): %d", filename, (int)result);

  alGenBuffers(1, &soundBuffer);

  result = alGetError();
  if (result != AL_NO_ERROR)
    NSLog(@"Error generating buffer (%@): %x", filename, (int)result);

  ALenum alDataFormat;
  if (dataFormat.mFormatID != kAudioFormatLinearPCM)
    alDataFormat = -1;
  else if ((dataFormat.mChannelsPerFrame > 2) ||
      (dataFormat.mChannelsPerFrame < 1))
    alDataFormat = -1;
  else if (dataFormat.mBitsPerChannel == 8)
    alDataFormat = (dataFormat.mChannelsPerFrame == 1) ? AL_FORMAT_MONO8 : AL_FORMAT_STEREO8;
  else if (dataFormat.mBitsPerChannel == 16)
    alDataFormat = (dataFormat.mChannelsPerFrame == 1) ? AL_FORMAT_MONO16 : AL_FORMAT_STEREO16;
  else
    alDataFormat = -1;

  alBufferDataStaticProc(soundBuffer,
			 alDataFormat,
			 soundData,
			 byteCount32,
			 dataFormat.mSampleRate);

  result = alGetError();
  if (result != AL_NO_ERROR)
    NSLog(@"Error attaching data to buffer (%@): %x", filename, (int)result);

  AudioFileClose(audioFileID);

  alSourcei(source, AL_BUFFER, soundBuffer);

  alSourcef(source, AL_GAIN, soundEffectsMasterVolume);

  result = alGetError();
  if (result != AL_NO_ERROR)
    NSLog(@"Error attaching file data to effect (%@): %x", filename, (int)result);

  SoundParameters * sp = (SoundParameters *)malloc(sizeof(SoundParameters));
  sp->source = source;
  sp->buffer = soundBuffer;
  sp->data = soundData;
  sp->dataFormat = alDataFormat;
  sp->byteCount = byteCount32;
  sp->sampleRate = dataFormat.mSampleRate;
  [sounds setObject:[NSValue valueWithPointer:sp] forKey:filename];
}


+ (FlxSound *) play:(NSString *)EmbeddedSound;
{
  return [self playWithParam1:EmbeddedSound param2:1];
}
+ (FlxSound *) playWithParam1:(NSString *)EmbeddedSound param2:(float)Volume;
{
  return [self playWithParam1:EmbeddedSound param2:Volume param3:NO];
}
+ (FlxSound *) playWithParam1:(NSString *)EmbeddedSound param2:(float)Volume param3:(BOOL)Looped;
{
  NSValue * sound = [sounds objectForKey:EmbeddedSound];
  if (!sound) {
    [self loadSound:EmbeddedSound];
    sound = [sounds objectForKey:EmbeddedSound];
    if (!sound) {
      NSLog(@"unable to load sound: %@", EmbeddedSound);
      return nil;
    }
  }

  SoundParameters * sp = (SoundParameters *)[sound pointerValue];
  OSStatus result = AL_NO_ERROR;
  alSourcef(sp->source, AL_GAIN, Volume*soundEffectsMasterVolume);
  if (Looped)
    alSourcei(sp->source, AL_LOOPING, AL_TRUE);
  else
    alSourcei(sp->source, AL_LOOPING, AL_FALSE);
  alSourcePlay(sp->source);
  result = alGetError();
  if (result != AL_NO_ERROR)
    NSLog(@"Error playing sound: %@, error: %x", EmbeddedSound, (int)result);
  
//    unsigned int sl = sounds.length;
//    for ( unsigned int i = 0; i < sl; i++ )
//       if (!(((FlxSound *)([sounds objectAtIndex:i]))).active)
//          break;
//    if ([sounds objectAtIndex:i] == nil)
//       [sounds objectAtIndex:i] = [[[FlxSound alloc] init] autorelease];
//    FlxSound * s = [sounds objectAtIndex:i];
//    [s loadEmbeddedWithParam1:EmbeddedSound param2:Looped];
//    s.volume = Volume;
//    [s play];
//    return s;
  return nil;
}

+ (FlxSound *) play:(NSString *)EmbeddedSound withVolume:(float)Volume;
{
  return [self playWithParam1:EmbeddedSound param2:Volume];
}
+ (FlxSound *) play:(NSString *)EmbeddedSound withVolume:(float)Volume looped:(BOOL)Looped;
{
  return [self playWithParam1:EmbeddedSound param2:Volume param3:Looped];
}

+ (void) stop:(NSString *)EmbeddedSound;
{
  NSValue * sound = [sounds objectForKey:EmbeddedSound];
  if (!sound)
    return;

  SoundParameters * sp = (SoundParameters *)[sound pointerValue];
  OSStatus result = AL_NO_ERROR;
  alSourceStop(sp->source);
  result = alGetError();
  if (result != AL_NO_ERROR)
    NSLog(@"Error stopping sound: %@, error: %x", EmbeddedSound, (int)result);
}

+ (BOOL) playing:(NSString *)EmbeddedSound
{
  NSValue * sound = [sounds objectForKey:EmbeddedSound];
  if (!sound)
    return NO;

  SoundParameters * sp = (SoundParameters *)[sound pointerValue];
  OSStatus result = AL_NO_ERROR;
  int value;
  alGetSourcei(sp->source, AL_SOURCE_STATE, &value);
  result = alGetError();
  if (result != AL_NO_ERROR) {
    NSLog(@"Could not determine state for sound: %@, error: %x", EmbeddedSound, (int)result);
    return NO;
  }
  return value == AL_PLAYING;
}



+ (BOOL) checkBitmapCache:(NSString *)Key;
{
  return ([_cache objectForKey:Key] != nil); // && ([_cache objectForKey:Key] != nil);
}

+ (SemiSecretTexture *) addTextureWithParam1:(NSString *)Graphic param2:(BOOL)Unique;
{
  NSString * key = Graphic;
  if (Unique && [_cache objectForKey:key] != nil) {
    unsigned int inc = 0;
    NSString * ukey;
    do {
      ukey = [NSString stringWithFormat:@"%@%d", key, inc++];
    } while ([_cache objectForKey:ukey] != nil);
    key = ukey;
  }

  SemiSecretTexture * texture = [_cache objectForKey:key];
  if (texture == nil) {
    texture = [SemiSecretTexture textureWithImage:Graphic];
    [_cache setObject:texture forKey:key];
  }
  return texture;
}

+ (void) setTexture:(SemiSecretTexture *)Texture forKey:(NSString *)Key;
{
  [_cache setObject:Texture forKey:Key];
}

+ (SemiSecretTexture *) createBitmapWithParam1:(unsigned int)Width param2:(unsigned int)Height param3:(unsigned int)Color param4:(BOOL)Unique param5:(NSString *)Key;
{
  NSString * key = Key;
  if (key == nil) {
    key = [NSString stringWithFormat:@"%dx%d:%d", Width, Height, Color];
    if (Unique && [_cache objectForKey:key] != nil) {
      unsigned int inc = 0;
      NSString * ukey;
      do {
	ukey = [NSString stringWithFormat:@"%@%d", key, inc++];
      } while ([_cache objectForKey:ukey] != nil);
      key = ukey;
    }
  }
  SemiSecretTexture * texture = [_cache objectForKey:key];
  if (texture == nil) {
    //todo: how to make this the requested size? does it matter?
    texture = [SemiSecretTexture textureWithColor:Color];
    [_cache setObject:texture forKey:key];
  }
  return texture;
}

+ (void) setPauseFollow:(BOOL)newPauseFollow;
{
  pauseFollow = newPauseFollow;
}
+ (BOOL) pauseFollow;
{
  return pauseFollow;
}
+ (void) follow:(FlxObject *)Target;
{
  return [self followWithParam1:Target param2:1];
}
+ (void) followWithParam1:(FlxObject *)Target param2:(float)Lerp;
{
  pauseFollow = NO;
  [followTarget autorelease];
  followTarget = [Target retain];
  followLerp = Lerp;
//   if (_scrollTarget == nil) //why is this necessary?
//     _scrollTarget = [[FlashPoint alloc] init];
//   _scrollTarget.x = ((int)width >> 1) - followTarget.x - ((int)(followTarget.width) >> 1) + (((FlxSprite *)(followTarget))).offset.x;
//   _scrollTarget.y = ((int)height >> 1) - followTarget.y - ((int)(followTarget.height) >> 1) + (((FlxSprite *)(followTarget))).offset.y;
  _scrollTarget.x = ((int)width>>1)-followTarget.x-((int)(followTarget.width)>>1);
  _scrollTarget.y = ((int)height>>1)-followTarget.y-((int)(followTarget.height)>>1);
  scroll.x = _scrollTarget.x;
  scroll.y = _scrollTarget.y;
  [self doFollow];
}
+ (void) followAdjust;
{
  return [self followAdjust:0];
}
+ (void) followAdjust:(float)LeadX;
{
  return [self followAdjustWithParam1:LeadX param2:0];
}
+ (void) followAdjustWithParam1:(float)LeadX param2:(float)LeadY;
{
  [followLead autorelease];
  followLead = [[FlashPoint alloc] initWithX:LeadX y:LeadY];
}
+ (void) followBounds;
{
  return [self followBounds:0];
}
+ (void) followBounds:(int)MinX;
{
  return [self followBoundsWithParam1:MinX param2:0];
}
+ (void) followBoundsWithParam1:(int)MinX param2:(int)MinY;
{
  return [self followBoundsWithParam1:MinX param2:MinY param3:0];
}
+ (void) followBoundsWithParam1:(int)MinX param2:(int)MinY param3:(int)MaxX;
{
  return [self followBoundsWithParam1:MinX param2:MinY param3:MaxX param4:0];
}
+ (void) followBoundsWithParam1:(int)MinX param2:(int)MinY param3:(int)MaxX param4:(int)MaxY;
{
  return [self followBoundsWithParam1:MinX param2:MinY param3:MaxX param4:MaxY param5:YES];
}
+ (void) followBoundsWithParam1:(int)MinX param2:(int)MinY param3:(int)MaxX param4:(int)MaxY param5:(BOOL)UpdateWorldBounds;
{
  [followMin autorelease];
  followMin = [[FlashPoint alloc] initWithX:-MinX y:-MinY];
  [followMax autorelease];
  followMax = [[FlashPoint alloc] initWithX:-MaxX + width y:-MaxY + height];
  if (followMax.x > followMin.x)
    followMax.x = followMin.x;
  if (followMax.y > followMin.y)
    followMax.y = followMin.y;
  if (UpdateWorldBounds)
    [FlxU setWorldBoundsWithParam1:-MinX param2:-MinY param3:-MinX + MaxX param4:-MinY + MaxY];
  [self doFollow];
}
// - (Stage *) stage;
// {
//    if ((_game._state != nil) && (_game._state.parent != nil))
//       return _game._state.parent.stage;
//    return nil;
// }
// - (FlxState *) state;
// {
//    return _game._state;
// }
// - (void) state:(FlxState *)State;
// {
//    [_game switchState:State];
// }

+ (void) setGameData:(FlxGame *)Game width:(int)Width height:(int)Height zoom:(float)Zoom;
{
  //is SemiSecretGLView setup?
  [_game autorelease];
  _game = [Game retain];
  width = Width;
  height = Height;
  _mute = NO;
  //_volume = 0.5;

  

  [scroll autorelease];
  scroll = nil;
  [_scrollTarget autorelease];
  _scrollTarget = nil;
  [self unfollow];
  FlxG.levels = [[[NSMutableArray alloc] init] autorelease];
  FlxG.scores = [[[NSMutableArray alloc] init] autorelease];
  level = 0;
  score = 0;
  FlxU.seed = NAN;


  [quake autorelease];
  quake = [(FlxQuake *)[FlxQuake alloc] initWithParam1:Zoom];
  [flash autorelease];
  flash = [[FlxFlash alloc] init];
  [fade autorelease];
  fade = [[FlxFade alloc] init];

  [FlxU setWorldBounds];
}

+ (void) doFollow;
{
  if (!pauseFollow) {
    if (followTarget != nil) {
      _scrollTarget.x = ((int)width >> 1) - followTarget.x - ((int)(followTarget.width) >> 1);
      _scrollTarget.y = ((int)height >> 1) - followTarget.y - ((int)(followTarget.height) >> 1);
      if ((followLead != nil) && ([followTarget isKindOfClass:[FlxSprite class]])) {
	_scrollTarget.x -= (((FlxSprite *)(followTarget))).velocity.x * followLead.x;
	_scrollTarget.y -= (((FlxSprite *)(followTarget))).velocity.y * followLead.y;
      }
      scroll.x += (_scrollTarget.x - scroll.x) * followLerp * FlxG.elapsed;
      scroll.y += (_scrollTarget.y - scroll.y) * followLerp * FlxG.elapsed;
      if (followMin != nil) {
	if (scroll.x > followMin.x)
	  scroll.x = followMin.x;
	if (scroll.y > followMin.y)
	  scroll.y = followMin.y;
      }
      if (followMax != nil) {
	if (scroll.x < followMax.x)
	  scroll.x = followMax.x;
	if (scroll.y < followMax.y)
	  scroll.y = followMax.y;
      }
    }
  }
}

+ (void) unfollow;
{
  [followTarget autorelease];
  followTarget = nil;
  [followLead autorelease];
  followLead = nil;
  followLerp = 1;
  [followMin autorelease];
  followMin = nil;
  [followMax autorelease];
  followMax = nil;
  if (scroll == nil)
    scroll = [[FlashPoint alloc] init];
  else
    scroll.x = scroll.y = 0;
  if (_scrollTarget == nil)
    _scrollTarget = [[FlashPoint alloc] init];
  else
    _scrollTarget.x = _scrollTarget.y = 0;
}

// + (void) updateInput;
// {
//    [keys update];
//    [mouse updateWithParam1:state.mouseX param2:state.mouseY param3:scroll.x param4:scroll.y];
// }
@end
