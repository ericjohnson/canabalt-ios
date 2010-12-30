//
//  FlxEmitter.m
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

@implementation FlxEmitter

@synthesize quantity;
@synthesize on;
@synthesize gravity;
@synthesize minParticleSpeed;
@synthesize minRotation;
@synthesize maxParticleSpeed;
@synthesize delay;
@synthesize maxRotation;
@synthesize particleDrag;

- (id) init;
{
  return [self initWithX:0];
}
- (id) initWithX:(float)X;
{
  return [self initWithX:X y:0];
}
- (id) initWithX:(float)X y:(float)Y;
{
  if ((self = [super initWithX:X y:Y width:0 height:0])) {
      x = X;
      y = Y;
      width = 0;
      height = 0;
      minParticleSpeed = CGPointMake(-100,-100);
      maxParticleSpeed = CGPointMake(100,100);
      minRotation = -360;
      maxRotation = 360;
      gravity = 400;
      particleDrag = CGPointZero;
      delay = 0.1;
      quantity = 0;
      _counter = 0;
      _explode = YES;
      exists = NO;
      on = NO;
  }
  return self;
}
- (void) dealloc
{
   [super dealloc];
}
- (FlxEmitter *) createSprites:(NSString *)Graphics;
{
  return [self createSprites:Graphics quantity:50];
}
- (FlxEmitter *) createSprites:(NSString *)Graphics quantity:(unsigned int)Quantity;
{
  return [self createSprites:Graphics quantity:Quantity bakedRotations:16];
}
- (FlxEmitter *) createSprites:(NSString *)Graphics quantity:(unsigned int)Quantity bakedRotations:(unsigned int)BakedRotations;
{
  return [self createSprites:Graphics quantity:Quantity bakedRotations:BakedRotations multiple:YES];
}
- (FlxEmitter *) createSprites:(NSString *)Graphics quantity:(unsigned int)Quantity bakedRotations:(unsigned int)BakedRotations multiple:(BOOL)Multiple;
{
  return [self createSprites:Graphics quantity:Quantity bakedRotations:BakedRotations multiple:Multiple collide:0];
}
- (FlxEmitter *) createSprites:(NSString *)Graphics quantity:(unsigned int)Quantity bakedRotations:(unsigned int)BakedRotations multiple:(BOOL)Multiple collide:(float)Collide;
{
  return [self createSprites:Graphics quantity:Quantity bakedRotations:BakedRotations multiple:Multiple collide:Collide modelScale:1.0];
}
- (FlxEmitter *) createSprites:(NSString *)Graphics quantity:(unsigned int)Quantity bakedRotations:(unsigned int)BakedRotations modelScale:(float)ModelScale;
{
  return [self createSprites:Graphics quantity:Quantity bakedRotations:BakedRotations multiple:YES modelScale:ModelScale];
}
- (FlxEmitter *) createSprites:(NSString *)Graphics quantity:(unsigned int)Quantity bakedRotations:(unsigned int)BakedRotations multiple:(BOOL)Multiple modelScale:(float)ModelScale;
{
  return [self createSprites:Graphics quantity:Quantity bakedRotations:BakedRotations multiple:Multiple collide:0 modelScale:ModelScale];
}
- (FlxEmitter *) createSprites:(NSString *)Graphics
		      quantity:(unsigned int)Quantity
		bakedRotations:(unsigned int)BakedRotations
		      multiple:(BOOL)Multiple
		       collide:(float)Collide
		    modelScale:(float)ModelScale;
{
  [members removeAllObjects];
  unsigned int r;
  FlxSprite * s;
  unsigned int tf = 1;
  float sw;
  float sh;
  if (Multiple)
    {
      s = [[[FlxManagedSprite alloc] initWithX:0 y:0 graphic:Graphics modelScale:ModelScale] autorelease];
      tf = s.width / s.height;
    }
  for ( unsigned int i = 0; i < Quantity; i++ )
    {
      s = [[[FlxSprite alloc] init] autorelease];
      //s = [[[FlxManagedSprite alloc] init] autorelease];
      if (Multiple)
	{
	  r = [FlxU random] * tf;
	  if (BakedRotations > 0)
	    [s loadRotatedGraphic:Graphics rotations:BakedRotations frame:r modelScale:ModelScale];
	  else
	    {
	      [s loadGraphic:Graphics animated:YES modelScale:ModelScale];
	      s.frame = r;
	    }
	}
      else
	{
 	  if (BakedRotations > 0)
 	    [s loadRotatedGraphic:Graphics rotations:BakedRotations modelScale:ModelScale];
 	  else
	    [s loadGraphic:Graphics modelScale:ModelScale];
	}
      if (Collide > 0)
	{
	  sw = s.width;
	  sh = s.height;
	  s.width *= Collide;
	  s.height *= Collide;
	  s.offset = CGPointMake((sw - s.width) / 2,
                                 (sh - s.height) / 2);
	  s.solid = YES;
	}
      else {
	s.solid = NO;
      }
      s.exists = NO;
      s.scrollFactor = scrollFactor;
      [self add:s];
    }
  return self;
}
- (void) setSizeWithParam1:(unsigned int)Width param2:(unsigned int)Height;
{
   width = Width;
   height = Height;
}
- (void) setXSpeed;
{
   return [self setXSpeed:0];
}
- (void) setXSpeed:(float)Min;
{
   return [self setXSpeedWithParam1:Min param2:0];
}
- (void) setXSpeedWithParam1:(float)Min param2:(float)Max;
{
   minParticleSpeed.x = Min;
   maxParticleSpeed.x = Max;
}
- (void) setYSpeed;
{
   return [self setYSpeed:0];
}
- (void) setYSpeed:(float)Min;
{
   return [self setYSpeedWithParam1:Min param2:0];
}
- (void) setYSpeedWithParam1:(float)Min param2:(float)Max;
{
   minParticleSpeed.y = Min;
   maxParticleSpeed.y = Max;
}
- (void) setRotation;
{
   return [self setRotation:0];
}
- (void) setRotation:(float)Min;
{
   return [self setRotationWithParam1:Min param2:0];
}
- (void) setRotationWithParam1:(float)Min param2:(float)Max;
{
   minRotation = Min;
   maxRotation = Max;
}
- (void) updateEmitter;
{
   if (_explode)
      {
         unsigned int i;
         unsigned int l;
         _timer += FlxG.elapsed;
         if ((delay > 0) && (_timer > delay))
            {
               [self kill];
               return;
            }
         if (on)
            {
               on = NO;
               l = members.length;
               if (quantity > 0)
                  l = quantity;
               l += _particle;
               for ( i = _particle; i < l; i++ )
                  [self emitParticle];
            }
         return;
      }
   if (!on)
      return;
   _timer += FlxG.elapsed;
   while ((_timer > delay) && ((quantity <= 0) || (_counter < quantity)))
      {
         _timer -= delay;
         [self emitParticle];
      }
}
- (void) updateMembers;
{
   FlxObject * o;
   unsigned int l = members.length;
   for ( unsigned int i = 0; i < l; i++ )
      {
         o = ((FlxObject *)([members objectAtIndex:i]));
         if ((o != nil) && o.exists && o.active) {
            [o update];
	 }
      }
}
- (void) update;
{
   [super update];
   [self updateEmitter];
}

- (void) start;
{
   return [self start:YES];
}
- (void) start:(BOOL)Explode;
{
   return [self startWithParam1:Explode param2:0];
}
- (void) startWithParam1:(BOOL)Explode param2:(float)Delay;
{
   return [self startWithParam1:Explode param2:Delay param3:0];
}
- (void) startWithParam1:(BOOL)Explode param2:(float)Delay param3:(unsigned int)Quantity;
{
   if (members.length <= 0)
      {
         [FlxG log:@"WARNING: there are no sprites loaded in your emitter.\nAdd some to FlxEmitter.members or use FlxEmitter.createSprites()."];
         return;
      }
   _explode = Explode;
   if (!_explode)
      _counter = 0;
   if (!exists)
      _particle = 0;
   exists = YES;
   visible = YES;
   active = YES;
   dead = NO;
   on = YES;
   _timer = 0;
   if (quantity == 0)
      quantity = Quantity;
   if (Delay != 0)
      delay = Delay;
   if (delay < 0)
      delay = -delay;
   for (FlxSprite * s in members)
     s.visible = NO;
}
- (void) emitParticle;
{
   _counter++;
   //FlxSprite * s = ((FlxSprite *)([members objectAtIndex:_particle]));
   FlxObject * s = ((FlxObject *)([members objectAtIndex:_particle]));
   s.exists = YES;
   s.active = YES;
   s.dead = NO;
   s.x = x - ((int)(s.width) >> 1) + [FlxU random] * width;
   s.y = y - ((int)(s.height) >> 1) + [FlxU random] * height;
   s.visible = YES;
   CGPoint s_velocity;
   s_velocity.x = minParticleSpeed.x;
   if (minParticleSpeed.x != maxParticleSpeed.x)
     s_velocity.x += [FlxU random] * (maxParticleSpeed.x - minParticleSpeed.x);
   s_velocity.y = minParticleSpeed.y;
   if (minParticleSpeed.y != maxParticleSpeed.y)
     s_velocity.y += [FlxU random] * (maxParticleSpeed.y - minParticleSpeed.y);
   s.velocity = s_velocity;
   s.acceleration = CGPointMake(s.acceleration.x,
                                gravity);
   s.angularVelocity = minRotation;
   if (minRotation != maxRotation)
      s.angularVelocity += [FlxU random] * (maxRotation - minRotation);
   if (s.angularVelocity != 0)
      s.angle = [FlxU random] * 360 - 180;
   s.drag = particleDrag;
   _particle++;
   if (_particle >= members.length)
      _particle = 0;
   [s onEmit];
}
- (void) stop;
{
   return [self stop:3];
}
- (void) stop:(float)Delay;
{
   _explode = YES;
   delay = Delay;
   if (delay < 0)
      delay = -Delay;
   on = NO;
}
- (void) at:(FlxObject *)Object;
{
   x = Object.x + Object.origin.x;
   y = Object.y + Object.origin.y;
}
- (void) kill;
{
   [super kill];
   on = NO;
}

@end
