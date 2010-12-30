//
//  FlxU.m
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
#import <UIKit/UIKit.h>

static float _seed;
static float _originalSeed;
static float roundingError = 1e-07;

@implementation NSArray (LengthProperty)
- (NSUInteger) length { return [self count]; }
- (NSUInteger) indexOf:(id)object
{
  return [self indexOfObject:object];
}
- (id) randomObject;
{
  if (self.length == 0)
    return nil;
  return [self objectAtIndex:self.length*FlxU.random];
}
@end


@implementation NSMutableArray (AS3)
- (void) push:(id)obj
{
  if (obj == nil)
    [self addObject:[NSNull null]];
  else
    [self addObject:obj];
}
@end

@implementation FlxU

+ (float) roundingError
{
  return roundingError;
}

+ (void) openURL:(NSString *)URL;
{
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL]];
  //    [self navigateToURLWithParam1:[[[URLRequest alloc] initWithParam1:URL] autorelease] param2:@"_blank"];
}
+ (float) abs:(float)N;
{
  return (N > 0) ? N : -N;
}
+ (float) floor:(float)N;
{
  float n = ((int)( N ));
  return (N > 0) ? (n) : ((n != N) ? (n - 1) : (n));
}
+ (float) ceil:(float)N;
{
  float n = ((int)( N ));
  return (N > 0) ? ((n != N) ? (n + 1) : (n)) : (n);
}
+ (float) random;
{
  return [self random:YES];
}
+ (float) random:(BOOL)UseGlobalSeed;
{
//   if (UseGlobalSeed && !isnan(_seed))
//     {
//       float random = [self randomize:_seed];
//       _seed = [self mutateWithParam1:_seed param2:random];
//       return random;
//     }
//   else
    return (arc4random()%((unsigned)RAND_MAX+1))/((float)(RAND_MAX)+1);
}
+ (float) randomize:(float)Seed;
{
  return ((69621 * ((int)( Seed * 0x7FFFFFFF ))) % 0x7FFFFFFF) / 0x7FFFFFFF;
}
+ (float) mutateWithParam1:(float)Seed param2:(float)Mutator;
{
  Seed += Mutator;
  if (Seed > 1)
    Seed -= ((int)( Seed ));
  return Seed;
}
+ (float) seed;
{
  return _originalSeed;
}
+ (void) setSeed:(float)Seed;
{
  _seed = Seed;
  _originalSeed = _seed;
}
+ (CGPoint) rotatePointWithParam1:(float)X param2:(float)Y param3:(float)PivotX param4:(float)PivotY param5:(float)Angle;
{
  CGPoint P;
  float radians = -Angle / 180 * M_PI;
  float dx = X - PivotX;
  float dy = PivotY - Y;
  P.x = PivotX + cos(radians) * dx - sin(radians) * dy;
  P.y = PivotY - (sin(radians) * dx + cos(radians) * dy);
  return P;
}
+ (float) getAngleWithParam1:(float)X param2:(float)Y;
{
  return atan2(Y,X) * 180 / M_PI;
}
// + (NSString *) getClassName:(FlashObject *)Obj;
// {
//   return [self getClassNameWithParam1:Obj param2:NO];
// }
// + (NSString *) getClassNameWithParam1:(FlashObject *)Obj param2:(BOOL)Simple;
// {
//   return NSStringFromClass([Obj class]);
// }
// + (Class *) getClass:(NSString *)Name;
// {
//    return ((Class *)([self getDefinitionByName:Name]));
// }
+ (Class) getClass:(NSString *)Name;
{
  return NSClassFromString(Name);
}
+ (float) computeVelocity:(float)Velocity;
{
   return [self computeVelocityWithParam1:Velocity param2:0];
}
+ (float) computeVelocityWithParam1:(float)Velocity param2:(float)Acceleration;
{
   return [self computeVelocityWithParam1:Velocity param2:Acceleration param3:0];
}
+ (float) computeVelocityWithParam1:(float)Velocity param2:(float)Acceleration param3:(float)Drag;
{
   return [self computeVelocityWithParam1:Velocity param2:Acceleration param3:Drag param4:10000];
}
+ (float) computeVelocityWithParam1:(float)Velocity param2:(float)Acceleration param3:(float)Drag param4:(float)Max;
{
  if (Acceleration != 0)
    Velocity += Acceleration * FlxG.elapsed;
  else
    if (Drag != 0)
      {
	float d = Drag * FlxG.elapsed;
	if (Velocity - d > 0)
	  Velocity -= d;
	else
	  if (Velocity + d < 0)
	    Velocity += d;
	  else
	    Velocity = 0;
      }
  if ((Velocity != 0) && (Max != 10000))
    {
      if (Velocity > Max)
	Velocity = Max;
      else
	if (Velocity < -Max)
	  Velocity = -Max;
    }
  return Velocity;
}
+ (void) setWorldBounds;
{
  return [self setWorldBounds:0];
}
+ (void) setWorldBounds:(float)X;
{
  return [self setWorldBoundsWithParam1:X param2:0];
}
+ (void) setWorldBoundsWithParam1:(float)X param2:(float)Y;
{
  return [self setWorldBoundsWithParam1:X param2:Y param3:0];
}
+ (void) setWorldBoundsWithParam1:(float)X param2:(float)Y param3:(float)Width;
{
  return [self setWorldBoundsWithParam1:X param2:Y param3:Width param4:0];
}
+ (void) setWorldBoundsWithParam1:(float)X param2:(float)Y param3:(float)Width param4:(float)Height;
{
  if ((X == 0) && (Y == 0) && (Width == 0) && (Height == 0))
    {
      X = -128 * FlxG.width;
      Y = -128 * FlxG.height;
      Width = 256 * FlxG.width;
      Height = 256 * FlxG.height;
    }
//    if (quadTreeBounds == nil)
//      quadTreeBounds = [[FlxRect alloc] init];
//    quadTreeBounds.x = X;
//    quadTreeBounds.y = Y;
//    if (Width != 0)
//      quadTreeBounds.width = Width;
//    if (Height != 0)
//      quadTreeBounds.height = Height;
}
+ (BOOL) overlapWithParam1:(FlxObject *)Object1 param2:(FlxObject *)Object2;
{
  return [self overlapWithParam1:Object1 param2:Object2 target:nil action:NULL];
}
//+ (BOOL) overlapWithParam1:(FlxObject *)Object1 param2:(FlxObject *)Object2 param3:(FlashFunction *)Callback;
+ (BOOL) overlapWithParam1:(FlxObject *)Object1 param2:(FlxObject *)Object2 target:(id)target action:(SEL)action
{
  if ((Object1 == nil) || !Object1.exists || (Object2 == nil) || !Object2.exists)
    return NO;
  NSLog(@"FlxU overlap");
//   [quadTree autorelease];
//   quadTree = [[FlxQuadTree alloc] initWithX:quadTreeBounds.x y:quadTreeBounds.y width:quadTreeBounds.width height:quadTreeBounds.height];
//   [quadTree addWithParam1:Object1 param2:FlxQuadTree.A_LIST];
//   if (Object1 == Object2)
//     return [quadTree overlapWithParam1:NO target:target action:action];
//   //return [quadTree overlapWithParam1:NO param2:Callback];
//   [quadTree addWithParam1:Object2 param2:FlxQuadTree.B_LIST];
//   return [quadTree overlapWithParam1:YES target:target action:action];
//   //return [quadTree overlapWithParam1:YES param2:Callback];
  return NO;
}
+ (BOOL) collideWithParam1:(FlxObject *)Object1 param2:(FlxObject *)Object2;
{
  if ((Object1 == nil) || !Object1.exists || (Object2 == nil) || !Object2.exists)
      return NO;
//   [quadTree release];
//   quadTree = [[FlxQuadTree alloc] initWithX:quadTreeBounds.x y:quadTreeBounds.y width:quadTreeBounds.width height:quadTreeBounds.height];
//   [quadTree addWithParam1:Object1 param2:FlxQuadTree.A_LIST];
  BOOL match = Object1 == Object2;
  if (!match)
//     [quadTree addWithParam1:Object2 param2:FlxQuadTree.B_LIST];
//   BOOL cx = [quadTree overlapWithParam1:!match target:self action:@selector(solveXCollisionWithParam1:param2:)];
//   BOOL cy = [quadTree overlapWithParam1:!match target:self action:@selector(solveYCollisionWithParam1:param2:)];
//   return cx || cy;
//   return [quadTree overlapWithParam1:!match target:self action:@selector(solveCollisionWithParam1:param2:)];
    return NO;
  return NO;
}

+ (BOOL) alternateCollideWithParam1:(FlxObject *)Object1 param2:(FlxObject *)Object2;
{
  if (Object1 == nil || !Object1.exists || Object2 == nil || !Object2.exists)
    return NO;
  
  NSMutableSet * set1 = [NSMutableSet set];
  NSMutableSet * set2 = [NSMutableSet set];

  NSMutableSet * toAdd = [NSMutableSet setWithObject:Object1];
  while ([toAdd count] > 0) {
    FlxObject * obj = [toAdd anyObject];
    [toAdd removeObject:obj];
    if ([obj isKindOfClass:[FlxGroup class]]) {
      [toAdd addObjectsFromArray:((FlxGroup *)obj).members];
    } else
      [set1 addObject:obj];
  }
  [toAdd addObject:Object2];
  while ([toAdd count] > 0) {
    FlxObject * obj = [toAdd anyObject];
    [toAdd removeObject:obj];
    if ([obj isKindOfClass:[FlxGroup class]]) {
      [toAdd addObjectsFromArray:((FlxGroup *)obj).members];
    } else
      [set2 addObject:obj];
  }
  //brute force it
  BOOL c = NO;
  for (FlxObject * obj1 in set1) {
    for (FlxObject * obj2 in set2) {
      if (obj1 == obj2 || !obj1.exists || !obj2.exists || !obj1.solid || !obj2.solid ||
	  (obj1.x + obj1.width < obj2.x + roundingError) ||
	  (obj1.x + roundingError > obj2.x + obj2.width) ||
	  (obj1.y + obj1.height < obj2.y + roundingError) ||
	  (obj1.y + roundingError > obj2.y + obj2.height))
	continue;
      c |= [self solveXCollisionWithParam1:obj1 param2:obj2];
      c |= [self solveYCollisionWithParam1:obj1 param2:obj2];
    }
  }
  return c;
}
+ (BOOL) collideObject:(FlxObject *)object withGroup:(FlxGroup *)group;
{
  if (object == nil || !object.exists || group == nil || !group.exists || !object.solid)
    return NO;
  NSMutableSet * toCollide = [NSMutableSet setWithObject:group];
  BOOL c = NO;
  float objectLeft = object.x;// + roundingError;
  float objectRight = object.x + object.width;// - roundingError;
  float objectTop = object.y;// + roundingError;
  float objectBottom = object.y + object.height;// - roundingError;
  while ([toCollide count] > 0) {
    FlxObject * groupObject = [toCollide anyObject];
    [toCollide removeObject:groupObject];
    if ([groupObject isKindOfClass:[FlxGroup class]])
      [toCollide addObjectsFromArray:((FlxGroup *)groupObject).members];
    else if (!(object == groupObject || !groupObject.exists || !groupObject.solid ||
	       objectRight < groupObject.x ||
	       objectLeft > groupObject.x + groupObject.width ||
	       objectBottom < groupObject.y ||
	       objectTop > groupObject.y + groupObject.height))
	{
	  c |= [self solveXCollisionWithParam1:object param2:groupObject];
	  c |= [self solveYCollisionWithParam1:object param2:groupObject];
	}
  }
  return c;
}

// + (BOOL) doCollision:(NSString *)identifier between:(FlxObject *)Object1 and:(FlxObject *)Object2
// {
//   if (Object1 == nil || !Object1.exists || Object2 == nil || !Object2.exists)
//     return NO;
//   FlxStaticQuadTree * sqt = [staticQuadTrees objectForKey:identifier];
//   if (sqt == nil) {
//     sqt = [[FlxStaticQuadTree alloc] initWithX:quadTreeBounds.x y:quadTreeBounds.y width:quadTreeBounds.width height:quadTreeBounds.height];
//     [staticQuadTrees setObject:sqt forKey:identifier];
//   } else {
//     [sqt updateBounds:quadTreeBounds];
//   }
//   [sqt addWithParam1:Object1 param2:FlxStaticQuadTree.A_LIST];
//   BOOL match = Object1 == Object2;
//   if (!match)
//     [sqt addWithParam1:Object2 param2:FlxStaticQuadTree.B_LIST];
//   BOOL cx = [sqt overlapWithParam1:!match target:self action:@selector(solveXCollisionWithParam1:param2:)];
//   BOOL cy = [sqt overlapWithParam1:!match target:self action:@selector(solveYCollisionWithParam1:param2:)];
//   return cx || cy;
// }

+ (BOOL) solveCollisionWithParam1:(FlxObject *)Object1 param2:(FlxObject *)Object2;
{
  BOOL cx = [self solveXCollisionWithParam1:Object1 param2:Object2];
  BOOL cy = [self solveYCollisionWithParam1:Object1 param2:Object2];
  return cx || cy;
}

// #define TILES 6
// + (BOOL) doCollision:(NSString *)identifier between:(FlxObject *)Object1 and:(FlxObject *)Object2
// {
//   NSArray * collisionArray = [collisions objectForKey:identifier];
//   if (collisionArray == nil) {
//     collisionArray = [NSMutableArray array];
//     //create NSMutableSets in collisionArray
//     for (int i=0; i<TILES*TILES; ++i)
// 	[collisionArray addObject:[NSMutableSet set]];
//     [collisions setObject:collisionArray forKey:identifier];
//   }
//   //only add if object is 'solid'
//   //build a list of objects to add
//   NSMutableSet * toCollide = [NSMutableSet set];
//   NSMutableSet * toAdd = nil;
//   if (Object1 && Object2 && Object1 != Object2)
//     toAdd = [NSMutableSet setWithObjects:Object1, Object2, nil];
//   else if (Object1 == Object2 || Object2 == nil)
//     toAdd = [NSMutableSet setWithObject:Object1];
//   else
//     return NO;
//   while ([toAdd count] > 0) {
//     FlxObject * o = [toAdd anyObject];
//     [toAdd removeObject:o];
//     if ([o isKindOfClass:[FlxGroup class]]) {
//       //add all children
//       NSMutableArray * members = ((FlxGroup *)(o)).members;
//       [toAdd addObjectsFromArray:members];
//     } else if (o.solid) {
//       //where does this one go?
//       o.x   quadTreeBounds.width/TILES;
//     }
//   }
// }

+ (BOOL) solveXCollisionWithParam1:(FlxObject *)Object1 param2:(FlxObject *)Object2;
{
  BOOL debug = NO;
  if (Object1.debug || Object2.debug)
    debug = YES;
  float o1 = Object1.colVector.x;
  float o2 = Object2.colVector.x;
  if (o1 == o2)
    return NO;
  [Object1 preCollide:Object2];
  [Object2 preCollide:Object1];
  float overlap;
  BOOL hit = NO;
  BOOL p1hn2;
  BOOL obj1Stopped = o1 == 0;
  BOOL obj1MoveNeg = o1 < 0;
  BOOL obj1MovePos = o1 > 0;
  BOOL obj2Stopped = o2 == 0;
  BOOL obj2MoveNeg = o2 < 0;
  BOOL obj2MovePos = o2 > 0;
  unsigned int i1;
  unsigned int i2;
  CGRect obj1Hull = Object1.colHullX;
  CGRect obj2Hull = Object2.colHullX;

  NSMutableArray * co1 = Object1.colOffsets;
  NSMutableArray * co2 = Object2.colOffsets;
  unsigned int l1 = co1.length;
  unsigned int l2 = co2.length;
  float ox1;
  float oy1;
  float ox2;
  float oy2;
  float r1;
  float r2;
  float sv1;
  float sv2;
  p1hn2 = ((obj1Stopped && obj2MoveNeg) ||
	   (obj1MovePos && obj2Stopped) ||
	   (obj1MovePos && obj2MoveNeg) ||
	   (obj1MoveNeg && obj2MoveNeg && (((o1 > 0) ? o1 : -o1) < ((o2 > 0) ? o2 : -o2))) ||
	   (obj1MovePos && obj2MovePos && (((o1 > 0) ? o1 : -o1) > ((o2 > 0) ? o2 : -o2))));
  if (p1hn2 ? (!Object1.collideRight || !Object2.collideLeft) : (!Object1.collideLeft || !Object2.collideRight))
    return NO;
  for ( i1 = 0; i1 < l1; i1++ )
    {
      CGPoint oc1 = [[co1 objectAtIndex:i1] CGPointValue];
      ox1 = oc1.x;
      oy1 = oc1.y;
      obj1Hull.origin.x += ox1;
      obj1Hull.origin.y += oy1;
      for ( i2 = 0; i2 < l2; i2++ )
	{
          CGPoint oc2 = [[co2 objectAtIndex:i2] CGPointValue];
	  ox2 = oc2.x;
	  oy2 = oc2.y;
	  obj2Hull.origin.x += ox2;
	  obj2Hull.origin.y += oy2;
	  if ((obj1Hull.origin.x + obj1Hull.size.width - obj2Hull.origin.x < roundingError) ||
 	      (roundingError > obj2Hull.origin.x + obj2Hull.size.width - obj1Hull.origin.x) ||
	      (obj1Hull.origin.y + obj1Hull.size.height - obj2Hull.origin.y < roundingError) ||
 	      (roundingError > obj2Hull.origin.y + obj2Hull.size.height - obj1Hull.origin.y))
	    {
	      obj2Hull.origin.x -= ox2;
	      obj2Hull.origin.y -= oy2;
	      continue;
	    }
	  if (p1hn2)
	    {
	      if (obj1MoveNeg)
		r1 = obj1Hull.origin.x + Object1.colHullY.size.width;
	      else
		r1 = obj1Hull.origin.x + obj1Hull.size.width;
	      if (obj2MoveNeg)
		r2 = obj2Hull.origin.x;
	      else
		r2 = obj2Hull.origin.x + obj2Hull.size.width - Object2.colHullY.size.width;
	    }
	  else
	    {
	      if (obj2MoveNeg)
		r1 = -obj2Hull.origin.x - Object2.colHullY.size.width;
	      else
		r1 = -obj2Hull.origin.x - obj2Hull.size.width;
	      if (obj1MoveNeg)
		r2 = -obj1Hull.origin.x;
	      else
		r2 = -obj1Hull.origin.x - obj1Hull.size.width + Object1.colHullY.size.width;
	    }
	  overlap = r1 - r2;
	  if ((overlap == 0) ||
	      ((!Object1.fixed && ((overlap > 0) ? overlap : -overlap) > obj1Hull.size.width * 0.8)) ||
	      ((!Object2.fixed && ((overlap > 0) ? overlap : -overlap) > obj2Hull.size.width * 0.8)))
	    {
	      obj2Hull.origin.x -= ox2;
	      obj2Hull.origin.y -= oy2;
	      continue;
	    }
	  hit = YES;
	  sv1 = Object2.velocity.x;
	  sv2 = Object1.velocity.x;
	  if (!Object1.fixed && Object2.fixed)
	    {
	      if ([Object1 isKindOfClass:[FlxGroup class]])
		[(FlxGroup *)Object1 resetWithParam1:Object1.x - overlap param2:Object1.y];
	      else
		Object1.x -= overlap;
	    }
	  else
	    if (Object1.fixed && !Object2.fixed)
	      {
		if ([Object2 isKindOfClass:[FlxGroup class]])
		  [(FlxGroup *)Object2 resetWithParam1:Object2.x + overlap param2:Object2.y];
		else
		  Object2.x += overlap;
	      }
	    else
	      if (!Object1.fixed && !Object2.fixed)
		{
		  overlap /= 2;
		  if ([Object1 isKindOfClass:[FlxGroup class]])
		    [(FlxGroup *)Object1 resetWithParam1:Object1.x - overlap param2:Object1.y];
		  else
		    Object1.x -= overlap;
		  if ([Object2 isKindOfClass:[FlxGroup class]])
		    [(FlxGroup *)Object2 resetWithParam1:Object2.x + overlap param2:Object2.y];
		  else
		    Object2.x += overlap;
		  sv1 /= 2;
		  sv2 /= 2;
		}
	  if (p1hn2)
	    {
	      if (debug)
		NSLog(@"hit right/left");
	      [Object1 hitRightWithParam1:Object2 param2:sv1];
	      [Object2 hitLeftWithParam1:Object1 param2:sv2];
	    }
	  else
	    {
	      if (debug)
		NSLog(@"hit right/left");
	      [Object1 hitLeftWithParam1:Object2 param2:sv1];
	      [Object2 hitRightWithParam1:Object1 param2:sv2];
	    }
	  if (!Object1.fixed && (overlap != 0))
	    {
	      if (p1hn2)
		obj1Hull.size.width -= overlap;
	      else
		{
		  obj1Hull.origin.x -= overlap;
		  obj1Hull.size.width += overlap;
		}
              CGRect o1ColHullY = Object1.colHullY;
              o1ColHullY.origin.x -= overlap;
              Object1.colHullY = o1ColHullY;
	    }
	  if (!Object2.fixed && (overlap != 0))
	    {
	      if (p1hn2)
		{
		  obj2Hull.origin.x += overlap;
		  obj2Hull.size.width -= overlap;
		}
	      else
		obj2Hull.size.width += overlap;
              CGRect o2ColHullY = Object2.colHullY;
              o2ColHullY.origin.x += overlap;
              Object2.colHullY = o2ColHullY;
	    }
	  obj2Hull.origin.x -= ox2;
	  obj2Hull.origin.y -= oy2;
	}
      obj1Hull.origin.x -= ox1;
      obj1Hull.origin.y -= oy1;
    }
  Object1.colHullX = obj1Hull;
  Object2.colHullX = obj2Hull;
  return hit;
}
+ (BOOL) solveYCollisionWithParam1:(FlxObject *)Object1 param2:(FlxObject *)Object2;
{
  BOOL debug = NO;
  if (Object1.debug || Object2.debug)
    debug = YES;
  float o1 = Object1.colVector.y;
  float o2 = Object2.colVector.y;
  if (o1 == o2)
    return NO;
  [Object1 preCollide:Object2];
  [Object2 preCollide:Object1];
  float overlap;
  BOOL hit = NO;
  BOOL p1hn2;
  BOOL obj1Stopped = o1 == 0;
  BOOL obj1MoveNeg = o1 < 0;
  BOOL obj1MovePos = o1 > 0;
  BOOL obj2Stopped = o2 == 0;
  BOOL obj2MoveNeg = o2 < 0;
  BOOL obj2MovePos = o2 > 0;
  unsigned int i1;
  unsigned int i2;
  CGRect obj1Hull = Object1.colHullY;
  CGRect obj2Hull = Object2.colHullY;
  NSMutableArray * co1 = Object1.colOffsets;
  NSMutableArray * co2 = Object2.colOffsets;
  unsigned int l1 = co1.length;
  unsigned int l2 = co2.length;
  float ox1;
  float oy1;
  float ox2;
  float oy2;
  float r1;
  float r2;
  float sv1;
  float sv2;
  p1hn2 = ((obj1Stopped && obj2MoveNeg) || (obj1MovePos && obj2Stopped) || (obj1MovePos && obj2MoveNeg) || (obj1MoveNeg && obj2MoveNeg && (((o1 > 0) ? o1 : -o1) < ((o2 > 0) ? o2 : -o2))) || (obj1MovePos && obj2MovePos && (((o1 > 0) ? o1 : -o1) > ((o2 > 0) ? o2 : -o2))));
  if (p1hn2 ? (!Object1.collideBottom || !Object2.collideTop) : (!Object1.collideTop || !Object2.collideBottom))
    return NO;
  for ( i1 = 0; i1 < l1; i1++ )
    {
      CGPoint oc1 = [[co1 objectAtIndex:i1] CGPointValue];
      ox1 = oc1.x;
      oy1 = oc1.y;
      obj1Hull.origin.x += ox1;
      obj1Hull.origin.y += oy1;
      for ( i2 = 0; i2 < l2; i2++ )
	{
          CGPoint oc2 = [[co2 objectAtIndex:i2] CGPointValue];
          ox2 = oc2.x;
          oy2 = oc2.y;
	  obj2Hull.origin.x += ox2;
	  obj2Hull.origin.y += oy2;
	  if ((obj1Hull.origin.x + obj1Hull.size.width - obj2Hull.origin.x < roundingError) ||
 	      (roundingError > obj2Hull.origin.x + obj2Hull.size.width - obj1Hull.origin.x) ||
	      (obj1Hull.origin.y + obj1Hull.size.height - obj2Hull.origin.y < roundingError) ||
 	      (roundingError > obj2Hull.origin.y + obj2Hull.size.height - obj1Hull.origin.y))
	    {
	      obj2Hull.origin.x -= ox2;
	      obj2Hull.origin.y -= oy2;
	      continue;
	    }
	  if (p1hn2)
	    {
	      if (obj1MoveNeg)
		r1 = obj1Hull.origin.y + Object1.colHullX.size.height;
	      else
		r1 = obj1Hull.origin.y + obj1Hull.size.height;
	      if (obj2MoveNeg)
		r2 = obj2Hull.origin.y;
	      else
		r2 = obj2Hull.origin.y + obj2Hull.size.height - Object2.colHullX.size.height;
	    }
	  else
	    {
	      if (obj2MoveNeg)
		r1 = -obj2Hull.origin.y - Object2.colHullX.size.height;
	      else
		r1 = -obj2Hull.origin.y - obj2Hull.size.height;
	      if (obj1MoveNeg)
		r2 = -obj1Hull.origin.y;
	      else
		r2 = -obj1Hull.origin.y - obj1Hull.size.height + Object1.colHullX.size.height;
	    }
	  overlap = r1 - r2;
	  if ((overlap == 0) || ((!Object1.fixed && ((overlap > 0) ? overlap : -overlap) > obj1Hull.size.height * 0.8)) || ((!Object2.fixed && ((overlap > 0) ? overlap : -overlap) > obj2Hull.size.height * 0.8)))
	    {
	      obj2Hull.origin.x -= ox2;
	      obj2Hull.origin.y -= oy2;
	      continue;
	    }
	  hit = YES;
	  sv1 = Object2.velocity.y;
	  sv2 = Object1.velocity.y;
	  if (!Object1.fixed && Object2.fixed)
	    {
	      if ([Object1 isKindOfClass:[FlxGroup class]])
		[(FlxGroup *)Object1 resetWithParam1:Object1.x param2:Object1.y - overlap];
	      else
		Object1.y -= overlap;
	    }
	  else
	    if (Object1.fixed && !Object2.fixed)
	      {
		if ([Object2 isKindOfClass:[FlxGroup class]])
		  [(FlxGroup *)Object2 resetWithParam1:Object2.x param2:Object2.y + overlap];
		else
		  Object2.y += overlap;
	      }
	    else
	      if (!Object1.fixed && !Object2.fixed)
		{
		  overlap /= 2;
		  if ([Object1 isKindOfClass:[FlxGroup class]])
		    [(FlxGroup *)Object1 resetWithParam1:Object1.x param2:Object1.y - overlap];
		  else
		    Object1.y -= overlap;
		  if ([Object2 isKindOfClass:[FlxGroup class]])
		    [(FlxGroup *)Object2 resetWithParam1:Object2.x param2:Object2.y + overlap];
		  else
		    Object2.y += overlap;
		  sv1 /= 2;
		  sv2 /= 2;
		}
	  if (p1hn2)
	    {
	      [Object1 hitBottomWithParam1:Object2 param2:sv1];
	      [Object2 hitTopWithParam1:Object1 param2:sv2];
	    }
	  else
	    {
	      [Object1 hitTopWithParam1:Object2 param2:sv1];
	      [Object2 hitBottomWithParam1:Object1 param2:sv2];
	    }
	  if (!Object1.fixed && (overlap != 0))
	    {
	      if (p1hn2)
		{
		  obj1Hull.origin.y -= overlap;
		  if (Object2.fixed && Object2.moves)
		    {
		      sv1 = Object2.colVector.x;
		      Object1.x += sv1;
		      obj1Hull.origin.x += sv1;
                      CGRect o1ColHullX = Object1.colHullX;
                      o1ColHullX.origin.x += sv1;
                      Object1.colHullX = o1ColHullX;
		    }
		}
	      else
		{
		  obj1Hull.origin.y -= overlap;
		  obj1Hull.size.height += overlap;
		}
	    }
	  if (!Object2.fixed && (overlap != 0))
	    {
	      if (p1hn2)
		{
		  obj2Hull.origin.y += overlap;
		  obj2Hull.size.height -= overlap;
		}
	      else
		{
		  obj2Hull.size.height += overlap;
		  if (Object1.fixed && Object1.moves)
		    {
		      sv2 = Object1.colVector.x;
		      Object2.x += sv2;
		      obj2Hull.origin.x += sv2;
                      CGRect o2ColHullX = Object2.colHullX;
                      o2ColHullX.origin.x += sv2;
                      Object2.colHullX = o2ColHullX;
		    }
		}
	    }
	  obj2Hull.origin.x -= ox2;
	  obj2Hull.origin.y -= oy2;
	}
      obj1Hull.origin.x -= ox1;
      obj1Hull.origin.y -= oy1;
    }
  Object1.colHullY = obj1Hull;
  Object2.colHullY = obj2Hull;
  return hit;
}
@end
