//
//  Leg.m
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

#import "Leg.h"
#import "Player.h"
#import "Sequence.h"

static NSString * ImgLeg = @"giant_leg_bottom.png";
static NSString * ImgLegTop = @"giant_leg_top.png";

static NSString * SndLegLaunch = @"giant_leg.caf";
static NSString * SndLegRelease = @"giant_leg_release.caf";
static NSString * SndBombPre = @"bomb_pre.caf";
static NSString * SndBombHit = @"bomb_hit.caf";
static NSString * SndBombExplode = @"bomb_explode.caf";

@implementation Leg

+ (id) legWithOrigin:(CGPoint)origin player:(Player *)player sequence:(Sequence *)sequence
{
  return [[[self alloc] initWithOrigin:origin player:player sequence:sequence] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin player:(Player *)player sequence:(Sequence *)sequence
{
  if ([super initWithX:0 y:0 graphic:ImgLeg] == nil)
    return nil;
  
  //self.origin = CGPointMake(Origin.x - 64, -480);
  origin.x = Origin.x-64;
  origin.y = -480;
  
  self.x = self.origin.x;
  self.y = self.origin.y;
  myY = Origin.y+2;
  p = [player retain];
  s = [sequence retain];

  //top = [FlxSprite spriteWithImage:ImgLegTop origin:CGPointMake(self.x,-480)];
  //  [top retain];
  top = [[FlxSprite spriteWithX:self.x y:-480 graphic:ImgLegTop] retain];
  
  velocity.y = 1600;
  
  [FlxG play:SndLegLaunch];
  
  return self;
}

- (void) dealloc
{
  [p release];
  [e release];
  [s release];
  [top release];
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
  if (velocity.y > 0)
  {
    if (self.y > myY)
    {
      velocity.y = 0;
      self.y = myY;
      //[e resetWithParam1:0 param2:0];
      [e start];
      if (FlxG.iPad)
        [[FlxG quake] startWithIntensity:0.35 duration:0.2];
      else
        [[FlxG quake] startWithIntensity:0.25 duration:0.2];
      [FlxG play:SndBombHit];
      [FlxG play:SndBombExplode];
      [FlxG play:SndLegRelease];
      [FlxG vibrate];
      [s stomp];
    }
  }
  top.x = self.x - (self.x - p.x)/16;
  top.y = self.y - 400 - (480-(self.x - p.x))/8;
}

- (void) render
{
  glPushMatrix();
  [top render];
  [super render];
  glPopMatrix();
}

@end
