//
//  Hall.m
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

#import "Hall.h"

#import "CBlock.h"

static NSString * ImgWall1Left = @"wall1-left.png";
static NSString * ImgWall2Left = @"wall2-left.png";
static NSString * ImgWall3Left = @"wall3-left.png";
static NSString * ImgWall4Left = @"wall4-left.png";
static NSString * ImgWall1Middle = @"wall1-middle.png";
static NSString * ImgWall2Middle = @"wall2-middle.png";
static NSString * ImgWall3Middle = @"wall3-middle.png";
static NSString * ImgWall4Middle = @"wall4-middle.png";
static NSString * ImgWall1Right = @"wall1-right.png";
static NSString * ImgWall2Right = @"wall2-right.png";
static NSString * ImgWall3Right = @"wall3-right.png";
static NSString * ImgWall4Right = @"wall4-right.png";

static NSString * ImgWindow1 = @"window1.png";
static NSString * ImgWindow2 = @"window2.png";
static NSString * ImgWindow3 = @"window3.png";
static NSString * ImgWindow4 = @"window4.png";

static NSString * ImgDoors = @"doors.png";

static NSString * ImgHall1 = @"hall1.png";
static NSString * ImgHall2 = @"hall2.png";

static NSArray * leftWalls;
static NSArray * rightWalls;
static NSArray * middleWalls;

static NSArray * windowImages;

static const CGFloat TILE_SIZE = 16;

@implementation Hall

+ (void) initialize
{
  if (self == [Hall class]) {
    leftWalls = [[NSArray alloc] initWithObjects:ImgWall1Left,
				 ImgWall2Left,
				 ImgWall3Left,
				 ImgWall4Left,
				 nil];
    rightWalls = [[NSArray alloc] initWithObjects:ImgWall1Right,
				  ImgWall2Right,
				  ImgWall3Right,
				  ImgWall4Right,
				  nil];
    middleWalls = [[NSArray alloc] initWithObjects:ImgWall1Middle,
				   ImgWall2Middle,
				   ImgWall3Middle,
				   ImgWall4Middle,
				   nil];

    windowImages = [[NSArray alloc] initWithObjects:ImgWindow1,
				    ImgWindow2,
				    ImgWindow3,
				    ImgWindow4,
				    nil];
  }
}

- (id) init;
{
  return [self initWithMaxWidth:0];
}

- (id) initWithMaxWidth:(float)maxWidth;
{
  if ((self = [super initWithX:0 y:0 width:0 height:0])) {
    leftEdge = [[FlxTileblock tileblockWithX:0 y:0 width:0 height:0] retain];
    leftEdge.width = TILE_SIZE;
    leftEdge.height = 400; //for lack of a better guess
    [leftEdge loadGraphic:[leftWalls lastObject]];
    rightEdge = [[FlxTileblock tileblockWithX:0 y:0 width:0 height:0] retain];
    rightEdge.width = TILE_SIZE;
    rightEdge.height = 400;
    [rightEdge loadGraphic:[rightWalls lastObject]];
    windows = [[NSMutableArray alloc] init];
    walls = [[NSMutableArray alloc] init];
    hall1 = [[CBlock cBlockWithX:0 y:0 width:0 height:0] retain];
    hall1.width = maxWidth;
    hall1.height = TILE_SIZE;
    [hall1 loadGraphic:ImgHall1];
    hall2 = [[CBlock cBlockWithX:0 y:0 width:0 height:0] retain];
    hall2.width = maxWidth;
    hall2.height = TILE_SIZE;
    [hall2 loadGraphic:ImgHall2];
    hall3 = [[FlxSprite spriteWithX:0 y:0 graphic:nil] retain];
    doors = [[NSMutableArray alloc] init];
    extraWindows = [[NSMutableArray alloc] init];
    extraWalls = [[NSMutableArray alloc] init];
    extraDoors = [[NSMutableArray alloc] init];

    int n = ((400)/TILE_SIZE)/2;
    for (int i = 0; i < n; ++i) {
      FlxTileblock * wall = [FlxTileblock tileblockWithX:0 y:0 width:0 height:0];
      wall.width = maxWidth-2*TILE_SIZE;
      wall.height = TILE_SIZE;
      [wall loadGraphic:[middleWalls lastObject]];
      [extraWalls addObject:wall];
    }
    for (int i = 0; i < n; ++i) {
      FlxTileblock * window = [FlxTileblock tileblockWithX:0 y:0 width:0 height:0];
      window.width = maxWidth-2*TILE_SIZE;
      window.height = TILE_SIZE;
      [window loadGraphic:[windowImages lastObject]];
      [extraWindows addObject:window];
    }
  }
  return self;
}

- (void) dealloc
{
  [leftEdge release];
  [rightEdge release];
  [windows release];
  [walls release];
  [hall1 release];
  [hall2 release];
  [hall3 release];
  [doors release];
  [extraWindows release];
  [extraWalls release];
  [extraDoors release];
  [super dealloc];
}

- (void) createWithX:(float)X y:(float)Y width:(float)Width height:(float)Height
	    tileSize:(float)tileSize
	  hallHeight:(float)hallHeight
	    wallType:(int)wallType windowType:(int)windowType
{
  self.x = X;
  self.y = Y;
  self.width = Width;
  self.height = Height;

  leftEdge.x = self.x;
  leftEdge.y = 0;
  leftEdge.width = tileSize;
  leftEdge.height = self.y-hallHeight;
  [leftEdge loadGraphic:[leftWalls objectAtIndex:wallType]];

  rightEdge.x = self.x+self.width-tileSize;
  rightEdge.y = 0;
  rightEdge.width = tileSize;
  rightEdge.height = self.y-hallHeight;
  [rightEdge loadGraphic:[rightWalls objectAtIndex:wallType]];

  int n = ((self.y-hallHeight)/tileSize)/2;

  if ([walls count] < n) {
    while ([extraWalls count] > 0 && [walls count] < n) {
      [walls addObject:[extraWalls lastObject]];
      [extraWalls removeLastObject];
    }
    while ([walls count] < n)
      [walls addObject:[FlxTileblock tileblockWithX:0 y:0 width:0 height:0]];
  } else {
    while ([walls count] > n) {
      [extraWalls addObject:[walls lastObject]];
      [walls removeLastObject];
    }
  }
  for (int i = 0; i < n; ++i) {
    FlxTileblock * wall = [walls objectAtIndex:i];
    wall.x = self.x+tileSize;
    wall.y = (self.y-hallHeight)-(1+i*2)*tileSize;
    wall.width = self.width-2*tileSize;
    wall.height = tileSize;
    [wall loadGraphic:[middleWalls objectAtIndex:wallType]];
  }

  if ([windows count] < n) {
    while ([extraWindows count] > 0 && [windows count] < n) {
      [windows addObject:[extraWindows lastObject]];
      [extraWindows removeLastObject];
    }
    while ([windows count] < n)
      [windows addObject:[FlxTileblock tileblockWithX:0 y:0 width:0 height:0]];
  } else {
    while ([windows count] > n) {
      [extraWindows addObject:[windows lastObject]];
      [windows removeLastObject];
    }
  }
  for (int i = 0; i < n; ++i) {
    FlxTileblock * window = [windows objectAtIndex:i];
    window.x = self.x+tileSize;
    window.y = (self.y-hallHeight)-(2+i*2)*tileSize;
    window.width = self.width-2*tileSize;
    window.height = tileSize;
    [window loadGraphic:[windowImages objectAtIndex:windowType]];
  }
      
  hall1.x = self.x;
  hall1.y = self.y-tileSize;
  hall1.width = self.width;
  hall1.height = tileSize;
  [hall1 loadGraphic:ImgHall1];
  hall2.x = self.x;
  hall2.y = self.y-2*tileSize;
  hall2.width = self.width;
  hall2.height = tileSize;
  [hall2 loadGraphic:ImgHall2];

  hall3.x = self.x;
  hall3.y = self.y-hallHeight;
  [hall3 createGraphicWithWidth:self.width height:hallHeight-2*tileSize color:0xff35353d];

  n = (self.width/tileSize-3)/4;
  int doorIndex = 0;
  for (int i = 1; i < n; ++i) {
    if ([FlxU random] >  0.65) continue;
    while ([doors count] <= doorIndex) {
      while ([doors count] <= doorIndex && [extraDoors count] > 0) {
	[doors addObject:[extraDoors lastObject]];
	[extraDoors removeLastObject];
      }
      while ([doors count] <= doorIndex)
	[doors addObject:[FlxSprite spriteWithGraphic:nil]];
    }
    FlxSprite * door = [doors objectAtIndex:doorIndex];
    [door loadGraphicWithParam1:ImgDoors param2:YES param3:NO param4:15 param5:24];
    door.x = self.x+i*tileSize*4-tileSize;
    door.y = self.y-24;
    door.width = 15;
    [door randomFrame];
    doorIndex++;
  }
  while ([doors count] > doorIndex) {
    [extraDoors addObject:[doors lastObject]];
    [doors removeLastObject];
  }
}


- (void) render
{
  [leftEdge render];
  [rightEdge render];
  glDisable(GL_BLEND);
  for (FlxTileblock * window in windows)
    [window render];
  for (FlxTileblock * wall in walls)
    [wall render];
  [hall1 render];
  [hall2 render];
  [hall3 render];
  for (FlxSprite * door in doors)
    [door render];
  glEnable(GL_BLEND);
}

- (void) update
{
  [leftEdge update];
  [rightEdge update];
  for (FlxTileblock * window in windows)
    [window update];
  for (FlxTileblock * wall in walls)
    [wall update];
  [hall1 update];
  [hall2 update];
  [hall3 update];
  for (FlxSprite * door in doors)
    [door update];
}

@end
