//
//  Building.m
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

#import "Building.h"

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


static NSString * ImgRoof1Left = @"roof1-left.png";
static NSString * ImgRoof2Left = @"roof2-left.png";
static NSString * ImgRoof3Left = @"roof3-left.png";
static NSString * ImgRoof4Left = @"roof4-left.png";
static NSString * ImgRoof5Left = @"roof6-left.png";
static NSString * ImgRoof6Left = @"roof5-left.png";
static NSString * ImgRoof1Middle = @"roof1-middle.png";
static NSString * ImgRoof2Middle = @"roof2-middle.png";
static NSString * ImgRoof3Middle = @"roof3-middle.png";
static NSString * ImgRoof4Middle = @"roof4-middle.png";
static NSString * ImgRoof5Middle = @"roof6-middle.png";
static NSString * ImgRoof6Middle = @"roof5-middle.png";
static NSString * ImgRoof1Right = @"roof1-right.png";
static NSString * ImgRoof2Right = @"roof2-right.png";
static NSString * ImgRoof3Right = @"roof3-right.png";
static NSString * ImgRoof4Right = @"roof4-right.png";
static NSString * ImgRoof5Right = @"roof6-right.png";
static NSString * ImgRoof6Right = @"roof5-right.png";

static NSString * ImgWall1LeftCracked = @"wall1-left-cracked.png";
static NSString * ImgWall2LeftCracked = @"wall2-left-cracked.png";
static NSString * ImgWall3LeftCracked = @"wall3-left-cracked.png";
static NSString * ImgWall4LeftCracked = @"wall4-left-cracked.png";
static NSString * ImgWall1MiddleCracked = @"wall1-middle-cracked.png";
static NSString * ImgWall2MiddleCracked = @"wall2-middle-cracked.png";
static NSString * ImgWall3MiddleCracked = @"wall3-middle-cracked.png";
static NSString * ImgWall4MiddleCracked = @"wall4-middle-cracked.png";
static NSString * ImgWall1RightCracked = @"wall1-right-cracked.png";
static NSString * ImgWall2RightCracked = @"wall2-right-cracked.png";
static NSString * ImgWall3RightCracked = @"wall3-right-cracked.png";
static NSString * ImgWall4RightCracked = @"wall4-right-cracked.png";

static NSString * ImgRoof1LeftCracked = @"roof1-left-cracked.png";
static NSString * ImgRoof2LeftCracked = @"roof2-left-cracked.png";
static NSString * ImgRoof3LeftCracked = @"roof3-left-cracked.png";
static NSString * ImgRoof4LeftCracked = @"roof4-left-cracked.png";
static NSString * ImgRoof5LeftCracked = @"roof6-left-cracked.png";
static NSString * ImgRoof6LeftCracked = @"roof5-left-cracked.png";
static NSString * ImgRoof1MiddleCracked = @"roof1-middle-cracked.png";
static NSString * ImgRoof2MiddleCracked = @"roof2-middle-cracked.png";
static NSString * ImgRoof3MiddleCracked = @"roof3-middle-cracked.png";
static NSString * ImgRoof4MiddleCracked = @"roof4-middle-cracked.png";
static NSString * ImgRoof5MiddleCracked = @"roof6-middle-cracked.png";
static NSString * ImgRoof6MiddleCracked = @"roof5-middle-cracked.png";
static NSString * ImgRoof1RightCracked = @"roof1-right-cracked.png";
static NSString * ImgRoof2RightCracked = @"roof2-right-cracked.png";
static NSString * ImgRoof3RightCracked = @"roof3-right-cracked.png";
static NSString * ImgRoof4RightCracked = @"roof4-right-cracked.png";
static NSString * ImgRoof5RightCracked = @"roof6-right-cracked.png";
static NSString * ImgRoof6RightCracked = @"roof5-right-cracked.png";


static NSString * ImgFloor1Left = @"floor1-left.png";
static NSString * ImgFloor2Left = @"floor2-left.png";
static NSString * ImgFloor1Middle = @"floor1-middle.png";
static NSString * ImgFloor2Middle = @"floor2-middle.png";
static NSString * ImgFloor1Right = @"floor1-right.png";
static NSString * ImgFloor2Right = @"floor2-right.png";


static NSString * ImgWindow1 = @"window1.png";
static NSString * ImgWindow2 = @"window2.png";
static NSString * ImgWindow3 = @"window3.png";
static NSString * ImgWindow4 = @"window4.png";

static NSArray * leftWalls;
static NSArray * rightWalls;
static NSArray * middleWalls;
static NSArray * leftWallsCracked;
static NSArray * rightWallsCracked;
static NSArray * middleWallsCracked;


static NSArray * leftFloors;
static NSArray * middleFloors;
static NSArray * rightFloors;

static NSArray * leftRoofs;
static NSArray * middleRoofs;
static NSArray * rightRoofs;

static NSArray * leftRoofsCracked;
static NSArray * middleRoofsCracked;
static NSArray * rightRoofsCracked;

static NSArray * windowImages;

enum {
  ROOF,
  HALLWAY,
  COLLAPSE,
  BOMB,
  CRANE,
  BILLBOARD,
  LEG
};

const static float TILE_SIZE = 16.0;

@implementation Building

+ (void) initialize
{
  if (self == [Building class]) {
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
    leftWallsCracked = [[NSArray alloc] initWithObjects:ImgWall1LeftCracked,
					ImgWall2LeftCracked,
					ImgWall3LeftCracked,
					ImgWall4LeftCracked,
					nil];
    rightWallsCracked = [[NSArray alloc] initWithObjects:ImgWall1RightCracked,
					 ImgWall2RightCracked,
					 ImgWall3RightCracked,
					 ImgWall4RightCracked,
					 nil];
    middleWallsCracked = [[NSArray alloc] initWithObjects:ImgWall1MiddleCracked,
					  ImgWall2MiddleCracked,
					  ImgWall3MiddleCracked,
					  ImgWall4MiddleCracked,
					  nil];

    leftFloors = [[NSArray alloc] initWithObjects:ImgFloor1Left,
				    ImgFloor2Left,
				    nil];
    middleFloors = [[NSArray alloc] initWithObjects:ImgFloor1Middle,
				    ImgFloor2Middle,
				    nil];
    rightFloors = [[NSArray alloc] initWithObjects:ImgFloor1Right,
				    ImgFloor2Right,
				    nil];

    leftRoofs = [[NSArray alloc] initWithObjects:ImgRoof1Left,
				   ImgRoof2Left,
				   ImgRoof3Left,
				   ImgRoof4Left,
				   ImgRoof5Left,
				   ImgRoof6Left,
				   nil];
    middleRoofs = [[NSArray alloc] initWithObjects:ImgRoof1Middle,
				   ImgRoof2Middle,
				   ImgRoof3Middle,
				   ImgRoof4Middle,
				   ImgRoof5Middle,
				   ImgRoof6Middle,
				   nil];
    rightRoofs = [[NSArray alloc] initWithObjects:ImgRoof1Right,
				   ImgRoof2Right,
				   ImgRoof3Right,
				   ImgRoof4Right,
				   ImgRoof5Right,
				   ImgRoof6Right,
				   nil];

    leftRoofsCracked = [[NSArray alloc] initWithObjects:ImgRoof1LeftCracked,
				   ImgRoof2LeftCracked,
				   ImgRoof3LeftCracked,
				   ImgRoof4LeftCracked,
				   ImgRoof5LeftCracked,
				   ImgRoof6LeftCracked,
				   nil];
    middleRoofsCracked = [[NSArray alloc] initWithObjects:ImgRoof1MiddleCracked,
				   ImgRoof2MiddleCracked,
				   ImgRoof3MiddleCracked,
				   ImgRoof4MiddleCracked,
				   ImgRoof5MiddleCracked,
				   ImgRoof6MiddleCracked,
				   nil];
    rightRoofsCracked = [[NSArray alloc] initWithObjects:ImgRoof1RightCracked,
				   ImgRoof2RightCracked,
				   ImgRoof3RightCracked,
				   ImgRoof4RightCracked,
				   ImgRoof5RightCracked,
				   ImgRoof6RightCracked,
				   nil];

    windowImages = [[NSArray alloc] initWithObjects:ImgWindow1,
				    ImgWindow2,
				    ImgWindow3,
				    ImgWindow4,
				    nil];
  }
}

- (id) init
{
  return [self initWithMaxWidth:0];
}

- (id) initWithMaxWidth:(float)maxWidth
{
  if ((self = [super initWithX:0 y:0 width:0 height:0])) {
    leftEdge = [[FlxTileblock tileblockWithX:0 y:0 width:0 height:0] retain];
    leftEdge.width = TILE_SIZE;
    leftEdge.height = 400-TILE_SIZE;
    [leftEdge loadGraphic:[leftWalls lastObject]];
    rightEdge = [[FlxTileblock tileblockWithX:0 y:0 width:0 height:0] retain];
    rightEdge.width = TILE_SIZE;
    rightEdge.height = 400-TILE_SIZE;
    [rightEdge loadGraphic:[rightWalls lastObject]];
    topEdge = [[FlxTileblock tileblockWithX:0 y:0 width:0 height:0] retain];
    topEdge.width = maxWidth-TILE_SIZE*2;
    topEdge.height = TILE_SIZE;
    [topEdge loadGraphic:[middleRoofs lastObject]];
    leftCorner = [[FlxSprite spriteWithX:0 y:0 graphic:nil] retain];
    rightCorner = [[FlxSprite spriteWithX:0 y:0 graphic:nil] retain];
    windows = [[NSMutableArray alloc] init];
    walls = [[NSMutableArray alloc] init];
    //prepopulate these.. need to know max height...
    //assume for now height of 400...
    extraWindows = [[NSMutableArray alloc] init];
    extraWalls = [[NSMutableArray alloc] init];
    int n = (400/TILE_SIZE-1)/2;
    for (int i=0; i<n+1; ++i) {
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
  [topEdge release];
  [leftCorner release];
  [rightCorner release];
  [windows release];
  [walls release];
  [extraWindows release];
  [extraWalls release];
  [super dealloc];
}


- (void) createWithX:(float)X y:(float)Y width:(float)Width height:(float)Height
	tileSize:(float)tileSize
    buildingType:(int)buildingType wallType:(int)wallType windowType:(int)windowType
{
  self.x = X;
  self.y = Y;
  self.width = Width;
  self.height = Height;

  velocity.y = 0;
  acceleration.y = 0;
  
  leftEdge.x = self.x;
  leftEdge.y = self.y+tileSize;
  leftEdge.width = tileSize;
  leftEdge.height = self.height-tileSize;
  if (buildingType == COLLAPSE)
    [leftEdge loadGraphic:[leftWallsCracked objectAtIndex:wallType]];
  else
    [leftEdge loadGraphic:[leftWalls objectAtIndex:wallType]];

  rightEdge.x = self.x+self.width-tileSize;
  rightEdge.y = self.y+tileSize;
  rightEdge.width = tileSize;
  rightEdge.height = self.height-tileSize;
  if (buildingType == COLLAPSE)
    [rightEdge loadGraphic:[rightWallsCracked objectAtIndex:wallType]];
  else
    [rightEdge loadGraphic:[rightWalls objectAtIndex:wallType]];
	
  topEdge.x = self.x+tileSize;
  topEdge.y = self.y;
  topEdge.width = self.width-tileSize*2;
  topEdge.height = tileSize;
      
  leftCorner.x = self.x;
  leftCorner.y = self.y;
  rightCorner.x = self.x+self.width-tileSize;
  rightCorner.y = self.y;
      
  if (buildingType == HALLWAY) {
    int floorIndex = [middleFloors count]*[FlxU random];
    [topEdge loadGraphic:[middleFloors objectAtIndex:floorIndex]];
    [leftCorner loadGraphic:[leftFloors objectAtIndex:floorIndex]];
    leftCorner.frame = 0;
    [rightCorner loadGraphic:[rightFloors objectAtIndex:floorIndex]];
    rightCorner.frame = 0;
  } else {
    int roofIndex = [middleRoofs count]*[FlxU random];
    if (buildingType == COLLAPSE) {
      [topEdge loadGraphic:[middleRoofsCracked objectAtIndex:roofIndex]];
      [leftCorner loadGraphicWithParam1:[leftRoofsCracked objectAtIndex:roofIndex] param2:YES];
      leftCorner.frame = [FlxU random]*[leftRoofsCracked count];
      [rightCorner loadGraphicWithParam1:[rightRoofsCracked objectAtIndex:roofIndex] param2:YES];
      rightCorner.frame = [FlxU random]*[rightRoofsCracked count];
    } else {
      [topEdge loadGraphic:[middleRoofs objectAtIndex:roofIndex]];
      [leftCorner loadGraphic:[leftRoofs objectAtIndex:roofIndex]];
      leftCorner.frame = 0;
      [rightCorner loadGraphic:[rightRoofs objectAtIndex:roofIndex]];
      rightCorner.frame = 0;
    }
  }
      
  int n = (self.height/tileSize-1)/2;

  if ([walls count] < n+1) {
    while ([extraWalls count] > 0 && [walls count] < n+1) {
      [walls addObject:[extraWalls lastObject]];
      [extraWalls removeLastObject];
    }
    while ([walls count] < n+1)
      [walls addObject:[FlxTileblock tileblockWithX:0 y:0 width:0 height:0]];
  } else {
    while ([walls count] > n+1) {
      [extraWalls addObject:[walls lastObject]];
      [walls removeLastObject];
    }
  }
      
  if (buildingType == COLLAPSE)
    for (int i=0; i<n+1; ++i) {
      FlxTileblock * wall = [walls objectAtIndex:i];
      wall.x = self.x+tileSize;
      wall.y = self.y + (1+i*2)*tileSize;
      wall.width = self.width-2*tileSize;
      wall.height = tileSize;
      [wall loadGraphic:[middleWallsCracked objectAtIndex:wallType]];
    }
  else
    for (int i=0; i<n+1; ++i) {
      FlxTileblock * wall = [walls objectAtIndex:i];
      wall.x = self.x+tileSize;
      wall.y = self.y + (1+i*2)*tileSize;
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
    window.y = self.y+(2+i*2)*tileSize;
    window.width = self.width-2*tileSize;
    window.height = tileSize;
    [window loadGraphic:[windowImages objectAtIndex:windowType]];
  }
    
}


- (void) render
{
  [leftCorner render];
  [rightCorner render];
  [leftEdge render];
  [rightEdge render];
  glDisable(GL_BLEND);
  [topEdge render];
  for (FlxTileblock * window in windows)
    [window render];
  for (FlxTileblock * wall in walls)
    [wall render];
  glEnable(GL_BLEND);
}

- (void) update
{
  //treat this like it's a group
  float oldx = self.x;
  float oldy = self.y;
  float mx = 0;
  float my = 0;
  [super update];
  BOOL moved = NO;
  if (self.x != oldx || self.y != oldy) {
    moved = YES;
    mx = self.x-oldx;
    my = self.y-oldy;
  }
  if (moved) {
    leftEdge.x += mx;
    leftEdge.y += my;
    rightEdge.x += mx;
    rightEdge.y += my;
    topEdge.x += mx;
    topEdge.y += my;
    leftCorner.x += mx;
    leftCorner.y += my;
    rightCorner.x += mx;
    rightCorner.y += my;
    for (FlxTileblock * window in windows) {
      window.x += mx;
      window.y += my;
    }
    for (FlxTileblock * wall in walls) {
      wall.x += mx;
      wall.y += my;
    }
  }
  [leftEdge update];
  [rightEdge update];
  [topEdge update];
  [leftCorner update];
  [rightCorner update];
  for (FlxTileblock * window in windows)
    [window update];
  for (FlxTileblock * wall in walls)
    [wall update];
}

@end
