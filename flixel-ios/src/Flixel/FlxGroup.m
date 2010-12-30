//
//  FlxGroup.m
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

@interface FlxGroup ()
- (void) saveOldPosition;
- (void) updateMembers;
- (void) renderMembers;
- (void) killMembers;
- (void) destroyMembers;
@property (assign) CGPoint _last;
@property (assign) BOOL _first;
@end

@implementation FlxGroup

@synthesize _last, _first;

@synthesize members;

- (void) setMembers:(NSMutableArray *)newMembers
{
  if (members)
    [members autorelease];
  members = [newMembers mutableCopy];
}

- (id) init
{
  return [self initWithX:0 y:0 width:0 height:0];
}

- (id) initWithX:(float)X y:(float)Y width:(float)Width height:(float)Height;
{
  if ((self = [super initWithX:X y:Y width:Width height:Height])) {
    _group = YES;
    solid = NO;
     members = [[NSMutableArray alloc] init];
     _last = CGPointZero;
    _first = YES;
  }
  return self;
}
- (void) dealloc
{
  [members release];
  [super dealloc];
}
- (FlxObject *) add:(FlxObject *)Object;
{
  return [self addWithParam1:Object param2:NO];
}
- (FlxObject *) addWithParam1:(FlxObject *)Object param2:(BOOL)ShareScroll;
{
  [members push:Object];
  if (ShareScroll)
    Object.scrollFactor = scrollFactor;
  return Object;
}
- (FlxObject *) replaceWithParam1:(FlxObject *)OldObject param2:(FlxObject *)NewObject;
{
  int index = [members indexOf:OldObject];
  if ((index < 0) || (index >= members.length))
    return nil;
  [members replaceObjectAtIndex:index withObject:NewObject];
  //[members objectAtIndex:index] = NewObject;
  return NewObject;
}
- (FlxObject *) replaceObjectAtIndex:(unsigned int)index withObject:(FlxObject *)NewObject;
{
  if ((index < 0) || (index >= members.length))
    return nil;
  [members replaceObjectAtIndex:index withObject:NewObject];
  return NewObject;
}
- (FlxObject *) remove:(FlxObject *)Object;
{
  int index = [members indexOf:Object];
  if ((index < 0) || (index >= members.length))
    return nil;
  [members removeObjectAtIndex:index];
  //[members objectAtIndex:index] = nil;
  return Object;
}
- (FlxObject *) getFirstAvail;
{
  unsigned int ml = members.length;
  for ( unsigned int i = 0; i < ml; i++ )
    {
      if (!(((FlxObject *)([members objectAtIndex:i]))).exists)
	return ((FlxObject *)([members objectAtIndex:i]));
    }
  return nil;
}
- (BOOL) resetFirstAvail;
{
  return [self resetFirstAvail:0];
}
- (BOOL) resetFirstAvail:(float)X;
{
  return [self resetFirstAvailWithParam1:X param2:0];
}
- (BOOL) resetFirstAvailWithParam1:(float)X param2:(float)Y;
{
  FlxObject * o = [self getFirstAvail];
  if (o == nil)
    return NO;
  [o resetWithParam1:X param2:Y];
  return YES;
}
- (FlxObject *) getFirstExtant;
{
  unsigned int ml = members.length;
  for ( unsigned int i = 0; i < ml; i++ )
    {
      if ((((FlxObject *)([members objectAtIndex:i]))).exists)
	return ((FlxObject *)([members objectAtIndex:i]));
    }
  return nil;
}
- (FlxObject *) getFirstAlive;
{
  unsigned int ml = members.length;
  for ( unsigned int i = 0; i < ml; i++ )
    {
      if (!(((FlxObject *)([members objectAtIndex:i]))).dead)
	return ((FlxObject *)([members objectAtIndex:i]));
    }
  return nil;
}
- (FlxObject *) getFirstDead;
{
  unsigned int ml = members.length;
  for ( unsigned int i = 0; i < ml; i++ )
    {
      if ((((FlxObject *)([members objectAtIndex:i]))).dead)
	return ((FlxObject *)([members objectAtIndex:i]));
    }
  return nil;
}
- (int) countLiving;
{
  int count = -1;
  unsigned int ml = members.length;
  for ( unsigned int i = 0; i < ml; i++ )
    {
      if (!(((FlxObject *)([members objectAtIndex:i]))).dead)
	{
	  if (count < 0)
	    count = 0;
	  count++;
	}
    }
  return count;
}
- (int) countDead;
{
  int count = -1;
  unsigned int ml = members.length;
  for ( unsigned int i = 0; i < ml; i++ )
    {
      if ((((FlxObject *)([members objectAtIndex:i]))).dead)
	{
	  if (count < 0)
	    count = 0;
	  count++;
	}
    }
  return count;
}
- (FlxObject *) getRandom;
{
  return ((FlxObject *)([members objectAtIndex:[FlxU floor:[FlxU random] * members.length]]));
}
- (void) saveOldPosition;
{
  if (_first)
    {
      _first = NO;
      _last.x = 0;
      _last.y = 0;
      return;
    }
  _last.x = x;
  _last.y = y;
}
- (void) updateMembers;
{
  float mx;
  float my;
  BOOL moved = NO;
  if ((x != _last.x) || (y != _last.y))
    {
      moved = YES;
      mx = x - _last.x;
      my = y - _last.y;
    }
  FlxObject * o;
  unsigned int l = members.length;
  for ( unsigned int i = 0; i < l; i++ )
    {
      o = ((FlxObject *)([members objectAtIndex:i]));
      if ((o != nil) && o.exists)
	{
	  if (moved)
	    {
	      if ([o isKindOfClass:[FlxGroup class]])
		[o resetWithParam1:o.x + mx param2:o.y + my];
	      else
		{
		  o.x += mx;
		  o.y += my;
		}
	    }
	  if (o.active) {
	    [o update];
	  }
	  if (moved && o.solid)
	    {
              CGRect o_colHullX = o.colHullX;
	      o_colHullX.size.width += ((mx > 0) ? mx : -mx);
	      if (mx < 0)
		o_colHullX.origin.x += mx;
              o.colHullX = o_colHullX;
              CGRect o_colHullY = o.colHullY;
	      o_colHullY.origin.x = x;
	      o_colHullY.size.height += ((my > 0) ? my : -my);
	      if (my < 0)
		o_colHullY.origin.y += my;
              o.colHullY = o_colHullY;
              CGPoint o_colVector = o.colVector;
	      o_colVector.x += mx;
	      o_colVector.y += my;
              o.colVector = o_colVector;
	    }
	}
    }
}
- (void) update;
{
  [self saveOldPosition];
  [self updateMotion];
  [self updateMembers];
  [self updateFlickering];
}

- (void) setX:(float)newX
{
  float mx = newX-self.x;
  for (FlxObject * o in members) {
    if (o.exists) {
      if ([o isKindOfClass:[FlxGroup class]])
	[o resetWithParam1:o.x+mx param2:o.y];
      else
	o.x += mx;
    }
  }
  super.x = newX;
}

- (void) setY:(float)newY
{
  float my = newY-self.y;
  for (FlxObject * o in members) {
    if (o.exists) {
      if ([o isKindOfClass:[FlxGroup class]])
	[o resetWithParam1:o.y param2:o.y+my];
      else
	o.y += my;
    }
  }
  super.y = newY;
}

- (void) renderMembers;
{
  for (FlxObject * o in members)
    if ((o != nil) && o.exists && o.visible)
      [o render];

//   FlxObject * o;
//   unsigned int l = members.length;
//   for ( unsigned int i = 0; i < l; i++ )
//     {
//       o = ((FlxObject *)([members objectAtIndex:i]));
//       if ((o != nil) && o.exists && o.visible)
// 	[o render];
//     }
}
- (void) render;
{
  [self renderMembers];
}
- (void) killMembers;
{
  FlxObject * o;
  unsigned int l = members.length;
  for ( unsigned int i = 0; i < l; i++ )
    {
      o = ((FlxObject *)([members objectAtIndex:i]));
      if (o != nil)
	[o kill];
    }
}
- (void) kill;
{
  [self killMembers];
  [super kill];
}
- (void) destroyMembers;
{
  FlxObject * o;
  unsigned int l = members.length;
  for ( unsigned int i = 0; i < l; i++ )
    {
      o = ((FlxObject *)([members objectAtIndex:i]));
      if (o != nil) {
	[o destroy];
      }
    }
  //members.length = 0;
  [members removeAllObjects]; //dies right here...
}
- (void) destroy;
{
  [self destroyMembers];
  [super destroy];
}
- (void) resetWithParam1:(float)X param2:(float)Y;
{
  [self saveOldPosition];
  [super resetWithParam1:X param2:Y];
  float mx;
  float my;
  BOOL moved = NO;
  if ((x != _last.x) || (y != _last.y))
    {
      moved = YES;
      mx = x - _last.x;
      my = y - _last.y;
    }
  FlxObject * o;
  unsigned int l = members.length;
  for ( unsigned int i = 0; i < l; i++ )
    {
      o = ((FlxObject *)([members objectAtIndex:i]));
      if ((o != nil) && o.exists)
	{
	  if (moved)
	    {
	      if ([o isKindOfClass:[FlxGroup class]])
		[o resetWithParam1:o.x + mx param2:o.y + my];
	      else
		{
		  o.x += mx;
		  o.y += my;
		  if (solid)
		    {
                      CGRect o_colHullX = o.colHullX;
		      o_colHullX.size.width += ((mx > 0) ? mx : -mx);
		      if (mx < 0)
			o_colHullX.origin.x += mx;
                      o.colHullX = o_colHullX;
                      CGRect o_colHullY = o.colHullY;
		      o_colHullY.origin.x = x;
		      o_colHullY.size.height += ((my > 0) ? my : -my);
		      if (my < 0)
			o_colHullY.origin.y += my;
                      o.colHullY = o_colHullY;
                      CGPoint o_colVector = o.colVector;
		      o_colVector.x += mx;
		      o_colVector.y += my;
                      o.colVector = o_colVector;
		    }
		}
	    }
	}
    }
}

- (void) removeAllObjects;
{
  [members removeAllObjects];
}

@end
