//
//  Obstacle.m
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

#import "Obstacle.h"
#import "Player.h"

static NSString * ImgObstacles1 = @"obstacles.png";
static NSString * ImgObstacles2 = @"obstacles2.png";
static NSString * SndOb1 = @"obstacle1.caf";
static NSString * SndOb2 = @"obstacle2.caf";
static NSString * SndOb3 = @"obstacle3.caf";

@implementation Obstacle

+ (id) obstacleWithOrigin:(CGPoint)Origin player:(Player *)player
{
  return [[[self alloc] initWithOrigin:Origin player:player] autorelease];
}
+ (id) obstacleWithOrigin:(CGPoint)Origin player:(Player *)player alt:(BOOL)alt
{
  return [[[self alloc] initWithOrigin:Origin player:player alt:alt] autorelease];
}
- (id) initWithOrigin:(CGPoint)Origin player:(Player *)player
{
  return [self initWithOrigin:Origin player:player alt:NO];
}
- (id) initWithOrigin:(CGPoint)Origin player:(Player *)player alt:(BOOL)alt
{
  if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {

    [self loadGraphicWithParam1: alt ? ImgObstacles2 : ImgObstacles1
	  param2:YES];
    
    [self randomFrame];
    self.height = 2;
    self.offset = CGPointMake(self.offset.x, 16);
    self.y -= self.height;
    p = [player retain];
  }
  return self;
}

- (void) dealloc
{
  [p release];
  p = nil;
  [super dealloc];
}

- (void) update
{
  if (!dead && [self overlaps:p]) {
    p.stumble = YES;
    p.velocity = CGPointMake(p.velocity.x*0.7,
                             p.velocity.y);
    int rs = FlxU.random * 3;
    switch (rs) {
    case 0: [FlxG play:SndOb1]; break;
    case 1: [FlxG play:SndOb2]; break;
    case 2: [FlxG play:SndOb3]; break;
    default: break;
    }
    velocity.x = p.velocity.x + FlxU.random * 100 - 50;
    velocity.y = -120;
    acceleration.y = 320;
    [self kill];
  }
  [super update];
}

- (void) hitBottomWithParam1:(FlxObject *)Collide param2:(float)Velocity
{
  velocity.y = -velocity.y/4;
}

- (void) kill
{
  dead = YES;
  [self flicker:0];
  angularVelocity = FlxU.random * 720 - 360;
}

@end
