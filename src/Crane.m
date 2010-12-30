//
//  Crane.m
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

#import "Crane.h"

#import "CraneTrigger.h"
#import "CBlock.h"

static const CGFloat tileSize = 16;

static NSString * ImgAntenna5 = @"antenna5-trimmed.png";

static NSString * ImgCrane1 = @"crane1.png"; //beam
static NSString * ImgCrane2 = @"crane2-filled.png"; //post
static NSString * ImgCrane3 = @"crane3.png"; //counterweight
static NSString * ImgCrane4 = @"crane4.png"; //cabin
static NSString * ImgCrane5 = @"crane5.png"; //pulley

@implementation Crane

@synthesize trigger;

- (id) init;
{
  return [self initWithMaxWidth:0];
}

- (id) initWithMaxWidth:(float)maxWidth
{
  if ((self = [super initWithX:0 y:0 width:0 height:0])) {
    beam = [[CBlock alloc] initWithX:0 y:0 width:0 height:0 graphic:nil];
    beam.width = maxWidth;
    beam.height = tileSize*2;
    [beam loadGraphic:ImgCrane1];
    post = [[FlxTileblock alloc] initWithX:0 y:0 width:0 height:0];
    post.width = tileSize*2;
    post.height = 400-tileSize*2;
    [post loadGraphic:ImgCrane2];
    counterweight = [[FlxSprite spriteWithX:0 y:0 graphic:ImgCrane3] retain];
    cabin = [[FlxSprite spriteWithX:0 y:0 graphic:ImgCrane4] retain];
    pulley = [[FlxSprite spriteWithX:0 y:0 graphic:ImgCrane5] retain];
    antenna1 = [[FlxSprite spriteWithX:0 y:0 graphic:ImgAntenna5] retain];
    antenna2 = [[FlxSprite spriteWithX:0 y:0 graphic:ImgAntenna5] retain];
    antenna3 = [[FlxSprite spriteWithX:0 y:0 graphic:ImgAntenna5] retain];
  }
  return self;
}

- (void) dealloc
{
  [trigger release];
  [beam release];
  [post release];
  [counterweight release];
  [cabin release];
  [pulley release];
  [antenna1 release];
  [antenna2 release];
  [antenna3 release];
  [super dealloc];
}

- (void) createWithX:(float)X y:(float)Y width:(float)Width height:(float)Height player:(Player *)player
{
  self.x = X;
  self.y = Y;
  self.width = Width;
  self.height = Height;

  [trigger release];
  trigger = [[CraneTrigger craneTriggerWithFrame:CGRectMake(self.x, self.y-tileSize*2, self.width, tileSize*2) player:player] retain];
    
  BOOL left = [FlxU random] < 0.5;
  int cx = self.width * 0.35;
  
  CGFloat ah = 160;

  beam.x = self.x;
  beam.y = self.y;
  beam.width = self.width;
  beam.height = tileSize*2;
  [beam loadGraphic:ImgCrane1];

  if (left) {
    post.x = self.x+cx;
    post.y = self.y+tileSize*2;
    post.width = tileSize*2;
    post.height = self.height-tileSize*2;
    [post loadGraphic:ImgCrane2];
    counterweight.x = self.x+8;
    counterweight.y = self.y+4;
    cabin.x = self.x+cx-8;
    cabin.y = self.y-9;
    cabin.width = 48;
    cabin.facing = 1;
    pulley.x = self.x+cx+64+[FlxU random]*(self.width-cx-128);
    pulley.y = self.y+20;
    //antennas
    antenna1.x = self.x-8+(40-16)/2;
    antenna1.y = self.y-ah+40;
    antenna2.x = self.x+cx-8+(40-16)/2;
    antenna2.y = self.y-ah+40;
    antenna3.x = self.x+self.width-24+(40-16)/2;
    antenna3.y = self.y-ah+40;
  } else {
    post.x = self.x+self.width-cx-tileSize*2;
    post.y = self.y+tileSize*2;
    post.width = tileSize*2;
    post.height = self.height-tileSize*2;
    [post loadGraphic:ImgCrane2];
    counterweight.x = self.x+self.width-72;
    counterweight.y = self.y+4;
    cabin.x = self.x+self.width-cx-40;
    cabin.y = self.y-9;
    cabin.width = 48;
    cabin.facing = 0;
    pulley.x = self.x+[FlxU random]*(self.width-cx-128);
    pulley.y = self.y+20;
    //antennas
    antenna1.x = self.x-8+(40-16)/2;
    antenna1.y = self.y-ah+40;
    antenna2.x = self.x+self.width-cx-24+(40-16)/2;
    antenna2.y = self.y-ah+40;
    antenna3.x = self.x+self.width-24+(40-16)/2;
    antenna3.y = self.y-ah+40;
  }
}


- (void) render
{
  //turn off blending!
  glDisable(GL_BLEND);
  [post render];
  glEnable(GL_BLEND);
  [beam render];
  [counterweight render];
  [cabin render];
  [pulley render];
  [antenna1 render];
  [antenna2 render];
  [antenna3 render];
}

- (void) update
{
  [post update];
  [beam update];
  [counterweight update];
  [cabin update];
  [pulley update];
  [antenna1 update];
  [antenna2 update];
  [antenna3 update];
}

@end
