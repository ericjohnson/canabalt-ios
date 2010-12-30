//
//  Dove.m
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

#import "Dove.h"
#import "Player.h"
#import <SemiSecret/SemiSecretTexture.h>

static NSString * ImgDove = @"dove.png";
static NSString * SndFlap1 = @"flap1.caf";
static NSString * SndFlap2 = @"flap2.caf";
static NSString * SndFlap3 = @"flap3.caf";

static const unsigned radius = 128;

static NSArray * flaps;

@interface Dove ()
- (id) initWithGLData:(DoveGLData *)glData texture:(SemiSecretTexture *)texture;
- (void) setupVertices;
- (void) setupTexCoords;
- (void) addAnimation:(NSString *)Name frames:(NSMutableArray *)Frames;
- (void) addAnimation:(NSString *)Name frames:(NSMutableArray *)Frames frameRate:(float)FrameRate;
- (void) updateAnimation;
@property (nonatomic,assign) unsigned int facing;
@end

@implementation DoveGroup

@synthesize visibleDoves;

+ (DoveGroup *) doveGroupWithDoveCount:(NSUInteger)doveCount
{
  return [[[self alloc] initWithDoveCount:doveCount] autorelease];
}

- (id) initWithDoveCount:(NSUInteger)DoveCount
{
  if ((self = [super init])) {
    texture = [[FlxG addTextureWithParam1:ImgDove param2:NO] retain];
    doveCount = DoveCount;
    glData = (DoveGLData *)malloc(sizeof(DoveGLData)*doveCount);
    for (int i=0; i<doveCount; i++) {
      Dove * dove = [[Dove alloc] initWithGLData:&(glData[i]) texture:texture];
      [members addObject:dove];
      [dove release];
    }
    visibleDoves = 0;
  }
  return self;
}

- (void) dealloc
{
  free(glData);
  [texture release];
  [super dealloc];
}

- (void) setVisibleDoves:(NSUInteger)VisibleDoves
{
  visibleDoves = MIN(VisibleDoves, doveCount);
}

- (void) render
{
  [FlxObject bind:texture.texture];

  glVertexPointer(2, GL_SHORT, sizeof(GLshort)*4, &(glData[0].p0));
  glTexCoordPointer(2, GL_SHORT, sizeof(GLshort)*4, &(glData[0].t0));

  glDrawArrays(GL_TRIANGLE_STRIP, 0, visibleDoves*6);
}

- (void) update
{
}

@end



@implementation Dove

@synthesize player;
@synthesize trigger;
@synthesize facing;

+ (void) initialize
{
  flaps = [[NSArray alloc] initWithObjects:SndFlap1, SndFlap2, SndFlap3, nil];
}

- (id) initWithGLData:(DoveGLData *)GLData texture:(SemiSecretTexture *)Texture
{
  if ((self = [super initWithX:0 y:0 width:0 height:0])) {
    glData = GLData;
    texture = [Texture retain];

    animations = [[NSMutableArray alloc] init];
    
    width = frameWidth = texture.size.height;
    height = frameHeight = texture.size.height;

    caf = 0;

    [self setupTexCoords];
    [self setupVertices];
    
    //TODO:
    [self addAnimation:@"idle" frames:[NSMutableArray intArrayWithSize:1 ints:3]];
    unsigned start = FlxU.random*3;
    [self addAnimation:@"fly" frames:[NSMutableArray intArrayWithSize:3 ints:start, (start+1)%3, (start+2)%3] frameRate:15];
    self.facing = FlxU.random > 0.5 ? 0 : 1;
    [self play:@"idle"];
  }
  return self;
}

- (void) setTrigger:(float)trgr
{
  trigger = trgr + FlxU.random*(self.x-trgr)*0.5;
}


- (void) dealloc
{
  [texture release];
  [animations release];
  self.player = nil;
  [super dealloc];
}

- (void) addAnimation:(NSString *)Name frames:(NSMutableArray *)Frames;
{
   return [self addAnimation:Name frames:Frames frameRate:0];
}
- (void) addAnimation:(NSString *)Name frames:(NSMutableArray *)Frames frameRate:(float)FrameRate;
{
   [animations push:[[(FlxAnim *)[FlxAnim alloc] initWithParam1:Name param2:Frames param3:FrameRate param4:YES] autorelease]];
}

- (void) play:(NSString *)animation
{
  curFrame = 0;
  caf = 0;
  frameTimer = 0;
  for (FlxAnim * anim in animations) {
    if ([anim.name compare:animation] == NSOrderedSame) {
      curAnim = anim;
      if (curAnim.delay <= 0)
        finished = YES;
      else
        finished = NO;
      caf = [[curAnim.frames objectAtIndex:curFrame] unsignedIntValue];
      [self setupTexCoords];
      return;
    }
  }
}

- (void) update
{
  if (player.x > trigger) {
    if (velocity.y == 0) {
      if (FlxU.random < 0.5) [FlxG play:[flaps objectAtIndex:FlxU.random*flaps.length]];
      [self play:@"fly"];
      velocity.y = -50 - FlxU.random*50;
      acceleration.y = -50 - FlxU.random*300;
      int vel = (player.velocity.x-300)*FlxU.random;
      acceleration.x = (self.facing == 0) ? vel : -vel;
    }
  }
  [self updateAnimation];
  [super update];
  [self setupVertices];
}

- (void) updateAnimation
{
  if ((curAnim != nil) && (curAnim.delay > 0) && (curAnim.looped || !finished)) {
    frameTimer += FlxG.elapsed;
    while (frameTimer > curAnim.delay) {
      frameTimer -= curAnim.delay;
      if (curFrame == curAnim.frames.length - 1) {
        if (curAnim.looped)
          curFrame = 0;
        finished = YES;
      }
      else
        curFrame++;
      caf = [[curAnim.frames objectAtIndex:curFrame] unsignedIntValue];
      [self setupTexCoords];
    }
  }
}


- (void) setExists:(BOOL)Exists
{
  [super setExists:Exists];
  [self setupVertices];
}

- (void) kill
{
  [super kill];
  [self setupVertices];
}

- (void) onEmit
{
}

- (void) setFacing:(unsigned int)f
{
  facing = f;
  [self setupVertices];
}

- (void) setVisible:(BOOL)v
{
  [super setVisible:v];
  [self setupVertices];
}

- (void) setActive:(BOOL)a
{
  [super setActive:a];
  [self setupVertices];
}

- (void) setupTexCoords
{
  int xframes = texture.size.width/frameWidth;

  GLshort uOffset = caf % xframes;
  GLshort vOffset = caf / xframes;

  GLshort uShort = [FlxGLView convertToShort:frameWidth/texture.paddedSize.width];
  GLshort vShort = [FlxGLView convertToShort:frameHeight/texture.paddedSize.height];
  
  if (texture.atlasTexture) {
    // http://www.cocos2d-iphone.org/forum/topic/8267
    // The correct texture mapping for a given rect (rx, ry, rw, rh) in an image of size w x h is:
    // rect origin is zero based so the top left pixel is 0,0
    //  ((2*rx)+1)/(2*w), ((2*ry)+1))/(2*h)
    //   to
    //  (((2*rx)+1)+(rw*2)-2)/(2*w), (((2*ry)+1))+(rh*2)-2)/(2*h)
    //
    // For example an atlas of size 256x256 that contains a sprite image at 10,10 with size 100x100 the correct texture coordinates for each vertex are as follows:
    // 21/512, 21/512        -> (2*10+1)/(2*256)
    // 21/512, 219/512
    // 219/512, 219/512
    // 219/512, 21/512

    //TODO: why the extra *2 scale factor?
    CGRect r = CGRectMake(texture.offset.x + frameWidth * uOffset,
                          texture.offset.y + frameHeight * vOffset,
                          frameWidth * 2,
                          frameHeight * 2);
    CGPoint tl = CGPointMake((2*r.origin.x+1)/(2*texture.atlasTexture.paddedSize.width),
                             (2*r.origin.y+1)/(2*texture.atlasTexture.paddedSize.height));
    CGPoint br = CGPointMake((2*r.origin.x + 1 + r.size.width - 2)/(2*texture.atlasTexture.paddedSize.width),
                             (2*r.origin.y + 1 + r.size.height - 2)/(2*texture.atlasTexture.paddedSize.height));
                          
    glData->t1[0] = (GLshort)([FlxGLView convertToShort:tl.x]);
    glData->t1[1] = (GLshort)([FlxGLView convertToShort:tl.y]);
    glData->t2[0] = (GLshort)([FlxGLView convertToShort:br.x]);
    glData->t2[1] = (GLshort)([FlxGLView convertToShort:tl.y]);
    glData->t3[0] = (GLshort)([FlxGLView convertToShort:tl.x]);
    glData->t3[1] = (GLshort)([FlxGLView convertToShort:br.y]);
    glData->t4[0] = (GLshort)([FlxGLView convertToShort:br.x]);
    glData->t4[1] = (GLshort)([FlxGLView convertToShort:br.y]);
  } else {
    glData->t1[0] = uOffset*uShort;
    glData->t1[1] = vOffset*vShort;
    glData->t2[0] = (uOffset+1)*uShort;
    glData->t2[1] = vOffset*vShort;
    glData->t3[0] = uOffset*uShort;
    glData->t3[1] = (vOffset+1)*vShort;
    glData->t4[0] = (uOffset+1)*uShort;
    glData->t4[1] = (vOffset+1)*vShort;
  }
  
}

- (void) setupVertices
{
  if (visible && exists && active) {
    CGPoint p = [self getScreenXY];
    p.x = p.x + frameWidth/2.0;
    p.y = p.y + frameHeight/2.0;
    
    CGPoint p1 = CGPointMake(-(frameWidth/2.0),
                             -(frameHeight/2.0));
    CGPoint p2 = CGPointMake(frameWidth/2.0,
                             -(frameHeight/2.0));
    CGPoint p3 = CGPointMake(-(frameWidth/2.0),
                             frameHeight/2.0);
    CGPoint p4 = CGPointMake(frameWidth/2.0,
                             frameHeight/2.0);

    if (facing == 0) {
      glData->p1[0] = (GLshort)(p1.x + p.x);
      glData->p1[1] = (GLshort)(p1.y + p.y);
      glData->p2[0] = (GLshort)(p2.x + p.x);
      glData->p2[1] = (GLshort)(p2.y + p.y);
      glData->p3[0] = (GLshort)(p3.x + p.x);
      glData->p3[1] = (GLshort)(p3.y + p.y);
      glData->p4[0] = (GLshort)(p4.x + p.x);
      glData->p4[1] = (GLshort)(p4.y + p.y);
    } else {
      glData->p1[0] = (GLshort)(p2.x + p.x);
      glData->p1[1] = (GLshort)(p2.y + p.y);
      glData->p2[0] = (GLshort)(p1.x + p.x);
      glData->p2[1] = (GLshort)(p1.y + p.y);
      glData->p3[0] = (GLshort)(p4.x + p.x);
      glData->p3[1] = (GLshort)(p4.y + p.y);
      glData->p4[0] = (GLshort)(p3.x + p.x);
      glData->p4[1] = (GLshort)(p3.y + p.y);
    }

    glData->p0[0] = glData->p1[0];
    glData->p0[1] = glData->p1[1];
    glData->p5[0] = glData->p4[0];
    glData->p5[1] = glData->p4[1];
  } else {
    glData->p0[0] = 0;
    glData->p0[1] = 0;
    glData->p1[0] = 0;
    glData->p1[1] = 0;
    glData->p2[0] = 0;
    glData->p2[1] = 0;
    glData->p3[0] = 0;
    glData->p3[1] = 0;
    glData->p4[0] = 0;
    glData->p4[1] = 0;
    glData->p5[0] = 0;
    glData->p5[1] = 0;
  }
}

- (void) render
{
}

@end
