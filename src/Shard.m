//
//  Shard.m
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

#import "Shard.h"

static NSString * SndGlass1 = @"glass1.caf";
static NSString * SndGlass2 = @"glass2.caf";
static NSArray * shardSounds = nil;

@interface Shard ()
- (id) initWithGLData:(ShardGLData *)glData;
- (void) setupVertices;
@end

@implementation ShardEmitter

+ (ShardEmitter *) shardEmitterWithShardCount:(NSUInteger)shardCount
{
  return [[[self alloc] initWithShardCount:shardCount] autorelease];
}

- (id) initWithShardCount:(NSUInteger)ShardCount
{
  if ((self = [super init])) {
    shardCount = ShardCount;
    glData = (ShardGLData *)malloc(sizeof(ShardGLData)*shardCount);
    for (int i=0; i<shardCount; i++) {
      Shard * shard = [[Shard alloc] initWithGLData:&(glData[i])];
      [members addObject:shard];
      [shard release];
    }
  }
  return self;
}

- (void) dealloc
{
  free(glData);
  [super dealloc];
}

- (void) render
{
  glDisable(GL_BLEND);

  [FlxObject unbind];

  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glEnableClientState(GL_COLOR_ARRAY);
  glColorPointer(4, GL_UNSIGNED_BYTE, sizeof(GLshort)*2 + sizeof(GLubyte)*4, &(glData[0].c0));
  glVertexPointer(2, GL_SHORT, sizeof(GLshort)*2 + sizeof(GLubyte)*4, &(glData[0].p0));
  glDrawArrays(GL_TRIANGLE_STRIP, 0, shardCount*5);

  glDisableClientState(GL_COLOR_ARRAY);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);

  glEnable(GL_BLEND);
}

@end

@implementation Shard

+ (void) initialize
{
  shardSounds = [[NSArray alloc] initWithObjects:SndGlass1, SndGlass2, nil];
}

+ (id) shard
{
  return [[[self alloc] init] autorelease];
}


- (id) initWithGLData:(ShardGLData *)GLData
{
  glData = GLData;
  if ((self = [super initWithX:0 y:0 width:0 height:0])) {
    int shardWidth = 0;
    int shardHeight = 0;

    self.enableBlend = NO;
    
    CGFloat rnd = FlxU.random;
    t = 1 + rnd*6;
    switch (t) {
    case 1:
      //smallest little spec
      shardWidth = 1;
      shardHeight = 1;
      if(!FlxG.iPad)
        solid = false;
      break;
    case 2:
      if (FlxU.random > 0.5) {
	//smallest square
	shardWidth = 2;
	shardHeight = 2;
      } else {
	//smallest sliver
	shardWidth = 1;
	shardHeight = 2;
      }
      if(!FlxG.iPad)
        solid = false;
      break;
    case 3:
      if (FlxU.random > 0.5) {
        //smaller square
        shardWidth = 3;
        shardHeight = 4;
      } else {
        //smaller sliver
        shardWidth = 1;
        shardHeight = 3;
      }
      if(!FlxG.iPad)
        solid = false;
      break;
    case 4:
      if (FlxU.random > 0.5) {
	//small square
	shardWidth = 4;
	shardHeight = 5;
      } else {
	//small sliver
	shardWidth = 2;
	shardHeight = 5;
      }
      break;
    case 5:
      if (FlxU.random > 0.5) {
	//medium square
	shardWidth = 5;
	shardHeight = 6;
      } else {
	//medium sliver
	shardWidth = 2;
	shardHeight = 6;
      }
      break;
    case 6:
    default:
      if (FlxU.random > 0.5) {
	//big square
	shardWidth = 6;
	shardHeight = 8;
      } else {
	//big sliver
	shardWidth = 2;
	shardHeight = 8;
      }
      break;
    }

    for (int i=0; i<4; i++) {
      glData->c0[i] = 0xff;
      glData->c1[i] = 0xff;
      glData->c2[i] = 0xff;
      glData->c3[i] = 0xff;
      glData->c4[i] = 0xff;
    }

    width = frameWidth = shardWidth;
    height = frameHeight = shardHeight;
    origin.x = frameWidth/2;
    origin.y = frameHeight/2;
    [self refreshHulls];
    width = 2;
    height = 2;
    self.x = -100;
    self.y = -100;

    [self setupVertices];
    
  }
  return self;
}
  
- (void) update
{
  if ((self.x < -FlxG.scroll.x) || (self.y > 480))
    self.exists = NO;
  [super updateMotion];
  [self setupVertices];
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

- (void) hitBottomWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
  if (t > 5 && velocity.y > 120)
    [FlxG play:[shardSounds objectAtIndex:t%2]];
  velocity.x *= 0.5+[FlxU random]*0.6;
  velocity.y *= -0.2-[FlxU random]*0.3;
  int vy = velocity.y*3;
  angularVelocity = ([FlxU random]*vy-vy*2)/16.0;
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

- (void) setupVertices
{
  if (visible && exists && active) {
    CGPoint p = [self getScreenXY];
    //looks better without this?
    // p.x = p.x + frameWidth/2.0;
    // p.y = p.y + frameHeight/2.0;

    CGPoint p1 = CGPointMake(-(frameWidth/2.0),
                             -(frameHeight/2.0));
    CGPoint p2 = CGPointMake(frameWidth/2.0,
                             -frameHeight/2.0);
    CGPoint p3 = CGPointMake(frameWidth/4.0,
                             frameHeight/2.0);
    CGAffineTransform t1 = CGAffineTransformMakeRotation(angle);
    p1 = CGPointApplyAffineTransform(p1, t1);
    p2 = CGPointApplyAffineTransform(p2, t1);
    p3 = CGPointApplyAffineTransform(p3, t1);
  
    glData->p1[0] = (GLshort)(p1.x + p.x);
    glData->p1[1] = (GLshort)(p1.y + p.y);
    glData->p2[0] = (GLshort)(p2.x + p.x);
    glData->p2[1] = (GLshort)(p2.y + p.y);
    glData->p3[0] = (GLshort)(p3.x + p.x);
    glData->p3[1] = (GLshort)(p3.y + p.y);

    glData->p0[0] = glData->p1[0];
    glData->p0[1] = glData->p1[1];
    glData->p4[0] = glData->p3[0];
    glData->p4[1] = glData->p3[1];
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
  }
}

- (void) render
{
}


@end
