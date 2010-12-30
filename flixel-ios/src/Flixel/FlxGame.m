//
//  FlxGame.m
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
#import <SemiSecret/SemiSecret.h>
#import <UIKit/UIKit.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>

#include <unistd.h>

//essentially locks the framerate to 30fps minimum
//static float MAX_ELAPSED = 0.0333;
//20fps minimum

//static float MAX_ELAPSED = 0.05;

// static NSString * junk = @"data/nokiafc22.ttf";
// static NSString * SndBeep = @"data/beep.mp3";
// static NSString * SndFlixel = @"data/flixel.mp3";

static unsigned int slowdown = 0;
static unsigned int slowdownCounter = 0;

static GLuint textureFrameBuffer = 0;
static GLuint renderTexture = 0;
static GLshort renderVerticesUVs[4*2*2];
static unsigned int textureWidth;
static unsigned int textureHeight;

static BOOL gameStarted = NO;
static CFTimeInterval gameStart;

@interface FlxG ()
+ (void) setGameData:(FlxGame *)Game width:(int)width height:(int)height zoom:(float)Zoom;
+ (void) doFollow;
+ (void) unfollow;
@end


@implementation FlxGame

@synthesize gameOrientation, autorotate;
@dynamic zoom;
@synthesize textureBufferZoom, modelZoom;
@synthesize currentOrientation;
@dynamic paused;
@synthesize frameInterval;
@synthesize window;

- (BOOL) paused
{
  return _paused;
}

- (void) setPaused:(BOOL)paused;
{
  _paused = paused;
  //update state?
  if (_state)
    [_state setPaused:_paused];
}

- (float) zoom
{
  return _zoom;
}

+ (void) setSlowdown:(unsigned int)newSlowdown
{
  slowdown = newSlowdown;
  slowdownCounter = 0;
}

+ (unsigned int) slowdown;
{
  return slowdown;
}

- (id) initWithOrientation:(FlxGameOrientation)GameOrientation state:(NSString *)InitialState;
{
  return [self initWithOrientation:GameOrientation state:InitialState zoom:2.0];
}

- (id) initWithOrientation:(FlxGameOrientation)GameOrientation
		     state:(NSString *)InitialState
		      zoom:(float)Zoom;
{
  return [self initWithOrientation:GameOrientation state:InitialState zoom:Zoom useTextureBufferZoom:NO];
}


- (id) initWithOrientation:(FlxGameOrientation)GameOrientation
		     state:(NSString *)InitialState
		      zoom:(float)Zoom
     useTextureBufferZoom:(BOOL)TextureBufferZoom;
{
  return [self initWithOrientation:GameOrientation state:InitialState zoom:Zoom useTextureBufferZoom:TextureBufferZoom modelZoom:1.0];
}  

- (id) initWithOrientation:(FlxGameOrientation)GameOrientation
		     state:(NSString *)InitialState
		      zoom:(float)Zoom
      useTextureBufferZoom:(BOOL)TextureBufferZoom
		 modelZoom:(float)ModelZoom;
{
  if ((self = [super init])) {
    _zoom = Zoom;

    textureBufferZoom = TextureBufferZoom;
    modelZoom = ModelZoom;

    iPad = FlxG.iPad;

    //set a reasonable default
    if (FlxG.iPad)
      self.frameInterval = 1;
    else
      self.frameInterval = 2;
    
    gameStart = CFAbsoluteTimeGetCurrent();
    
    autorotate = YES;
    gameOrientation = GameOrientation;
    
    recursing = NO;
    
    //register for device orientation notifications
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    UIDeviceOrientation o = [UIDevice currentDevice].orientation;
    switch (gameOrientation) {
    case FlxGameOrientationLandscape:
      {
	switch (o) {
	case UIDeviceOrientationLandscapeRight:
	  currentOrientation = UIDeviceOrientationLandscapeRight;
          [[UIApplication sharedApplication] setStatusBarOrientation:currentOrientation];
	  autorotateAngle = 180;
	  autorotateAngleGoal = 180;
	  break;
	case UIDeviceOrientationLandscapeLeft:
	case UIDeviceOrientationPortraitUpsideDown:
	case UIDeviceOrientationPortrait:
	default:
	  currentOrientation = UIDeviceOrientationLandscapeLeft;
          [[UIApplication sharedApplication] setStatusBarOrientation:currentOrientation];
	  autorotateAngle = 0;
	  autorotateAngleGoal = 0;
	  break;
	}
	break;
      }
    case FlxGameOrientationPortrait:
      {
	switch (o) {
	case UIDeviceOrientationPortraitUpsideDown:
	  currentOrientation = UIDeviceOrientationPortraitUpsideDown;
          [[UIApplication sharedApplication] setStatusBarOrientation:currentOrientation];
	  autorotateAngle = 180;
	  autorotateAngleGoal = 180;
	  break;
	case UIDeviceOrientationPortrait:
	case UIDeviceOrientationLandscapeLeft:
	case UIDeviceOrientationLandscapeRight:
	default:
	  currentOrientation = UIDeviceOrientationPortrait;
          [[UIApplication sharedApplication] setStatusBarOrientation:currentOrientation];
	  autorotateAngle = 0;
	  autorotateAngleGoal = 0;
	  break;
	}
      }
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
					  selector:@selector(deviceOrientationDidChange:)
					  name:UIDeviceOrientationDidChangeNotification
					  object:nil];
    
    //do this before calling FlxG
    //create a window, and add glView to it
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //window.transform = CGAffineTransformMakeRotation(3*M_PI/2);
    
    FlxGLView * glView = [[FlxGLView alloc] initWithFrame:window.bounds];
    //FlxGLView * glView = [[FlxGLView alloc] initWithFrame:CGRectMake(0,0,window.bounds.size.width/2,window.bounds.size.height/2)];
    //glView.transform = CGAffineTransformMakeScale(2.0,2.0);
    context = [glView.context retain];
    renderBuffer = glView.renderBuffer;
    frameBuffer = glView.frameBuffer;
    backingWidth = glView.backingWidth;
    backingHeight = glView.backingHeight;

    [window makeKeyAndVisible];
    
    [window addSubview:glView];
    glView.center = CGPointMake(window.bounds.size.width/2,
				window.bounds.size.height/2);
    [glView release];

    //which way are we oriented?
    if (textureBufferZoom) {
      if (FlxG.retinaDisplay) {
        if (gameOrientation == FlxGameOrientationPortrait)
          [FlxG setGameData:self
                      width:(int)(glView.bounds.size.width/_zoom)
                     height:(int)(glView.bounds.size.height/_zoom)
                       zoom:Zoom];
        else
          [FlxG setGameData:self
                      width:(int)(glView.bounds.size.height/_zoom)
                     height:(int)(glView.bounds.size.width/_zoom)
                       zoom:Zoom];
      } else {
        if (gameOrientation == FlxGameOrientationPortrait)
          [FlxG setGameData:self
                      width:(int)(glView.bounds.size.width/_zoom/2)
                     height:(int)(glView.bounds.size.height/_zoom/2)
                       zoom:Zoom];
        else
          [FlxG setGameData:self
                      width:(int)(glView.bounds.size.height/_zoom/2)
                     height:(int)(glView.bounds.size.width/_zoom/2)
                       zoom:Zoom];
      }
    } else {
      if (FlxG.retinaDisplay) {
        if (gameOrientation == FlxGameOrientationPortrait)
          [FlxG setGameData:self
                      width:(int)(glView.bounds.size.width)
                     height:(int)(glView.bounds.size.height)
                       zoom:Zoom];
        else
          [FlxG setGameData:self
                      width:(int)(glView.bounds.size.height)
                     height:(int)(glView.bounds.size.width)
                       zoom:Zoom];
      } else {
        if (gameOrientation == FlxGameOrientationPortrait)
          [FlxG setGameData:self
                      width:(int)(glView.bounds.size.width/_zoom)
                     height:(int)(glView.bounds.size.height/_zoom)
                       zoom:Zoom];
        else
          [FlxG setGameData:self
                      width:(int)(glView.bounds.size.height/_zoom)
                     height:(int)(glView.bounds.size.width/_zoom)
                       zoom:Zoom];
      }        
    }      

    _iState = [InitialState copy];
    
    [EAGLContext setCurrentContext:context];

  }
  return self;
}

- (void) start
{

  if (textureFrameBuffer == 0 && textureBufferZoom)
    glGenFramebuffersOES(1, &textureFrameBuffer);
    
  

  if (renderTexture == 0 && textureBufferZoom) {
    GLint lastTexture;
    //todo
    //hardcode this stuff -> assume rotated, like in canabalt
    int halfWidth = backingHeight/2;
    int halfHeight = backingWidth/2;
    textureWidth = halfWidth;
    textureHeight = halfHeight;
    if (halfWidth != 1 && (halfWidth & (halfWidth-1))) {
      textureWidth = 1;
      while (textureWidth < halfWidth)
	textureWidth <<= 1;
    }
    if (halfHeight != 1 && (halfHeight & (halfHeight-1))) {
      textureHeight = 1;
      while (textureHeight < halfHeight)
	textureHeight <<= 1;
    }
    GLubyte * data = malloc(textureWidth*4*textureHeight);
    glGetIntegerv(GL_TEXTURE_2D, &lastTexture);
    glGenTextures(1, &renderTexture);
    glBindTexture(GL_TEXTURE_2D, renderTexture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, textureWidth, textureHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
    glBindTexture(GL_TEXTURE_2D, lastTexture);
    free(data);

    renderVerticesUVs[0] = 0;
    renderVerticesUVs[1] = 0;
    renderVerticesUVs[4] = textureWidth;
    renderVerticesUVs[5] = 0;
    renderVerticesUVs[8] = 0;
    renderVerticesUVs[9] = textureHeight;
    renderVerticesUVs[12] = textureWidth;
    renderVerticesUVs[13] = textureHeight;

    renderVerticesUVs[2] = 0;
    renderVerticesUVs[3] = 0;
    renderVerticesUVs[6] = [FlxGLView convertToShort:1.0];
    renderVerticesUVs[7] = 0;
    renderVerticesUVs[10] = 0;
    renderVerticesUVs[11] = [FlxGLView convertToShort:1.0];
    renderVerticesUVs[14] = [FlxGLView convertToShort:1.0];
    renderVerticesUVs[15] = [FlxGLView convertToShort:1.0];
  }

  int blackScale = 1;
  if (textureBufferZoom)
    blackScale = 2;
  switch (gameOrientation) {
  case FlxGameOrientationPortrait:
    blackVertices[0] = -backingWidth/2/_zoom/blackScale;
    blackVertices[1] = -backingHeight/2/_zoom/blackScale;
    blackVertices[2] = 0;
    blackVertices[3] = 0;
    blackVertices[4] = 3*backingWidth/2/_zoom/blackScale;
    blackVertices[5] = -backingHeight/2/_zoom/blackScale;
    blackVertices[6] = backingWidth/_zoom/blackScale;
    blackVertices[7] = 0;
    blackVertices[8] = 3*backingWidth/2/_zoom/blackScale;
    blackVertices[9] = 3*backingHeight/2/_zoom/blackScale;
    blackVertices[10] = backingWidth/_zoom/blackScale;
    blackVertices[11] = backingHeight/_zoom/blackScale;
    blackVertices[12] = -backingWidth/2/_zoom/blackScale;
    blackVertices[13] = 3*backingHeight/2/_zoom/blackScale;
    blackVertices[14] = 0;
    blackVertices[15] = backingHeight/_zoom/blackScale;
    blackVertices[16] = -backingWidth/2/_zoom/blackScale;
    blackVertices[17] = -backingHeight/2/_zoom/blackScale;
    blackVertices[18] = 0;
    blackVertices[19] = 0;
    break;
  case FlxGameOrientationLandscape:
    blackVertices[0] = -backingHeight/2/_zoom/blackScale;
    blackVertices[1] = -backingWidth/2/_zoom/blackScale;
    blackVertices[2] = 0;
    blackVertices[3] = 0;
    blackVertices[4] = 3*backingHeight/2/_zoom/blackScale;
    blackVertices[5] = -backingWidth/2/_zoom/blackScale;
    blackVertices[6] = backingHeight/_zoom/blackScale;
    blackVertices[7] = 0;
    blackVertices[8] = 3*backingHeight/2/_zoom/blackScale;
    blackVertices[9] = 3*backingWidth/2/_zoom/blackScale;
    blackVertices[10] = backingHeight/_zoom/blackScale;
    blackVertices[11] = backingWidth/_zoom/blackScale;
    blackVertices[12] = -backingHeight/2/_zoom/blackScale;
    blackVertices[13] = 3*backingWidth/2/_zoom/blackScale;
    blackVertices[14] = 0;
    blackVertices[15] = backingWidth/_zoom/blackScale;
    blackVertices[16] = -backingHeight/2/_zoom/blackScale;
    blackVertices[17] = -backingWidth/2/_zoom/blackScale;
    blackVertices[18] = 0;
    blackVertices[19] = 0;
    break;
  }

  for (int i=0; i<10*4; i+=4) {
    blackColors[i] = 0x00;
    blackColors[i+1] = 0x00;
    blackColors[i+2] = 0x00;
    blackColors[i+3] = 0xff;
  }
    
    
  //make context current...
  [EAGLContext setCurrentContext:context];
  if (textureBufferZoom) {
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, textureFrameBuffer);
    glFramebufferTexture2DOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_TEXTURE_2D, renderTexture, 0);
  }  else {
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, frameBuffer);
  }
  glBindRenderbufferOES(GL_RENDERBUFFER_OES, renderBuffer);

  glDisable(GL_DITHER);
  
  //set up opengl stuff
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrthof(0, backingWidth/_zoom, backingHeight/_zoom, 0, -1, 1);

  glMatrixMode(GL_TEXTURE);
  glLoadIdentity();
  glScalef(1/FlxGLView.textureScale, 1/FlxGLView.textureScale, 1.0);

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();

  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  glDisableClientState(GL_COLOR_ARRAY);
  glEnable(GL_TEXTURE_2D);
  //glDisable(GL_TEXTURE_2D);
  glEnable(GL_COLOR_MATERIAL);
  glDisable(GL_DEPTH_TEST);
  glEnable(GL_BLEND);
  //glDisable(GL_BLEND);
  glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
  glDisable(GL_ALPHA_TEST);
    
  //orientations stuff was here...

  
  _elapsed = 0;
  _total = 0;
  //pause
  _state = nil;
  //useDefaultHotKeys
  _frame = nil;
  _gameXOffset = 0;
  _gameYOffset = 0;
  _paused = NO;
  _created = NO;
  //set up run loop here...
  //addEventListener -> onEnterFrame



  //TODO:
  //set up the Preloader stuff here...

  //need to know the background color here!
  Class stateClass = NSClassFromString(_iState);
  //FlxState * newState = nil;
  if (stateClass) {
    newState = [[stateClass alloc] init];
    //preProcess sets the clear color
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, frameBuffer);
    [newState preProcess];
    glClear(GL_COLOR_BUFFER_BIT);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
  }


  //TODO: make sure we choose the correct image here!
  if (FlxG.iPad) {
    defaultView = [(UIImageView *)[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-Portrait.png"]];
  } else {
    defaultView = [(UIImageView *)[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
  }
  [window addSubview:defaultView];
  defaultView.opaque = NO;
  defaultView.center = CGPointMake(window.bounds.size.width/2, window.bounds.size.height/2);
//   if (FlxG.iPad)
//     defaultView.transform = CGAffineTransformMakeRotation(M_PI/2);
  [defaultView release];


  [self performSelector:@selector(setupDisplay)
	withObject:nil
	afterDelay:0.1];
}

- (void) setupDisplay
{

// - (void) fadeOutDefaultViewAnimation:(NSString *)animationID didStop:(BOOL)didStop context:(void *)context
// {
//   //[defaultView removeFromSuperview];

  displayLinkSupported = NO;

  displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(update)];
  if (displayLink &&
      [displayLink respondsToSelector:@selector(setFrameInterval:)] &&
      [displayLink respondsToSelector:@selector(addToRunLoop:forMode:)])
    displayLinkSupported = YES;
  
  //DEBUG!!
  //displayLinkSupported = NO;
  
  if (displayLinkSupported == NO) {
    [NSThread detachNewThreadSelector:@selector(runThreadedGameLoop)
	      toTarget:self
	      withObject:nil];
  } else {
    [displayLink setFrameInterval:frameInterval];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop]
		 forMode:NSDefaultRunLoopMode];
  }

}


- (void) dealloc
{
//   if (displayLink)
//     [displayLink release];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
  [context release];
  [window release];
  [super dealloc];
}

- (void) resetProjection;
{
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrthof(0, backingWidth/_zoom, backingHeight/_zoom, 0, -1, 1);
  glMatrixMode(GL_MODELVIEW);
}

- (void) deviceOrientationDidChange:(NSNotification *)note
{
  orientation = [[UIDevice currentDevice] orientation];
  if (autorotate) {
    if (gameOrientation == FlxGameOrientationPortrait) {
      if (currentOrientation != orientation) {
	if (orientation == UIDeviceOrientationPortrait ||
	    orientation == UIDeviceOrientationPortraitUpsideDown) {
	  currentOrientation = orientation;
          //set up status bar
          [[UIApplication sharedApplication] setStatusBarOrientation:currentOrientation];
	  if (currentOrientation == UIDeviceOrientationPortrait)
	    autorotateAngleGoal = 0;
	  else
	    autorotateAngleGoal = 180;
	  if (gameStarted == NO)
	    autorotateAngle = autorotateAngleGoal;
	}
      }
    } else { //FlxGameOrientationLandscape
      switch (orientation) {
      case UIDeviceOrientationUnknown:
      case UIDeviceOrientationPortrait:
      case UIDeviceOrientationPortraitUpsideDown:
      case UIDeviceOrientationFaceUp:
      case UIDeviceOrientationFaceDown:
	if (currentOrientation == UIDeviceOrientationLandscapeRight)
	  orientation = UIDeviceOrientationLandscapeRight;
	else
	  orientation = UIDeviceOrientationLandscapeLeft;
      }
      if (currentOrientation != orientation) {
	currentOrientation = orientation;
        //set up status bar
        [[UIApplication sharedApplication] setStatusBarOrientation:currentOrientation];
	if (currentOrientation == UIDeviceOrientationLandscapeRight)
	  autorotateAngleGoal = 180;
	else
	  autorotateAngleGoal = 0;
	if (gameStarted == NO)
	  autorotateAngle = autorotateAngleGoal;
      }
    }
  }
}

- (void) showSoundTray;
{
}

- (void) showSoundTray:(BOOL)Silent;
{
}

- (void) switchState:(FlxState *)State;
{

  
  [FlxG unfollow];
  //[FlxG resetInput];
  //[FlxG destroySounds];
  [[FlxG flash] stop];
  [[FlxG fade] stop];
  [[FlxG quake] stop];
  //_buffer.x = 0;
  //_buffer.y = 0;
  //reset location of opengl view

  //_buffer.addChild(State) // ?
  if (_state != nil) {
    [_state destroy];
    //_buffer.swapChildren(State,_state); // ?
    //_buffer.removeChild(_state); // ?
  }
  [_state autorelease];
  _state = [State retain];

  
  //Finally, create the new state
  [_state create];
}

// #ifdef THREADED
- (void) runThreadedGameLoop
{
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  while (![[NSThread currentThread] isCancelled]) {
    [self performSelectorOnMainThread:@selector(update)
	  withObject:nil
	  waitUntilDone:YES];
    usleep(200);
  }
  [pool release];
}
// #else
// static BOOL recursing = NO;
// #endif


- (void) update
{

  if (displayLinkSupported == YES) {
    if (recursing)
      return;
    //get this out of the way at the beginning, hopefully will only be touch events?
    recursing = YES;
    int eventsHandled = 0;
    while (CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.001f, YES) == kCFRunLoopRunHandledSource &&
	   eventsHandled < 1) { eventsHandled++; }
    recursing = NO;
  }
    
  if (slowdown != 0) {
    slowdownCounter++;
    if (slowdownCounter < slowdown)
      return;
    slowdownCounter = 0;
  }

  
//   static float accumulator = 0.0f;
//   const float dt = 1.0/60.0; // * FlxG.timeScale;
//  const float dt = 1.0/45.0;
  
  static int iterations = 0;
  static CFTimeInterval fpsBegin = 0;
  
  //NSLog(@"update...");

  //this call is redundant, since we don't switch contexts
  //[EAGLContext setCurrentContext:context];

  float actualAngle = 0.0;
  
  static CFTimeInterval last = 0.0;
  CFTimeInterval now = CFAbsoluteTimeGetCurrent();
  _elapsed = (now - last);
  last = now;

  if (gameStarted == NO) {
    gameStart = now;
    gameStarted = YES;
  }
  
  FlxG.elapsed = _elapsed;
  if (_elapsed > FlxG.maxElapsed && slowdown == 0)
    FlxG.elapsed = FlxG.maxElapsed;
  FlxG.elapsed *= FlxG.timeScale;
  
#define ITERATIONS_PER_FPS 256
  
  if (iterations%ITERATIONS_PER_FPS == 0) {
    //NSLog(@"FPS: %0.0f", ITERATIONS_PER_FPS/(now-fpsBegin));
    iterations = 0;
    fpsBegin = now;
  }
  
  iterations++;
  

  //soundtray stuff here ?

  //redundant on iphone (not ipad), since we only bind one framebuffer
  if (textureBufferZoom) {
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, textureFrameBuffer);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(0, backingHeight/2, backingWidth/2, 0, -1, 1);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    //flip and shift...
    glScalef(-1.0, 1.0, 1.0);
    glTranslatef(-backingHeight/2, 0, 0);
  }
  
  if (_created) {

    if (defaultView) {
      [defaultView removeFromSuperview];
      defaultView = nil;
    }
    
    //[FlxG updateInput];
    [[FlxG touches] update];
    [FlxG updateSounds];

    if (_paused) {
      //[pause update];
    } else {

      [FlxG doFollow];
      [_state update];
      if (FlxG.flash.exists)
	[[FlxG flash] update];
      if (FlxG.fade.exists)
	[[FlxG fade] update];
      [[FlxG quake] update];
      
    }

    [_state preProcess];

    if (textureBufferZoom)
      glViewport(0, 0, backingHeight/2, backingWidth/2);
    else
      glViewport(0, 0, backingWidth, backingHeight);

    //NSLog(@"x:%d, y:%d, w:%d, h:%d", FlxG.quake.x, FlxG.quake.y, backingWidth, backingHeight);
    
    glPushMatrix();

    if (autorotateAngle != autorotateAngleGoal) {
      if (autorotateAngle < autorotateAngleGoal)
	autorotateAngle += FlxG.elapsed*300;
      else
	autorotateAngle -= FlxG.elapsed*300;
      if (autorotateAngle < 0)
	autorotateAngle = 0;
      if (autorotateAngle > 180.0)
	autorotateAngle = 180.0;
    }

    float x = (autorotateAngle/180.0);
    float s_x = 3*x*x - 2*x*x*x;
    actualAngle = s_x*180.0;
    
    if (!textureBufferZoom) {
      switch (gameOrientation) {
      case FlxGameOrientationPortrait:
	glTranslatef(backingWidth/2/_zoom, backingHeight/2/_zoom, 0);
	glRotatef(actualAngle, 0, 0, 1);
	glTranslatef(-backingWidth/2/_zoom, -backingHeight/2/_zoom, 0);
	break;
      default:
      case FlxGameOrientationLandscape:
	glTranslatef(backingWidth/2/_zoom, backingHeight/2/_zoom, 0);
	glRotatef(90+actualAngle, 0, 0, 1);
	glTranslatef(-backingHeight/2/_zoom, -backingWidth/2/_zoom, 0);
	break;
      }
    }
    
    glClear(GL_COLOR_BUFFER_BIT);

    //zero out the x component just for canabalt
    if (!textureBufferZoom)
      glTranslatef(FlxG.quake.x, FlxG.quake.y, 0);

    glPushMatrix();
    
    [_state render];
    if (FlxG.flash.exists)
      [[FlxG flash] render];
    if (FlxG.fade.exists)
      [[FlxG fade] render];
    

    glPopMatrix();
    
    //draw black border around edge of screen to mask when we rotate
    if (!textureBufferZoom) {
      [FlxObject unbind];
      glDisable(GL_BLEND);

//       glDisableClientState(GL_TEXTURE_COORD_ARRAY);
//       glEnableClientState(GL_VERTEX_ARRAY);
      
      glEnableClientState(GL_COLOR_ARRAY);
      glColorPointer(4, GL_UNSIGNED_BYTE, 0, blackColors);
      glVertexPointer(2, GL_SHORT, sizeof(GLshort)*2, blackVertices);
      glDrawArrays(GL_TRIANGLE_STRIP, 0, 10);
      glDisableClientState(GL_COLOR_ARRAY);
      glEnable(GL_BLEND);

//       glEnableClientState(GL_TEXTURE_COORD_ARRAY);

    }
      
    glPopMatrix();
      
    [_state postProcess];
    
  } else {

    
    _created = YES;

//     Class stateClass = NSClassFromString(_iState);
//     FlxState * newState = nil;
//     if (stateClass) {
//       newState = [[stateClass alloc] init];
    if (newState) {
      [self switchState:newState];
      [newState preProcess];
      [newState release];
    }
    glClear(GL_COLOR_BUFFER_BIT);

  }


  if (textureBufferZoom) {
    glDisable(GL_BLEND);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, frameBuffer);
    glPushMatrix();

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(0, backingWidth/2, backingHeight/2, 0, -1, 1);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
  
    glViewport(0, 0, backingWidth, backingHeight);

    switch (gameOrientation) {
    case FlxGameOrientationPortrait:
      glTranslatef(backingWidth/2/2, backingHeight/2/2, 0);
      glRotatef(actualAngle, 0, 0, 1);
      glTranslatef(-backingWidth/2/2, -backingHeight/2/2, 0);
      break;
    default:
    case FlxGameOrientationLandscape:
      glTranslatef(backingWidth/2/2, backingHeight/2/2, 0);
      glRotatef(-90+actualAngle, 0, 0, 1);
      glTranslatef(-backingHeight/2/2, -backingWidth/2/2, 0);
      break;
    }

    glTranslatef(FlxG.quake.x*2, FlxG.quake.y*2, 0);

    glClear(GL_COLOR_BUFFER_BIT);
    
    [FlxObject unbind];

//     glDisableClientState(GL_COLOR_ARRAY);
//     glEnableClientState(GL_VERTEX_ARRAY);
//     glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glBindTexture(GL_TEXTURE_2D, renderTexture);
    glVertexPointer(2, GL_SHORT, 4*sizeof(GLshort), &renderVerticesUVs[0]);
    glTexCoordPointer(2, GL_SHORT, 4*sizeof(GLshort), &renderVerticesUVs[2]);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    //glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glBindTexture(GL_TEXTURE_2D, 0);
    glEnableClientState(GL_COLOR_ARRAY);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, blackColors);
    glVertexPointer(2, GL_SHORT, sizeof(GLshort)*2, blackVertices);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 10);
    glDisableClientState(GL_COLOR_ARRAY);

    //glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glPopMatrix();
    
    glEnable(GL_BLEND);
  }  
  
  //this call is redundant, since we only have one render buffer
  //glBindRenderbufferOES(GL_RENDERBUFFER_OES, renderBuffer);

  [context presentRenderbuffer:GL_RENDERBUFFER_OES];
  
}

- (void) didEnterBackground;
{
  //gauranteed to be a display link if we are in ios 4
  NSLog(@"didEnterBackground");
  if (displayLink == nil)
    return;
  NSLog(@"removing display link from runloop");
  [displayLink invalidate];
  displayLink = nil;
}

- (void) willEnterForeground;
{
  //gauranteed to be a display link if we are in ios 4
  NSLog(@"willEnterForeground");
  if (displayLink != nil)
    return;
  NSLog(@"creating new displayLink");
  displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(update)];
  [displayLink setFrameInterval:self.frameInterval];
  [displayLink addToRunLoop:[NSRunLoop currentRunLoop]
	       forMode:NSDefaultRunLoopMode];
}

@end
