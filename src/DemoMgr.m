//
//  DemoMgr.m
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

#import "DemoMgr.h"
#import "Player.h"

static NSString * SndCrumble = @"crumble.caf";

@implementation DemoMgr

+ (id) demoMgrWithX:(CGFloat)X player:(Player *)player children:(NSArray *)children
{
  return [[[self alloc] initWithX:X player:player children:children] autorelease];
}

- (id) initWithX:(CGFloat)X player:(Player *)player children:(NSArray *)children
{
  if ((self = [super initWithX:X y:0 width:0 height:0])) {
    p = [player retain];
    c = [[NSMutableArray alloc] init];
    [c addObjectsFromArray:children];
    maxVelocity.y = 300;
    velocity.y = 60;
    acceleration.y = 40;
    go = NO;
  }
  return self;
}

- (void) dealloc
{
  [p release];
  [c release];
  [super dealloc];
}

- (void) add:(FlxObject *)o
{
  [c addObject:o];
}

- (void) update
{
  if (!go) {
    if (p.x + p.width >= self.x && self.y < 480) {
      go = YES;
      [FlxG play:SndCrumble];
      if (FlxG.iPad)
        [[FlxG quake] startWithParam1:0.01 param2:3.0];
      else
        [[FlxG quake] startWithParam1:0.005 param2:3.0];
      
      //assume the last object is an emitter
      FlxEmitter * e = [c lastObject];
      if ([e isKindOfClass:[FlxEmitter class]])
	[e start:NO];

      for (FlxObject * object in c) {
	object.maxVelocity = CGPointMake(object.maxVelocity.x,
                                         self.maxVelocity.y);
	object.velocity = CGPointMake(object.velocity.x,
                                      60);
	object.acceleration = CGPointMake(object.acceleration.x,
                                          40);
      }
    }
  }
  if (go) {

//     CGFloat oy = self.y;
//     [super update];
//     CGFloat ny = self.y;
//     for (FlxObject * object in c) {
//       object.y += ny - oy;
//     }

//     for (FlxObject * object in c)
//       [object update];
    [FlxG vibrate];
    
    if(self.y > 480)
      go = NO;
  }
}

- (void) render {}

@end
