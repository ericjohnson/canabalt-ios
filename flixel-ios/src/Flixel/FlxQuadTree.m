//
//  FlxQuadTree.m
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

//static const float MIN = 48;
//static const float MIN = 96;
//static const float MIN = 128;
static const float MIN = 160;
static const unsigned int A_LIST = 0;
static const unsigned int B_LIST = 1;

static FlxObject * _o;
static float _ol;
static float _ot;
static float _or;
static float _ob;
static unsigned int _oa;
//static FlashFunction * _oc;

typedef struct PoolEntry_t PoolEntry_t;
struct PoolEntry_t {
  FlxQuadTree * value;
  PoolEntry_t * next;
  PoolEntry_t * prev;
};

static PoolEntry_t * freePoolHead = NULL;

static PoolEntry_t * usedPoolHead = NULL;

static unsigned int poolSize = 16;

@interface FlxQuadTree ()
@property (retain) FlxList * _headA;
@property (retain) FlxList * _headB;
@property (retain) FlxList * _tailA;
@property (retain) FlxList * _tailB;
@property (assign) void * poolEntry;
- (void) addObject;
- (void) addToList;
- (BOOL) overlapNode;
- (BOOL) overlapNode:(FlxList *)Iterator;

+ (id) poolAlloc;
- (id) poolInit;
- (void) poolDealloc;
- (void) reInitWithX:(float)x y:(float)y width:(float)width height:(float)height parent:(FlxQuadTree *)parent;
- (id) trueInitWithX:(float)X y:(float)Y width:(float)Width height:(float)Height parent:(FlxQuadTree *)Parent;
//@property (assign) int poolRetainCount;
@end


@implementation FlxQuadTree

@synthesize poolEntry;
//@synthesize poolRetainCount;

+ (void) increasePoolSize
{
  //increase pool size by 2
  PoolEntry_t * newPoolEntries = calloc(poolSize, sizeof(PoolEntry_t));
  for (int i=0; i<poolSize; ++i) {
    if (i == poolSize-1)
      newPoolEntries[poolSize-1].next = NULL;
    else
      newPoolEntries[i].next = &newPoolEntries[i+1];
    newPoolEntries[i].value = [[FlxQuadTree poolAlloc] poolInit];
    //set poolRetainCount to zero?
    //newPoolEntries[i].value.poolRetainCount = 0;
    newPoolEntries[i].value.poolEntry = &newPoolEntries[i];
  }
  freePoolHead = &newPoolEntries[0];
  poolSize *= 2;
  NSLog(@"FlxQuadTree: increasing pool size: %d", poolSize);
}

+ (FlxQuadTree *) popFreeEntry
{
  //NSLog(@"alloc'ing new FlxQuadTree");
  FlxQuadTree * ret = freePoolHead->value;

  PoolEntry_t * tmp = freePoolHead;
  freePoolHead = freePoolHead->next;
  if (freePoolHead == NULL)
    [self increasePoolSize];

  tmp->next = usedPoolHead;
  if (usedPoolHead)
    usedPoolHead->prev = tmp;
  usedPoolHead = tmp;
  tmp->prev = NULL;
  
  //ret.poolRetainCount = 1;
  
  return ret;
}

+ (void) pushUsedEntry:(FlxQuadTree *)done
{
  //can we find it somehow?
  PoolEntry_t * old = done.poolEntry;
  PoolEntry_t * n = old->next;
  PoolEntry_t * p = old->prev;
  if (n)
    n->prev = p;
  if (p)
    p->next = n;
  else
    usedPoolHead = n;
  old->prev = NULL;
  old->next = freePoolHead;
  freePoolHead = old;
  //done.poolRetainCount = 0;
}

+ (void) initialize
{
  if (self == [FlxQuadTree class]) {
    [self increasePoolSize];
    //first time we do this, it isn't accurate, need to undo it
    poolSize /= 2;
  }
}

+ (float) MIN { return MIN; }
+ (unsigned int) A_LIST { return A_LIST; }
+ (unsigned int) B_LIST { return B_LIST; }

@synthesize _headA, _headB, _tailA, _tailB;

+ (id) alloc
{
  //   return [self realAlloc];
  //   //pop an entry off of the stack
  //   NSLog(@"FlxQuadTree alloc");
  return [[self popFreeEntry] retain];
  //return [[self allocWithZone:NULL] retain];
}


+ (id) poolAlloc
{
  return [self allocWithZone:NULL];
}

- (id) initWithX:(float)X y:(float)Y width:(float)Width height:(float)Height;
{
   return [self initWithX:X y:Y width:Width height:Height parent:nil];
}
- (id) initWithX:(float)X y:(float)Y width:(float)Width height:(float)Height parent:(FlxQuadTree *)Parent;
{
  //return [self trueInitWithX:X y:Y width:Width height:Height parent:Parent];
  
  [self reInitWithX:X y:Y width:Width height:Height parent:Parent];
  return self;
}

- (id) poolInit
{
  id tmp = nil;
  if ((tmp = [super initWithX:0 y:0 width:0 height:0]) == nil)
    return nil;

  if (tmp != self) {
    NSLog(@"unexpected behavior in FlxQuadTree realInit method!");
  }
  //
  
  return self;
}



- (void) reInitWithX:(float)X y:(float)Y width:(float)Width height:(float)Height parent:(FlxQuadTree *)Parent
{
  //NSLog(@"FlxQuadTree reInit");
  //FlxPoint init
  x = X;
  y = Y;
  //end FlxPoint init
  //FlxRect init
  width = Width;
  height = Height;
  //end FlxRect init

  //begin FlxQuadTree init
  _canSubdivide = (Width > MIN) || (Height > MIN);
  _headA = _tailA = [[[FlxList alloc] init] retain]; //float retain since assigned to 2 objects
  _headB = _tailB = [[[FlxList alloc] init] retain];
  if (Parent)
    {
      FlxList * itr;
      FlxList * ot;
      if (Parent._headA.object != nil)
	{
	  itr = Parent._headA;
	  while (itr != nil)
	    {
	      if (_tailA.object != nil)
		{
		  ot = _tailA;
		  [_tailA autorelease];
		  _tailA = [[FlxList alloc] init];
		  ot.next = _tailA;
		}
	      _tailA.object = itr.object;
	      itr = itr.next;
	    }
	}
      if (Parent._headB.object != nil)
	{
	  itr = Parent._headB;
	  while (itr != nil)
	    {
	      if (_tailB.object != nil)
		{
		  ot = _tailB;
		  [_tailB autorelease];
		  _tailB = [[FlxList alloc] init];
		  ot.next = _tailB;
		}
	      _tailB.object = itr.object;
	      itr = itr.next;
	    }
	}
    }
  _nw = nil;
  _ne = nil;
  _se = nil;
  _sw = nil;
  _l = x;
  _r = x + width;
  _hw = width / 2;
  _mx = _l + _hw;
  _t = y;
  _b = y + height;
  _hh = height / 2;
  _my = _t + _hh;
  //end FlxQuadTree init  
}

- (id) trueInitWithX:(float)X y:(float)Y width:(float)Width height:(float)Height parent:(FlxQuadTree *)Parent
{
  if ((self = [super initWithX:X y:Y width:Width height:Height])) {
    _canSubdivide = (Width > MIN) || (Height > MIN);
    _headA = _tailA = [[[FlxList alloc] init] retain]; //float retain since assigned to 2 objects
    _headB = _tailB = [[[FlxList alloc] init] retain];
    if (Parent)
      {
	FlxList * itr;
	FlxList * ot;
	if (Parent._headA.object != nil)
	  {
	    itr = Parent._headA;
	    while (itr != nil)
	      {
		if (_tailA.object != nil)
		  {
		    ot = _tailA;
		    [_tailA autorelease];
		    _tailA = [[FlxList alloc] init];
		    ot.next = _tailA;
		  }
		_tailA.object = itr.object;
		itr = itr.next;
	      }
	  }
	if (Parent._headB.object != nil)
	  {
	    itr = Parent._headB;
	    while (itr != nil)
	      {
		if (_tailB.object != nil)
		  {
		    ot = _tailB;
		    [_tailB autorelease];
		    _tailB = [[FlxList alloc] init];
		    ot.next = _tailB;
		  }
		_tailB.object = itr.object;
		itr = itr.next;
	      }
	  }
      }
    _nw = nil;
    _ne = nil;
    _se = nil;
    _sw = nil;
    _l = x;
    _r = x + width;
    _hw = width / 2;
    _mx = _l + _hw;
    _t = y;
    _b = y + height;
    _hh = height / 2;
    _my = _t + _hh;
  }
  return self;
}

- (id) retain
{
//   return [self retain];
  poolRetainCount++;
  return self;
}

- (oneway void) release
{
  poolRetainCount--;
  if (poolRetainCount == 0) {
    //[self dealloc];
    //push this back on the stack
    [self poolDealloc];
    [FlxQuadTree pushUsedEntry:self];
  }
}

- (void) poolDealloc
{
  //NSLog(@"FlxQuadTree poolDealloc");
  [_headA release];
  [_headB release];
  [_tailA release];
  [_tailB release];
  [_nw release];
  [_ne release];
  [_sw release];
  [_se release];
  _headA = _headB = _tailA = _tailB = nil;
  _nw = _ne = _sw = _se = nil;
  _canSubdivide = NO;
  _l = _r = _t = _b = _hw = _hh = _mx = _my = 0;
  x = y = width = height = 0;
}

- (void) dealloc
{
  [_tailB release];
  [_headB release];
  [_nw release];
  [_ne release];
  [_tailA release];
  [_sw release];
  [_se release];
  [_headA release];
  [super dealloc];
}

- (void) addWithParam1:(FlxObject *)Object param2:(unsigned int)List;
{
  _oa = List;
  if ([Object isKindOfClass:[FlxGroup class]])
    {
      FlxObject * m;
      NSMutableArray * members = (((FlxGroup *)(Object))).members;
      unsigned int l = members.length;
      for ( unsigned int i = 0; i < l; i++ )
	{
	  m = ((FlxObject *)([members objectAtIndex:i]));
	  if ((m != nil) && m.exists)
	    {
	      if ([m isKindOfClass:[FlxGroup class]])
		[self addWithParam1:m param2:List];
	      else
		if (m.solid)
		  {
		    [_o autorelease];
		    _o = [m retain];
		    _ol = _o.x;
		    _ot = _o.y;
		    _or = _o.x + _o.width;
		    _ob = _o.y + _o.height;
		    [self addObject];
		  }
	    }
	}
    }
  if (Object.solid)
    {
      [_o autorelease];
      _o = [Object retain];
      _ol = _o.x;
      _ot = _o.y;
      _or = _o.x + _o.width;
      _ob = _o.y + _o.height;
      [self addObject];
    }
}
- (void) addObject;
{
  if (!_canSubdivide || ((_l >= _ol) && (_r <= _or) && (_t >= _ot) && (_b <= _ob)))
    {
      [self addToList];
      return;
    }
  if ((_ol > _l) && (_or < _mx))
    {
      if ((_ot > _t) && (_ob < _my))
	{
	  if (_nw == nil)
	    _nw = [[FlxQuadTree alloc] initWithX:_l y:_t width:_hw height:_hh parent:self];
	  [_nw addObject];
	  return;
	}
      if ((_ot > _my) && (_ob < _b))
	{
	  if (_sw == nil)
	    _sw = [[FlxQuadTree alloc] initWithX:_l y:_my width:_hw height:_hh parent:self];
	  [_sw addObject];
	  return;
	}
    }
  if ((_ol > _mx) && (_or < _r))
    {
      if ((_ot > _t) && (_ob < _my))
	{
	  if (_ne == nil)
	    _ne = [[FlxQuadTree alloc] initWithX:_mx y:_t width:_hw height:_hh parent:self];
	  [_ne addObject];
	  return;
	}
      if ((_ot > _my) && (_ob < _b))
	{
	  if (_se == nil)
	    _se = [[FlxQuadTree alloc] initWithX:_mx y:_my width:_hw height:_hh parent:self];
	  [_se addObject];
	  return;
	}
    }
  if ((_or > _l) && (_ol < _mx) && (_ob > _t) && (_ot < _my))
    {
      if (_nw == nil)
	_nw = [[FlxQuadTree alloc] initWithX:_l y:_t width:_hw height:_hh parent:self];
      [_nw addObject];
    }
  if ((_or > _mx) && (_ol < _r) && (_ob > _t) && (_ot < _my))
    {
      if (_ne == nil)
	_ne = [[FlxQuadTree alloc] initWithX:_mx y:_t width:_hw height:_hh parent:self];
      [_ne addObject];
    }
  if ((_or > _mx) && (_ol < _r) && (_ob > _my) && (_ot < _b))
    {
      if (_se == nil)
	_se = [[FlxQuadTree alloc] initWithX:_mx y:_my width:_hw height:_hh parent:self];
      [_se addObject];
    }
  if ((_or > _l) && (_ol < _mx) && (_ob > _my) && (_ot < _b))
    {
      if (_sw == nil)
	_sw = [[FlxQuadTree alloc] initWithX:_l y:_my width:_hw height:_hh parent:self];
      [_sw addObject];
    }
}
- (void) addToList;
{
  FlxList * ot;
  if (_oa == A_LIST)
    {
      if (_tailA.object != nil)
	{
	  ot = _tailA;
	  [_tailA autorelease];
	  _tailA = [[FlxList alloc] init];
	  ot.next = _tailA;
	}
      _tailA.object = _o;
    }
  else
    {
      if (_tailB.object != nil)
	{
	  ot = _tailB;
	  [_tailB autorelease];
	  _tailB = [[FlxList alloc] init];
	  ot.next = _tailB;
	}
      _tailB.object = _o;
    }
  if (!_canSubdivide)
    return;
  if (_nw != nil)
    [_nw addToList];
  if (_ne != nil)
    [_ne addToList];
  if (_se != nil)
    [_se addToList];
  if (_sw != nil)
    [_sw addToList];
}
- (BOOL) overlap;
{
   return [self overlap:YES];
}
- (BOOL) overlap:(BOOL)BothLists;
{
  return [self overlapWithParam1:BothLists target:nil action:NULL];
}
//- (BOOL) overlapWithParam1:(BOOL)BothLists param2:(FlashFunction *)Callback;
- (BOOL) overlapWithParam1:(BOOL)BothLists target:(id)Target action:(SEL)Action;
{
//   [_oc autorelease];
//   _oc = [Callback retain];
  target = Target;
  action = Action;
  BOOL c = NO;
  FlxList * itr;
  if (BothLists)
    {
      _oa = B_LIST;
      if (_headA.object != nil)
	{
	  itr = _headA;
	  while (itr != nil)
	    {
	      [_o autorelease];
	      _o = [itr.object retain];
	      if (_o.exists && _o.solid && [self overlapNode])
		c = YES;
	      itr = itr.next;
	    }
	}
      _oa = A_LIST;
      if (_headB.object != nil)
	{
	  itr = _headB;
	  while (itr != nil)
	    {
	      [_o autorelease];
	      _o = [itr.object retain];
	      if (_o.exists && _o.solid)
		{
		  if ((_nw != nil) && [_nw overlapNode])
		    c = YES;
		  if ((_ne != nil) && [_ne overlapNode])
		    c = YES;
		  if ((_se != nil) && [_se overlapNode])
		    c = YES;
		  if ((_sw != nil) && [_sw overlapNode])
		    c = YES;
		}
	      itr = itr.next;
	    }
	}
    }
  else
    {
      if (_headA.object != nil)
	{
	  itr = _headA;
	  while (itr != nil)
	    {
	      [_o autorelease];
	      _o = [itr.object retain];
	      if (_o.exists && _o.solid && [self overlapNode:itr.next])
		c = YES;
	      itr = itr.next;
	    }
	}
    }
  if ((_nw != nil) && [_nw overlapWithParam1:BothLists target:target action:action])
    c = YES;
  if ((_ne != nil) && [_ne overlapWithParam1:BothLists target:target action:action])
    c = YES;
  if ((_se != nil) && [_se overlapWithParam1:BothLists target:target action:action])
    c = YES;
  if ((_sw != nil) && [_sw overlapWithParam1:BothLists target:target action:action])
    c = YES;
  return c;
}
- (BOOL) overlapNode;
{
  return [self overlapNode:nil];
}
- (BOOL) overlapNode:(FlxList *)Iterator;
{
  BOOL c = NO;
  FlxObject * co;
  FlxList * itr = Iterator;
  if (itr == nil)
    {
      if (_oa == A_LIST)
	itr = _headA;
      else
	itr = _headB;
    }
  if (itr.object != nil)
    {
      while (itr != nil)
	{
	  co = itr.object;
	  if ((_o == co) || !co.exists || !_o.exists || !co.solid || !_o.solid || (_o.x + _o.width < co.x + FlxU.roundingError) || (_o.x + FlxU.roundingError > co.x + co.width) || (_o.y + _o.height < co.y + FlxU.roundingError) || (_o.y + FlxU.roundingError > co.y + co.height))
	    {
	      itr = itr.next;
	      continue;
	    }
	  if (target == nil)
	    {
	      [_o kill];
	      [co kill];
	      c = YES;
	    }
	  else
// 	    if ([_oc executeWithObject:_o withObject:co])
	    if ([target performSelector:action
			withObject:_o withObject:co])
	      c = YES;
	  itr = itr.next;
	}
    }
  return c;
}

// begin manually added for 'prettiness'
- (void) addObject:(FlxObject *)Object list:(unsigned int)List; { [self addWithParam1:Object param2:List]; }
//- (BOOL) overlapBothLists:(BOOL)BothLists callback:(FlashFunction *)Callback; { return [self overlapWithParam1:BothLists param2:Callback]; }
- (BOOL) overlapBothLists:(BOOL)BothLists target:(id)Target action:(SEL)Action; { return [self overlapWithParam1:BothLists target:Target action:Action]; }
// end manually added

@end
