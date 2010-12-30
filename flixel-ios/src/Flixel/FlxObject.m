//
//  FlxObject.m
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

@interface FlxObject ()
@property (assign) float _flickerTimer;
@property (assign) BOOL _flicker;
@end

@implementation FlxObject

@synthesize debug;

@synthesize _flickerTimer, _flicker;

static GLuint lastBound = 0;

+ (void) unbind
{
  if (lastBound != 0) {
    glBindTexture(GL_TEXTURE_2D, 0);
    lastBound = 0;
  }
}

+ (void) bind:(GLuint)texture
{
  if (texture == 0)
    [self unbind];
  if (lastBound == 0 || lastBound != texture) {
    glBindTexture(GL_TEXTURE_2D, texture);
    lastBound = texture;
  }
}

- (id) copyWithZone:(NSZone *)zone
{
  return [self retain];
}

@synthesize enableBlend;

@synthesize collideTop;
@synthesize maxAngular;
@synthesize angularDrag;
@synthesize collideLeft;
@synthesize active;
@synthesize health;
@synthesize solid;
@synthesize collideRight;
@synthesize angularVelocity;
@synthesize dead;
@synthesize colVector;
@synthesize onFloor;
@synthesize collideBottom;
@synthesize angle;
@synthesize velocity;
@synthesize thrust;
@synthesize origin;
@synthesize moves;
@synthesize angularAcceleration;
@synthesize exists;
@synthesize colHullX;
@synthesize acceleration;
@synthesize scrollFactor;
@synthesize drag;
@synthesize maxThrust;
@synthesize fixed;
@synthesize colHullY;
@synthesize maxVelocity;
@synthesize visible;
@synthesize colOffsets;

// - (id) init;
// {
//   return [self initWithX:0];
// }
// - (id) initWithX:(float)X;
// {
//   return [self initWithX:X y:0];
// }
// - (id) initWithX:(float)X y:(float)Y;
// {
//   return [self initWithX:X y:Y width:0];
// }
// - (id) initWithX:(float)X y:(float)Y width:(float)Width;
// {
//   return [self initWithX:X y:Y width:Width height:0];
// }

- (id) initWithX:(float)X y:(float)Y width:(float)Width height:(float)Height;
{
  if ((self = [super initWithX:X y:Y width:Width height:Height])) {
    enableBlend = YES;
    exists = YES;
    active = YES;
    visible = YES;
    solid = YES;
    fixed = NO;
    moves = YES;
    collideLeft = YES;
    collideRight = YES;
    collideTop = YES;
    collideBottom = YES;
    origin = CGPointZero;
    velocity = CGPointZero;
    acceleration = CGPointZero;
    drag = CGPointZero;
    maxVelocity = CGPointMake(10000, 10000);
    angle = 0;
    angularVelocity = 0;
    angularAcceleration = 0;
    angularDrag = 0;
    maxAngular = 10000;
    thrust = 0;
    scrollFactor = CGPointMake(1,1);
    _flicker = NO;
    _flickerTimer = -1;
    health = 1;
    dead = NO;
//     _point = [[FlxPoint alloc] init];
//     _rect = [[FlxRect alloc] init];
//     _flashPoint = [[FlashPoint alloc] init];
    colHullX = CGRectZero;
    colHullY = CGRectZero;
    colVector = CGPointZero;
    colOffsets = [[NSMutableArray arrayWithObject:[NSValue valueWithCGPoint:CGPointZero]] retain];
    _group = NO;
  }
  return self;
}
- (void) dealloc
{
  [colOffsets release];
//   [_flashPoint release];
//   [_rect release];
  [super dealloc];
}
- (void) destroy;
{
}

- (void) refreshHulls;
{
   colHullX.origin.x = x;
   colHullX.origin.y = y;
   colHullX.size.width = width;
   colHullX.size.height = height;
   colHullY.origin.x = x;
   colHullY.origin.y = y;
   colHullY.size.width = width;
   colHullY.size.height = height;
}

- (void) updateMotion;
{
  if (!moves)
    return;
  if (solid)
    [self refreshHulls];
  onFloor = NO;
  float vc = 0;

  vc = ([FlxU computeVelocityWithParam1:angularVelocity param2:angularAcceleration param3:angularDrag param4:maxAngular] - angularVelocity)/2;
  angularVelocity += vc;
  angle = fmod(angle + angularVelocity*FlxG.elapsed, 360);
  angularVelocity += vc;

  CGPoint thrustComponents;
  if (thrust != 0)
    {
      thrustComponents = [FlxU rotatePointWithParam1:-thrust param2:0 param3:0 param4:0 param5:angle];
      CGPoint maxComponents = [FlxU rotatePointWithParam1:-maxThrust param2:0 param3:0 param4:0 param5:angle];
      float max = ((maxComponents.x > 0) ? maxComponents.x : -maxComponents.x);
      if (max > ((maxComponents.y > 0) ? maxComponents.y : -maxComponents.y))
	maxComponents.y = max;
      else
	max = ((maxComponents.y > 0) ? maxComponents.y : -maxComponents.y);
      maxVelocity.x = maxVelocity.y = ((max > 0) ? max : -max);
    }
  else
    thrustComponents = CGPointZero;

  vc = ([FlxU computeVelocityWithParam1:velocity.x param2:acceleration.x + thrustComponents.x param3:drag.x param4:maxVelocity.x] - velocity.x)/2;
  velocity.x += vc;
  float xd = velocity.x * FlxG.elapsed;
  velocity.x += vc;

  vc = ([FlxU computeVelocityWithParam1:velocity.y param2:acceleration.y + thrustComponents.y param3:drag.y param4:maxVelocity.y] - velocity.y)/2;
  velocity.y += vc;
  float yd = velocity.y * FlxG.elapsed;
  velocity.y += vc;

  x += xd;
  y += yd;

  if (!solid)
    return;
  colVector.x = xd;
  colVector.y = yd;
  colHullX.size.width += ((colVector.x > 0) ? colVector.x : -colVector.x);
  if (colVector.x < 0)
    colHullX.origin.x += colVector.x;
  colHullY.origin.x = x;
  colHullY.size.height += ((colVector.y > 0) ? colVector.y : -colVector.y);
  if (colVector.y < 0)
    colHullY.origin.y += colVector.y;
}
- (void) updateFlickering;
{
  if ([self flickering])
    {
      if (_flickerTimer > 0)
	{
	  _flickerTimer -= FlxG.elapsed;
	  if (_flickerTimer == 0)
	    _flickerTimer = -1;
	}
      if (_flickerTimer < 0)
	[self flicker:-1];
      else
	{
	  _flicker = !_flicker;
	  visible = !_flicker;
	}
    }
}
- (void) update;
{
  [self updateMotion];
  [self updateFlickering];
}


- (void) render;
{
}
- (BOOL) overlaps:(FlxObject *)Object;
{
  CGPoint _point = [self getScreenXY];
  float tx = _point.x;
  float ty = _point.y;
  _point = [Object getScreenXY];
  if ((_point.x <= tx - Object.width) || (_point.x >= tx + width) || (_point.y <= ty - Object.height) || (_point.y >= ty + height))
    return NO;
  return YES;
}
- (BOOL) overlapsPointWithParam1:(float)X param2:(float)Y;
{
  return [self overlapsPointWithParam1:X param2:Y param3:NO];
}
- (BOOL) overlapsPointWithParam1:(float)X param2:(float)Y param3:(BOOL)PerPixel;
{
  X = X - [FlxU floor:FlxG.scroll.x];
  Y = Y - [FlxU floor:FlxG.scroll.y];
  CGPoint _point = [self getScreenXY];
  if ((X <= _point.x) || (X >= _point.x + width) || (Y <= _point.y) || (Y >= _point.y + height))
    return NO;
  return YES;
}
- (BOOL) collide;
{
  return [self collide:nil];
}
- (BOOL) collide:(FlxObject *)Object;
{
  return [FlxU collideWithParam1:self param2:((Object == nil) ? self : Object)];
}
- (void) preCollide:(FlxObject *)Object;
{
}
- (void) hitLeftWithParam1:(FlxObject *)Contact param2:(float)Velocity;
{
  if (!fixed)
    velocity.x = Velocity;
}
- (void) hitRightWithParam1:(FlxObject *)Contact param2:(float)Velocity;
{
  [self hitLeftWithParam1:Contact param2:Velocity];
}
- (void) hitTopWithParam1:(FlxObject *)Contact param2:(float)Velocity;
{
  if (!fixed)
    velocity.y = Velocity;
}
- (void) hitBottomWithParam1:(FlxObject *)Contact param2:(float)Velocity;
{
  onFloor = YES;
  if (!fixed)
    velocity.y = Velocity;
}
- (void) hurt:(float)Damage;
{
  if ((health -= Damage) <= 0)
    [self kill];
}
- (void) kill;
{
   exists = NO;
   dead = YES;
}
- (void) flicker;
{
  return [self flicker:1];
}
- (void) flicker:(float)Duration;
{
  _flickerTimer = Duration;
  if (_flickerTimer < 0)
    {
      _flicker = NO;
      visible = YES;
    }
}
- (BOOL) flickering;
{
  return _flickerTimer >= 0;
}
- (CGPoint) getScreenXY
{
  CGPoint Point;
  Point.x = floor(x + FlxU.roundingError) + floor(FlxG.scroll.x * scrollFactor.x);
  Point.y = floor(y + FlxU.roundingError) + floor(FlxG.scroll.y * scrollFactor.y);
  return Point;
}
- (BOOL) onScreen;
{
  CGPoint _point = [self getScreenXY];
  if ((_point.x + width < 0) || (_point.x > FlxG.width) || (_point.y + height < 0) || (_point.y > FlxG.height))
    return NO;
  return YES;
}
- (void) resetWithParam1:(float)X param2:(float)Y;
{
  x = X;
  y = Y;
  exists = YES;
  dead = NO;
}

- (void) onEmit
{
}

@end
