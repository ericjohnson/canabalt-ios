//
//  Billboard.m
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

#import "Billboard.h"
#import "RepeatBlock.h"

static NSString * ImgBillboardTopMiddle = @"billboard_top-middle.png";
static NSString * ImgBillboardTopLeft = @"billboard_top-left.png";
static NSString * ImgBillboardTopRight = @"billboard_top-right.png";

static NSString * ImgBillboardMiddleLeft = @"billboard_middle-left.png";
static NSString * ImgBillboardMiddleRight = @"billboard_middle-right.png";

static NSString * ImgBillboardBottomMiddle = @"billboard_bottom-middle.png";
static NSString * ImgBillboardBottomLeft = @"billboard_bottom-left.png";
static NSString * ImgBillboardBottomRight = @"billboard_bottom-right.png";

static NSString * ImgBillboardCatwalkMiddle = @"billboard_catwalk-middle.png";
static NSString * ImgBillboardCatwalkLeft = @"billboard_catwalk-left.png";
static NSString * ImgBillboardCatwalkRight = @"billboard_catwalk-right.png";
//static NSString * ImgBillboardPost = @"billboard_post.png";
static NSString * ImgBillboardPost2 = @"billboard_post2.png";
static NSString * ImgBillboardDmg1 = @"billboard_dmg1-filled.png";
static NSString * ImgBillboardDmg2 = @"billboard_dmg2-filled.png";
static NSString * ImgBillboardDmg3 = @"billboard_dmg3-filled.png";

static const CGFloat TILE_SIZE = 16.0;
static const CGFloat HALL_HEIGHT = 8*16.0*2;

@implementation Billboard

- (id) init
{
  return [self initWithMaxWidth:0];
}

- (id) initWithMaxWidth:(float)maxWidth
{
  if ((self = [super initWithX:0 y:0 width:0 height:0])) {
    post = [[FlxSprite spriteWithX:0 y:0 graphic:nil] retain];
    postTop = [[FlxSprite spriteWithX:0 y:0 graphic:ImgBillboardPost2] retain];
    bottomEdge = [[RepeatBlock repeatBlockWithX:0 y:0 width:0 height:0] retain];
    bottomEdge.width = maxWidth-TILE_SIZE*4;
    bottomEdge.height = TILE_SIZE*2;
    [bottomEdge loadGraphic:ImgBillboardBottomMiddle];
    bottomLeftCorner = [[FlxSprite spriteWithX:0 y:0 graphic:ImgBillboardBottomLeft] retain];
    bottomRightCorner = [[FlxSprite spriteWithX:0 y:0 graphic:ImgBillboardBottomRight] retain];
    center = [[FlxSprite spriteWithX:0 y:0 graphic:nil] retain];
    leftEdge = [[RepeatBlock repeatBlockWithX:0 y:0 width:0 height:0] retain];
    leftEdge.width = TILE_SIZE*2;
    leftEdge.height = HALL_HEIGHT-TILE_SIZE*2;
    [leftEdge loadGraphic:ImgBillboardMiddleLeft];
    rightEdge = [[RepeatBlock repeatBlockWithX:0 y:0 width:0 height:0] retain];
    rightEdge.width = TILE_SIZE*2;
    rightEdge.height = HALL_HEIGHT-TILE_SIZE*2;
    [rightEdge loadGraphic:ImgBillboardMiddleRight];
    topEdge = [[RepeatBlock repeatBlockWithX:0 y:0 width:0 height:0] retain];
    topEdge.width = maxWidth-TILE_SIZE*4;
    topEdge.height = TILE_SIZE*2;
    [topEdge loadGraphic:ImgBillboardTopMiddle];
    topLeftCorner = [[FlxSprite spriteWithX:0 y:0 graphic:ImgBillboardTopLeft] retain];
    topRightCorner = [[FlxSprite spriteWithX:0 y:0 graphic:ImgBillboardTopRight] retain];
    catwalkMiddle = [[RepeatBlock repeatBlockWithX:0 y:0 width:0 height:0] retain];
    catwalkMiddle.width = maxWidth-TILE_SIZE*2;
    catwalkMiddle.height = 13;
    [catwalkMiddle loadGraphic:ImgBillboardCatwalkMiddle];
    catwalkLeft = [[FlxSprite spriteWithX:0 y:0 graphic:ImgBillboardCatwalkLeft] retain];
    catwalkRight = [[FlxSprite spriteWithX:0 y:0 graphic:ImgBillboardCatwalkRight] retain];
    damage = [[FlxSprite spriteWithX:0 y:0 graphic:nil] retain];
  }
  return self;
}

- (void) dealloc
{
  [post release];
  [postTop release];
  [bottomEdge release];
  [topEdge release];
  [leftEdge release];
  [rightEdge release];
  [center release];
  [topRightCorner release];
  [topLeftCorner release];
  [bottomRightCorner release];
  [bottomLeftCorner release];
  [catwalkMiddle release];
  [catwalkLeft release];
  [catwalkRight release];
  [damage release];
  [super dealloc];
}

- (void) createWithX:(float)X y:(float)Y width:(float)Width height:(float)Height tileSize:(float)tileSize hallHeight:(int)hallHeight
{
  self.x = X;
  self.y = Y;
  self.width = Width;
  self.height = Height;
  
  post.x = self.x+self.width/2-tileSize+3;
  post.y = self.y;
  [post createGraphicWithParam1:(tileSize*2)-3*2 param2:self.height param3:0x4d4d59];

  postTop.x = self.x+self.width/2-tileSize;
  postTop.y = self.y+12;

  bottomEdge.x = self.x+tileSize*2;
  bottomEdge.y = self.y-tileSize*2;
  bottomEdge.width = self.width-tileSize*4;
  bottomEdge.height = tileSize*2;
  [bottomEdge loadGraphic:ImgBillboardBottomMiddle];

  bottomLeftCorner.x = self.x+1;
  bottomLeftCorner.y = self.y-tileSize*2;
  bottomRightCorner.x = self.x+self.width-tileSize*2;
  bottomRightCorner.y = self.y-tileSize*2;
    
  center.x = self.x+tileSize*2-1;
  center.y = self.y-hallHeight+tileSize*2;
  [center createGraphicWithParam1:(self.width-tileSize*4)+2 param2:hallHeight-tileSize*4 param3:0x868696];
    
  leftEdge.x = self.x+1;
  leftEdge.y = self.y-hallHeight+tileSize*2;
  leftEdge.width = tileSize*2;
  leftEdge.height = hallHeight-tileSize*4;
  [leftEdge loadGraphic:ImgBillboardMiddleLeft];
  rightEdge.x = self.x+self.width-tileSize*2-1;
  rightEdge.y = self.y-hallHeight+tileSize*2;
  rightEdge.width = tileSize*2;
  rightEdge.height = hallHeight-tileSize*4;
  [rightEdge loadGraphic:ImgBillboardMiddleRight];

  
  topEdge.x = self.x+tileSize*2;
  topEdge.y = self.y-hallHeight;
  topEdge.width = self.width-tileSize*4;
  topEdge.height = tileSize*2;
  [topEdge loadGraphic:ImgBillboardTopMiddle];
  topLeftCorner.x = self.x+1;
  topLeftCorner.y = self.y-hallHeight;
  topRightCorner.x = self.x+self.width-tileSize*2;
  topRightCorner.y = self.y-hallHeight;

  catwalkMiddle.x = self.x+tileSize;
  catwalkMiddle.y = self.y;
  catwalkMiddle.width = self.width-tileSize*2;
  catwalkMiddle.height = 13;
  [catwalkMiddle loadGraphic:ImgBillboardCatwalkMiddle];
  catwalkLeft.x = self.x;
  catwalkLeft.y = self.y;
  catwalkRight.x = self.x+self.width-tileSize;
  catwalkRight.y = self.y;

  //Damage decals
  int padding = 6;
  int third = (self.width-tileSize*4) / 3;
  if ([FlxU random] < 0.5)
    {
      if ([FlxU random] < 0.65) {
        damage.x = self.x+padding+(int)([FlxU random]*third);
	damage.y = self.y+padding-hallHeight+(int)([FlxU random]*(hallHeight-3*tileSize-padding*2));
	[damage loadGraphic:ImgBillboardDmg1];
      }
      if ([FlxU random] < 0.35) {
        damage.x = self.x+third+(int)([FlxU random]*third);
	damage.y = self.y+padding-hallHeight+(int)([FlxU random]*(hallHeight-3*tileSize-padding*2));
	[damage loadGraphic:ImgBillboardDmg2];
      }
      if ([FlxU random] < 0.65) {
        damage.x = self.x-padding+third+third+(int)([FlxU random]*third);
	damage.y = self.y+padding-hallHeight+(int)([FlxU random]*(hallHeight-3*tileSize-padding*2));
	[damage loadGraphic:ImgBillboardDmg3];
      }
    }
  else
    {
      if ([FlxU random] < 0.65) {
        damage.x = self.x+padding+(int)([FlxU random]*third);
	damage.y = self.y+padding-hallHeight+(int)([FlxU random]*(hallHeight-3*tileSize-padding*2));
	[damage loadGraphic:ImgBillboardDmg3];
      }
      if ([FlxU random] < 0.35) {
        damage.x = self.x+third+(int)([FlxU random]*third);
	damage.y = self.y+padding-hallHeight+(int)([FlxU random]*(hallHeight-3*tileSize-padding*2));
	[damage loadGraphic:ImgBillboardDmg2];
      }
      if ([FlxU random] < 0.65) {
	damage.x = self.x-padding+third+third+(int)([FlxU random]*third);
	damage.y = self.y+padding-hallHeight+(int)([FlxU random]*(hallHeight-3*tileSize-padding*2));
	[damage loadGraphic:ImgBillboardDmg1];
      }
    }
    
}


- (void) render
{
  glDisable(GL_BLEND);
  [post render];
  [topEdge render];
  [leftEdge render];
  [rightEdge render];
  [center render];
  [bottomEdge render];
  [bottomLeftCorner render];
  [bottomRightCorner render];
  [damage render];
  [catwalkMiddle render];
  glEnable(GL_BLEND);

  [postTop render];
  [topLeftCorner render];
  [topRightCorner render];
  [catwalkLeft render];
  [catwalkRight render];
}

- (void) update
{
  [super update];
  [post update];
  [postTop update];
  [bottomEdge update];
  [topEdge update];
  [leftEdge update];
  [rightEdge update];
  [center update];
  [topRightCorner update];
  [topLeftCorner update];
  [bottomRightCorner update];
  [bottomLeftCorner update];
  [catwalkMiddle update];
  [catwalkLeft update];
  [catwalkRight update];
  [damage update];
}

@end
