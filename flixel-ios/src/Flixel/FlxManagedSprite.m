//
//  FlxManagedSprite.m
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


typedef struct ManagedEntry ManagedEntry;
struct ManagedEntry
{
  FlxManagedSprite * managedSprite;
  ManagedEntry * next;
  ManagedEntry * prev;
};

typedef struct ManagedSpriteInfo ManagedSpriteInfo;
struct ManagedSpriteInfo
{
  ManagedEntry * free;
  ManagedEntry * used;
  unsigned int count;
};

@interface FlxSprite ()
- (void) setupUVs;
- (void) setupVertices;
- (void) setupTexCoords;
@end

@interface FlxManagedSprite (Managed)
+ (id) managedAlloc;
- (id) managedInit;
- (void) managedDealloc;
- (void) reInitWithX:(float)X y:(float)Y graphic:(NSString *)SimpleGraphic modelScale:(float)ModelScale;
//- (void) trueInitWithX:(float)X y:(float)Y graphic:(NSString *)SimpleGraphic modelScale:(float)ModelScale;
@end

static NSMutableDictionary * managedSpriteInfoDictionary = nil;

@implementation FlxManagedSprite

+ (void) initialize
{
  if (self == [FlxManagedSprite class]) {
    if (managedSpriteInfoDictionary == nil)
      managedSpriteInfoDictionary = [[NSMutableDictionary alloc] init];
  }
}


+ (void) initializeWithManagedPoolSize:(unsigned int)size;
{
  //must be at least one entry...
  if (size == 0)
    size = 1;
  NSValue * info = [managedSpriteInfoDictionary objectForKey:[self class]];
  if (info != nil)
    return;

  ManagedSpriteInfo * managedSpriteInfo = malloc(sizeof(ManagedSpriteInfo));
  info = [NSValue valueWithPointer:(const void *)managedSpriteInfo];
  [managedSpriteInfoDictionary setObject:info forKey:[self class]];

  if ([self class] == [FlxManagedSprite class]) {
    if (FlxG.iPad)
      size = 256;
    else
      size = 64;
  }
  
  ManagedEntry * freeEntries = malloc(size*sizeof(ManagedEntry));

  for (unsigned int i=0; i<size; ++i) {
    if (i == size-1)
      freeEntries[i].next = NULL;
    else
      freeEntries[i].next = &freeEntries[i+1];
    freeEntries[i].managedSprite = [[self managedAlloc] managedInit];
    freeEntries[i].managedSprite->managedEntry = &freeEntries[i];
  }

  managedSpriteInfo->count = size;
  managedSpriteInfo->free = freeEntries;
  managedSpriteInfo->used = NULL;
}

+ (void) increaseManagedPoolSize:(ManagedSpriteInfo *)managedSpriteInfo
{
  ManagedEntry * freeEntries = malloc(managedSpriteInfo->count*sizeof(ManagedEntry));
  for (int i=0; i<managedSpriteInfo->count; ++i) {
    if (i == managedSpriteInfo->count-1)
      freeEntries[i].next = NULL;
    else
      freeEntries[i].next = &freeEntries[i+1];
    freeEntries[i].managedSprite = [[self managedAlloc] managedInit];
    freeEntries[i].managedSprite->managedEntry = &freeEntries[i];
  }
  managedSpriteInfo->free = freeEntries;
  managedSpriteInfo->count = managedSpriteInfo->count * 2;
  fprintf(stderr, "\n\n\n\n*****************************\n\n");
  NSLog(@"FlxManagedSprite : increasing managed pool size to: %d : %@", managedSpriteInfo->count, [self class]);
  fprintf(stderr, "\n\n*****************************\n\n\n\n");
}

+ (FlxManagedSprite *) popFreeEntry
{
  NSValue * info = [managedSpriteInfoDictionary objectForKey:[self class]];
  if (info == nil) {
    //todo: better default than 16?
    [self initializeWithManagedPoolSize:16];
    info = [managedSpriteInfoDictionary objectForKey:[self class]];
    if (info == nil) {
      NSLog(@"FlxManagedSprite - popFreeEntry - could not initialized managed pool : %@", [self class]);
      return nil;
    }
  }
  ManagedSpriteInfo * managedSpriteInfo = (ManagedSpriteInfo *)[info pointerValue];
  if (managedSpriteInfo->free == NULL)
    [self increaseManagedPoolSize:managedSpriteInfo];

  ManagedEntry * nextFree = managedSpriteInfo->free;
  FlxManagedSprite * ret = nextFree->managedSprite;

  managedSpriteInfo->free = nextFree->next;

  nextFree->next = managedSpriteInfo->used;
  if (managedSpriteInfo->used)
    managedSpriteInfo->used->prev = nextFree;
  managedSpriteInfo->used = nextFree;
  nextFree->prev = NULL;

  //check retain count
  if (ret->managedRetainCount != 0) {
    NSLog(@"we've got problems with retain count: %@", [self class]);
  }

//   NSLog(@"allocating object of type: %@, %x", [self class], ret);
  
  return ret;
}

+ (void) pushUsedEntry:(FlxManagedSprite *)done
{
  //check retain count
  if (done->managedRetainCount != 0) {
    NSLog(@"we've got problems with retain count: %@", [self class]);
  }

//   NSLog(@"freeing object of type: %@, %x", [self class], done);
  
  NSValue * info = [managedSpriteInfoDictionary objectForKey:[self class]];
  if (info == nil) {
    NSLog(@"FlxManagedSprite - pushFreeEntry - something is fishy : %@", [self class]);
      return;
  }
  ManagedSpriteInfo * managedSpriteInfo = (ManagedSpriteInfo *)[info pointerValue];
  ManagedEntry * old = done->managedEntry;
  ManagedEntry * n = old->next;
  ManagedEntry * p = old->prev;
  if (n)
    n->prev = p;
  if (p)
    p->next = n;
  else
    managedSpriteInfo->used = n;
  old->prev = NULL;
  old->next = managedSpriteInfo->free;
  managedSpriteInfo->free = old;
}

+ (id) managedAlloc
{
  return [self allocWithZone:NULL];
}

- (id) managedInit
{
  //todo: fill in the details here...
  //id tmp = [super initWithX:0 y:0 width:0 height:0];
  id tmp = [super initWithX:0 y:0 graphic:nil modelScale:1.0];
  if (tmp == nil)
    return nil;
  if (tmp != self) {
    NSLog(@"unexpected behavior in FlxManagedSprite: %@", [self class]);
  }
  //need to initialize offset and scale
  offset = CGPointZero;
  scale = CGPointMake(1,1);
  //also, animations
  _animations = [[NSMutableArray alloc] init];
  return self;
}

- (void) managedDealloc
{
  //release anything?
  [_callback release];
  _callback = nil;
  [_curAnim release];
  _curAnim = nil;
  [texture release];
  texture = nil;
  //_animations
  [_animations removeAllObjects];
  //offset, scale, blend
  offset.x = 0;
  offset.y = 0;
  scale.x = 1;
  scale.y = 1;
  [blend release];
  blend = nil;
}

+ (id) alloc
{
//   fprintf(stderr, "\n\n*************************\n\n");
//   NSLog(@"FlxManagedSprite alloc: %@", [self class]);
//   fprintf(stderr, "\n\n*************************\n\n");
  return [[self popFreeEntry] retain];
}

- (id) retain
{
  managedRetainCount++;
  return self;
}

- (oneway void) release
{
  if (managedRetainCount == 0) {
    fprintf(stderr, "\n\n**************************************\n**************************************\n\n");
    NSLog(@"this object is being released too many times!! - %@", [self class]);
    fprintf(stderr, "\n\n**************************************\n**************************************\n\n");
  }
  managedRetainCount--;
  if (managedRetainCount == 0) {
    [self dealloc];
    [self managedDealloc];
    [[self class] pushUsedEntry:self];
  }
}

- (void) dealloc
{
//   fprintf(stderr, "\n\n*************************\n\n");
//   NSLog(@"FlxManagedSprite dealloc: %@", [self class]);
//   fprintf(stderr, "\n\n*************************\n\n");
  //do not call [super dealloc] -> how to avoid warning?
	return;
	[super dealloc];
}

- (id) initWithX:(float)X y:(float)Y graphic:(NSString *)SimpleGraphic modelScale:(float)ModelScale
{
  [self reInitWithX:X y:Y graphic:SimpleGraphic modelScale:ModelScale];
  return self;
}

- (void) reInitWithX:(float)X y:(float)Y graphic:(NSString *)SimpleGraphic modelScale:(float)ModelScale
{

  //need to reinit FlxObject stuff, also FlxRect and FlxSprite
  
  //FlxObject begin
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
  origin.x = 0; origin.y = 0;
  velocity.x = 0; velocity.y = 0;
  acceleration.x = 0; acceleration.y = 0;
  drag.x = 0; drag.y = 0;
  maxVelocity.x = 10000; maxVelocity.y = 10000;
  angle = 0;
  angularVelocity = 0;
  angularAcceleration = 0;
  angularDrag = 0;
  maxAngular = 10000;
  thrust = 0;
  scrollFactor.x = 1; scrollFactor.y = 1;
  _flicker = NO;
  _flickerTimer = -1;
  health = 1;
  dead = NO;
  colHullX.origin.x = 0; colHullX.origin.y = 0; colHullX.size.width = 0; colHullX.size.height = 0;
  colHullY.origin.x = 0; colHullY.origin.y = 0; colHullY.size.width = 0; colHullY.size.height = 0;
  colVector.x = 0; colVector.y = 0;
  [colOffsets release];
  colOffsets = [[NSMutableArray arrayWithObject:[NSValue valueWithCGPoint:CGPointZero]] retain];
  _group = NO;
  //FlxObject end
  
  x = X;
  y = Y;
  width = 0;
  height = 0;

  red = 255;
  green = 255;
  blue = 255;
  for (int i=0; i<4*4; ++i)
    _colors[i] = 255;
  filled = NO;

  x = X;
  y = Y;
  predictedX = x;
  predictedY = y;

  modelScale = ModelScale;
  
  if (SimpleGraphic == nil)
    [self createGraphicWithParam1:8 param2:8];
  else
    [self loadGraphic:SimpleGraphic modelScale:modelScale];

  offset.x = 0;
  offset.y = 0;
  scale.x = 1;
  scale.y = 1;

  _alpha = 1;
  _color = 0x00ffffff;
  blend = nil;
  antialiasing = NO;
  finished = NO;
  _facing = RIGHT;
  [_animations removeAllObjects];
  _flipped = 0;
  _curAnim = nil;
  _curFrame = 0;
  _caf = 0;
  _frameTimer = 0;
  _callback = nil;
  //[self setupUVs];
  [self setupVertices];
  [self setupTexCoords];

}


@end
