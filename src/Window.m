//
//  Window.m
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

#import "Window.h"
#import "Player.h"

const CGFloat WindowW = 3.0;
//static const CGFloat w = 3.0;

static NSString * SndWindow1 = @"window1.caf";
static NSString * SndWindow2 = @"window2.caf";

@implementation Window


+ (id) windowAtPoint:(CGPoint)point
	      height:(CGFloat)height
	       group:(FlxGroup *)group
	      player:(Player *)plr
	      shards:(FlxEmitter *)glassShards;
{
  return [[[self alloc] initAtPoint:point height:height group:group player:plr shards:glassShards] autorelease];
}

- (id) initAtPoint:(CGPoint)point
	    height:(CGFloat)Height
	     group:(FlxGroup *)group
	    player:(Player *)plr
	    shards:(FlxEmitter *)glassShards;
{
  if ((self = [super initWithX:point.x y:point.y-Height graphic:nil])) {

    [self createGraphicWithParam1:WindowW param2:Height param3:0xffffffff];

    self.enableBlend = NO;
    
    self.x = point.x;
    self.y = point.y-Height;
    self.width = 40;
    
    player = [plr retain];

    shards = [glassShards retain];
    shards.x = self.x;
    shards.y = self.y;
    [shards setSizeWithParam1:WindowW param2:self.height];
    shards.delay = -3;
    shards.minRotation = -720/16.0;
    shards.maxRotation = 720/16.0;
    shards.gravity = 500;
  }
  return self;
}

- (void) dealloc
{
  [shards release];
  [player release];
  [super dealloc];
}

- (void) update
{
  if ([self overlaps:player]) {
    if (FlxU.random < 0.5)
      [FlxG play:SndWindow1];//TODO - set volume for sound effect to 0.35 // i think this has already been premixed?
    else
      [FlxG play:SndWindow2];
    exists = NO;
    shards.minParticleSpeed = CGPointMake(player.velocity.x/2,
                                          player.velocity.y/2 - FlxU.random*40);
    shards.maxParticleSpeed = CGPointMake(shards.minParticleSpeed.x*3,
                                          shards.minParticleSpeed.y*3);
    [shards start];
  }
}

@end
