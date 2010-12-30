//
//  Bomb.m
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

#import "Bomb.h"
#import "Player.h"
#import "Sequence.h"

static NSString * ImgBomb = @"bomb.png";
static NSString * SndBombLaunch = @"bomb_launch.caf";
static NSString * SndBombPre = @"bomb_pre.caf";
static NSString * SndBombHit = @"bomb_hit.caf";
static NSString * SndBombExplode = @"bomb_explode.caf";

@implementation Bomb

+ (id) bombWithOrigin:(CGPoint)origin player:(Player *)player gibs:(NSArray *)entry sequence:(Sequence *)sequence
{
  return [[[self alloc] initWithOrigin:origin player:player gibs:entry sequence:sequence] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin player:(Player *)player gibs:(NSArray *)entry sequence:(Sequence *)sequence
{
  if ((self = [super initWithX:0 y:0 graphic:ImgBomb])) {

    self.x = Origin.x;
    self.y = -80;
    myY = Origin.y-30;
    p = [player retain];
    en = [entry retain];
    s = [sequence retain];

    self.x -= self.width/2;
    self.height = 60;
    //offset = CGPointMake(0, 20);
    offset.x = 0;
    offset.y = 20;

    velocity.y = 1200;

    [FlxG play:SndBombLaunch];

  }
  return self;
}

- (void) dealloc
{
  [en release];
  [p release];
  [e release];
  [s release];
  [super dealloc];
}

- (void) add:(FlxEmitter *)gibs
{
  [e release];
  e = [gibs retain];
}

- (void) update
{
  if (self.y <= -64)
    if (p.x > self.x-480)
      [FlxG play:SndBombPre];
  if (p.x > self.x-480)
    [super update];
  if (velocity.y > 0) {
    if (self.y > myY) {
      velocity.y = 0;
      self.y = myY;
      angularVelocity = FlxU.random*120-60;
      angularDrag = abs(angularVelocity);
      //[e resetWithParam1:0 param2:0];
      [e start];
      if (FlxG.iPad)
        [[FlxG quake] startWithIntensity:0.1 duration:0.15];
      else
        [[FlxG quake] startWithIntensity:0.05 duration:0.15];
      int i = 0;
      for (FlxSprite * sprite in en) {
	sprite.x = self.x-16 + i*8;
	sprite.y = myY + 16 + FlxU.random*8;
	[sprite randomFrame];
	++i;
      }
      [FlxG play:SndBombHit];
      [FlxG vibrate];
    }
  } else if ([self overlaps:p]) { //player death
    [FlxG play:SndBombExplode];
    [FlxG vibrate];
    p.y = 600;
    p.epitaph = @"bomb";
    [s performSelector:@selector(aftermath)
       withObject:nil
       afterDelay:0.0];
  }
  
}

@end
