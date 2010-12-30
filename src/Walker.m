//
//  Walker.m
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

#import "Walker.h"

static NSString * ImgWalker = @"walker2.png";

static NSUInteger s;

@implementation Walker


+ (Walker *) walkerWithSmoke:(NSArray *)smokeArray
{
  return [[[Walker alloc] initWithSmoke:smokeArray] autorelease];
}

- (id) initWithSmoke:(NSArray *)smokeArray
{
  if ((self = [super initWithX:0 y:0 graphic:nil])) {

    [self loadGraphicWithParam1:ImgWalker param2:YES param3:NO param4:120 param5:80];
    
    firing = NO;
    walkTimer = 0.0;
    idleTimer = 0.0;
    
    self.x = -500;
    self.y = 40+FlxU.random*10;
    
    self.width = 120;
    self.height = 80;
    
    smoke = [smokeArray retain];
    
    scrollFactor.x = 0.1;
    scrollFactor.y = 0.15;
    
    [self addAnimationWithParam1:@"idle" param2:[NSMutableArray intArrayWithSize:1 ints:0]];
    [self addAnimationWithParam1:@"walk" param2:[NSMutableArray intArrayWithSize:6 ints:0,1,2,3,4,5] param3:8];
    [self addAnimationWithParam1:@"fire" param2:[NSMutableArray intArrayWithSize:6 ints:6,7,8,9,10,11] param3:8 param4:NO];
    
    [self play:@"idle"];
    
  }
  return self;
}

- (void) dealloc
{
  [smoke release];
  [super dealloc];
}

- (void) update
{
  if (walkTimer > 0) {
    walkTimer -= FlxG.elapsed;
    if (walkTimer <= 0) {
      [self play:@"fire"];
      firing = YES;
      velocity.x = 0;
      if (++s >= [smoke count])
	s = 0;
      FlxEmitter * se = [smoke objectAtIndex:s];
      se.x = self.x + ((self.facing == 0) ? (self.width-22) : 10);
      se.y = self.y + self.height;
      //[se resetWithParam1:0 param2:0];
      [se start:NO];
    }
  } else if (firing) {
    if (finished) {
      firing = NO;
      idleTimer = 1 + FlxU.random*2;
      [self play:@"idle"];
    }
  } else if (idleTimer > 0) {
    idleTimer -= FlxG.elapsed;
    if (idleTimer <= 0) {
      if (FlxU.random < 0.5) {
	walkTimer = 2 + FlxU.random*4;
	[self play:@"walk"];
	velocity.x = (self.facing == 0 ? 40 : -40);
      } else {
	[self play:@"fire"];
	firing = YES;
	if (++s >= [smoke count])
	  s = 0;
	FlxEmitter * se = [smoke objectAtIndex:s];
	se.x = self.x + ((self.facing == 0) ? (self.width-22) : 10);
	se.y = self.y + self.height;
	//[se resetWithParam1:0 param2:0];
	[se start:NO];
      }
    }
  }
  
  CGPoint p = [self getScreenXY];
  if (p.x + self.width*2 < 0) { //added *2 factor
    walkTimer = [FlxU random]*2;
    self.facing = [FlxU random] > 0.5 ? 0 : 1;
    self.x = self.x + [FlxG width]+self.width*2 + [FlxU random]*[FlxG width]; //added *2 factor
  }
  [super update];
}

@end
