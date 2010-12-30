//
//  Player.m
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

#import "Player.h"

@interface NSArray (GetRandom)
- (id) getRandom;
@end
@implementation NSArray (GetRandom)
- (id) getRandom
{
  return [self objectAtIndex:(unsigned)([FlxU random]*self.length)];
}
@end


@interface FlxSprite ()
- (void) resetHelpers;
@end

static NSString * ImgPlayer = @"player2.png";

@implementation Player

@synthesize jumpLimit;
@synthesize stumble;
@synthesize craneFeet;
@synthesize epitaph;
@synthesize pause;

+ (id) player
{
  return [[[self alloc] init] autorelease];
}

- (id) init
{
  if ((self = [super initWithX:0 y:0 graphic:nil])) {

    [self loadGraphicWithParam1:ImgPlayer param2:YES param3:NO param4:30 param5:30];
    
    offset.x = 6;
    offset.y = 12;
    self.x = 0;
    self.y = 80-14;

    self.width = 16;
    self.height = 18;
    
    [self addAnimationWithParam1:@"run1" param2:[NSMutableArray intArrayWithSize:16 ints:0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15] param3:15];
    [self addAnimationWithParam1:@"run2" param2:[NSMutableArray intArrayWithSize:16 ints:0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15] param3:28];
    [self addAnimationWithParam1:@"run3" param2:[NSMutableArray intArrayWithSize:16 ints:0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15] param3:40];
    [self addAnimationWithParam1:@"run4" param2:[NSMutableArray intArrayWithSize:16 ints:0,2,4,6,8,10,12,14] param3:30];
    [self addAnimationWithParam1:@"jump" param2:[NSMutableArray intArrayWithSize:4 ints:16,17,18,19] param3:12 param4:NO];
    [self addAnimationWithParam1:@"fall" param2:[NSMutableArray intArrayWithSize:7 ints:20,21,22,23,24,25,26] param3:14];
    [self addAnimationWithParam1:@"stumble1" param2:[NSMutableArray intArrayWithSize:11 ints:27,28,29,30,31,32,33,34,35,36,37] param3:14];
    [self addAnimationWithParam1:@"stumble2" param2:[NSMutableArray intArrayWithSize:11 ints:27,28,29,30,31,32,33,34,35,36,37] param3:21];
    [self addAnimationWithParam1:@"stumble3" param2:[NSMutableArray intArrayWithSize:11 ints:27,28,29,30,31,32,33,34,35,36,37] param3:28];
    [self addAnimationWithParam1:@"stumble4" param2:[NSMutableArray intArrayWithSize:11 ints:27,28,29,30,31,32,33,34,35,36,37] param3:35];

    drag.x = 640;
    //self.drag = CGPointMake(640, self.drag.y);

    acceleration.x = 1;
    acceleration.y = 1200;
    //self.acceleration = CGPointMake(1,1200);
    maxVelocity.x = 1000;
    maxVelocity.y = 360;
    //self.maxVelocity = CGPointMake(1000, 360);
    velocity.x = 125;
    //self.velocity = CGPointMake(125, self.velocity.y);
    my = 0;

    fc = 0;
    feet = [[NSArray alloc] initWithObjects:@"foot1.caf", @"foot2.caf", @"foot3.caf", @"foot4.caf", nil];
    feetC = [[NSArray alloc] initWithObjects:@"footc1.caf", @"footc2.caf", @"footc3.caf", @"footc4.caf", nil];

    self.craneFeet = NO;

    self.epitaph = @"fall";
  
  }
  
  return self;
}

- (void) dealloc
{
  [feet release];
  [feetC release];
  [super dealloc];
}

// - (void) play:(NSString *)string
// {
//   NSLog(@"Player play:%@", string);
//   [super play:string];
// }

- (void) update
{

//   CGPoint screen = self.screenPosition;
//   NSLog(@"player.x:%f, player.y:%f, screen.x:%f, screen.y:%f", self.x, self.y, screen.x, screen.y);
  if (self.y > 484) {
    self.dead = YES;
    return;
  }


//   if (self.x >= 1000) {
//     NSLog(@"turning debug on");
//     self.debug = YES;
//   }
  
//   if (acceleration.x <= 0 && self.debug == NO) {
//     NSLog(@"x position: %f", self.x);
//     self.debug = YES;
//   }
  
  //  NSLog(@"jump:%f, onFloor:%d", jump, onFloor);

//   NSLog(@"update -> jump:%f, onFloor:%d, v:(%f,%f), position:(%f,%f)", jump, onFloor, velocity.x, velocity.y, self.x, self.y);

  //walldeath
  if (acceleration.x <= 0)
    return [super update];

  //speed & acceleration
  if (velocity.x < 0) velocity.x = 0;
  else if (velocity.x < 100) acceleration.x = 60;
  else if (velocity.x < 250) acceleration.x = 36;
  else if (velocity.x < 400) acceleration.x = 24;
  else if (velocity.x < 600) acceleration.x = 12;
  else acceleration.x = 4;

  //jumping
  jumpLimit = velocity.x / (maxVelocity.x * 2.5);
  if (jumpLimit > 0.35) jumpLimit = 0.35;

  if (jump >= 0 && FlxG.touches.touching && !pause) {
    if (jump == 0) {
      //NSLog(@"starting a jump");
      int rs = FlxU.random * 4;
      switch (rs) {
      case 0: [FlxG play:@"jump1.caf"]; break;
      case 1: [FlxG play:@"jump2.caf"]; break;
      case 2: [FlxG play:@"jump3.caf"]; break;
      default: break;
      }
    }
    jump += FlxG.elapsed;
    if (jump > jumpLimit) {
      //NSLog(@"force ending a jump");
      jump = -1;
    }
  } else
    jump = -1;

  if (jump > 0) {
    //onFloor = NO;
    craneFeet = NO;
    if (jump < 0.08)
      velocity.y = -maxVelocity.y*0.65;
    else
      velocity.y = -maxVelocity.y;
  }

  if (onFloor) {
    ft = (1-velocity.x/maxVelocity.x)*0.35;
    if (ft < 0.15) ft = 0.15;
    fc += FlxG.elapsed;
    if (fc > ft) {
      fc = 0;
      if (craneFeet) {
 	[FlxG play:[feetC getRandom]];
 	craneFeet = NO;
      } else
 	[FlxG play:[feet getRandom]];
    }
    if (stumble && finished) stumble = NO;
    if (!stumble) {
      if (velocity.x < 150) [self play:@"run1"];
      else if (velocity.x < 300) [self play:@"run2"];
      else if (velocity.x < 550) [self play:@"run3"];
      else [self play:@"run4"];
    }
  }
  else if (velocity.y < -140)
    [self play:@"jump"];
  else if (velocity.y > -140) {
    [self play:@"fall"];
    stumble = NO;
  }

  
  //update
//   if (onFloor) velocity.y = 160;
  [super update];
//   if (onFloor) velocity.y = 0;
  //onFloor = NO;

  if (velocity.y == maxVelocity.y)
    my += FlxG.elapsed;
}

- (void) hitBottomWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
//   NSLog(@"hitBottom self:(%f,%f,%f,%f), contact:(%f,%f,%f,%f)", self.x, self.y, self.width, self.height,
// 	Contact.x, Contact.y, Contact.width, Contact.height);
  //onFloor = YES;
  if (my > 0.16)
    self.stumble = YES;
  if (!FlxG.touches.touching) jump = 0;
  my = 0;
  [super hitBottomWithParam1:Contact param2:Velocity];
}

// - (void) hitRightWithParam1:(FlxObject *)Contact param2:(float)Velocity
// {
//   [FlxG play:@"wall.caf"];
//   acceleration.x = 0;
//   velocity.x = 0;
//   maxVelocity.y = 1000;
//   self.epitaph = @"hit";
//   [super hitRightWithParam1:Contact param2:Velocity];
// }

- (void) hitLeftWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
//   NSLog(@"hitLeft self:(%f,%f,%f,%f), contact:(%f,%f,%f,%f)", self.x, self.y, self.width, self.height,
// 	Contact.x, Contact.y, Contact.width, Contact.height);
  [FlxG play:@"wall.caf"];
  acceleration.x = 0;
  velocity.x = 0;
  maxVelocity.y = 1000;
  self.epitaph = @"hit";
  [super hitLeftWithParam1:Contact param2:Velocity];
}

- (void) setStumble:(BOOL)stumbleValue
{
  [FlxG play:@"tumble.caf"];
  stumble = stumbleValue;
  if (stumble) {
    if (velocity.x > 500) [self playWithParam1:@"stumble4" param2:YES];
    else if (velocity.x > 300) [self playWithParam1:@"stumble3" param2:YES];
    else if (velocity.x > 150) [self playWithParam1:@"stumble2" param2:YES];
    else [self playWithParam1:@"stumble1" param2:YES];
  }

}

@end
