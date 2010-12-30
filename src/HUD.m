//
//  HUD.m
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

#import "HUD.h"

static int hudWidths[11];
static int hudOffsets[11];

static SemiSecretTexture * hudTexture = nil;

@interface HUD (Private)
- (void) updateCoordinates;
@end

@implementation HUD

@synthesize distance;

+ (void) initialize
{
  if (self == [HUD class]) {
    hudTexture = [[FlxG addTextureWithParam1:@"hud.png" param2:NO] retain]; //   [[FlxTexture textureWithImage:@"hud.png"] retain];
    hudWidths[0] = 12;
    hudWidths[1] = 8;
    hudWidths[2] = 12;
    hudWidths[3] = 12;
    hudWidths[4] = 12;
    hudWidths[5] = 12;
    hudWidths[6] = 12;
    hudWidths[7] = 12;
    hudWidths[8] = 12;
    hudWidths[9] = 12;
    hudWidths[10] = 18;
    hudOffsets[0] = 0;
    for (int i = 1; i < 11; ++i)
      hudOffsets[i] = hudOffsets[i-1]+hudWidths[i-1];
  }
}

+ (id) hudWithFrame:(CGRect)f
{
  return [[[self alloc] initWithFrame:f] autorelease];
}

- (id) initWithFrame:(CGRect)f
{
  if (([super initWithX:0 y:0 graphic:nil])) {
    self.x = f.origin.x;
    self.y = f.origin.y;
    self.width = f.size.width;
    self.height = f.size.height;
  }
  return self;
}


- (void) setDistance:(NSUInteger)newDistance
{
  if (distance == newDistance)
    return;
  distance = newDistance;
  //recompute uvs, vertices
  [self updateCoordinates];
}

- (void) updateCoordinates
{
  static int digitWidths[DIGITS+1] = {0};
  static int digits[DIGITS] = {0};
  int tmpDistance = distance;
  int totalWidth = 0;

  for (int i = 0; i < DIGITS; ++i) {
    digitWidths[(DIGITS-1-i)] = hudWidths[(tmpDistance%10)];
    digits[i] = tmpDistance%10;
    tmpDistance = tmpDistance/10;
    totalWidth += digitWidths[DIGITS-1-i];
  }
  digitWidths[DIGITS] = hudWidths[10]; //m
  totalWidth += digitWidths[DIGITS];

  //fill in the vertices, starting from the right
  //first 'm'
  int runningWidth = digitWidths[DIGITS];

  hudVerticesUVs[VERTEX_COUNT*4-4] = (GLshort)(width);
  hudVerticesUVs[VERTEX_COUNT*4-3] = (GLshort)(height);
  hudVerticesUVs[VERTEX_COUNT*4-8] = (GLshort)(width);
  hudVerticesUVs[VERTEX_COUNT*4-7] = 0;
  hudVerticesUVs[VERTEX_COUNT*4-12] = (GLshort)(width-runningWidth);
  hudVerticesUVs[VERTEX_COUNT*4-11] = (GLshort)(height);
  hudVerticesUVs[VERTEX_COUNT*4-16] = (GLshort)(width-runningWidth);
  hudVerticesUVs[VERTEX_COUNT*4-15] = 0;

  hudVerticesUVs[VERTEX_COUNT*4-2] = [FlxGLView convertToShort:(hudTexture.size.width/hudTexture.paddedSize.width)]; //this one is a given
  hudVerticesUVs[VERTEX_COUNT*4-1] = [FlxGLView convertToShort:(hudTexture.size.height/hudTexture.paddedSize.height)];
  hudVerticesUVs[VERTEX_COUNT*4-6] = [FlxGLView convertToShort:(hudTexture.size.width/hudTexture.paddedSize.width)]; //given
  hudVerticesUVs[VERTEX_COUNT*4-5] = [FlxGLView convertToShort:(0)];
  hudVerticesUVs[VERTEX_COUNT*4-10] = [FlxGLView convertToShort:(hudOffsets[10]/hudTexture.paddedSize.width)]; //this one is a given
  hudVerticesUVs[VERTEX_COUNT*4-9] = [FlxGLView convertToShort:(hudTexture.size.height/hudTexture.paddedSize.height)];
  hudVerticesUVs[VERTEX_COUNT*4-14] = [FlxGLView convertToShort:(hudOffsets[10]/hudTexture.paddedSize.width)]; //given
  hudVerticesUVs[VERTEX_COUNT*4-13] = [FlxGLView convertToShort:(0)];

  //then digits
  for (int i = 0; i < DIGITS; ++i) {
    hudVerticesUVs[VERTEX_COUNT*4-(i+1)*16-4] = (GLshort)(width-runningWidth);
    hudVerticesUVs[VERTEX_COUNT*4-(i+1)*16-3] = (GLshort)(hudTexture.size.height);
    hudVerticesUVs[VERTEX_COUNT*4-(i+1)*16-8] = (GLshort)(width-runningWidth);
    hudVerticesUVs[VERTEX_COUNT*4-(i+1)*16-7] = 0;
    runningWidth += digitWidths[DIGITS-1-i];
    hudVerticesUVs[VERTEX_COUNT*4-(i+1)*16-12] = (GLshort)(width-runningWidth);
    hudVerticesUVs[VERTEX_COUNT*4-(i+1)*16-11] = (GLshort)(hudTexture.size.height);
    hudVerticesUVs[VERTEX_COUNT*4-(i+1)*16-16] = (GLshort)(width-runningWidth);
    hudVerticesUVs[VERTEX_COUNT*4-(i+1)*16-15] = 0;
    hudVerticesUVs[VERTEX_COUNT*4-(i+1)*16-2] = [FlxGLView convertToShort:(hudOffsets[digits[i]+1]/hudTexture.paddedSize.width)];
    hudVerticesUVs[VERTEX_COUNT*4-(i+1)*16-1] = [FlxGLView convertToShort:(hudTexture.size.height/hudTexture.paddedSize.height)];
    hudVerticesUVs[VERTEX_COUNT*4-(i+1)*16-6] = [FlxGLView convertToShort:(hudOffsets[digits[i]+1]/hudTexture.paddedSize.width)];
    hudVerticesUVs[VERTEX_COUNT*4-(i+1)*16-5] = [FlxGLView convertToShort:(0)];
    hudVerticesUVs[VERTEX_COUNT*4-(i+1)*16-10] = [FlxGLView convertToShort:(hudOffsets[digits[i]]/hudTexture.paddedSize.width)];
    hudVerticesUVs[VERTEX_COUNT*4-(i+1)*16-9] = [FlxGLView convertToShort:(hudTexture.size.height/hudTexture.paddedSize.height)];
    hudVerticesUVs[VERTEX_COUNT*4-(i+1)*16-14] = [FlxGLView convertToShort:(hudOffsets[digits[i]]/hudTexture.paddedSize.width)];
    hudVerticesUVs[VERTEX_COUNT*4-(i+1)*16-13] = [FlxGLView convertToShort:(0)];
  }


  BOOL blank = YES;
  for (int i = DIGITS-1; i >= 0; --i) {
    if (digits[i] != 0) {
      blank = NO;
      break;
    }
    if (blank) {
      hudVerticesUVs[(DIGITS-i-1)*16+5] = hudVerticesUVs[(DIGITS-i-1)*16+1];
      hudVerticesUVs[(DIGITS-i-1)*16+13] = hudVerticesUVs[(DIGITS-i-1)*16+9];
    }
  }
  
}


- (void) render
{
  if (!self.visible)
    return;
  CGPoint _point = [self getScreenXY];
  glPushMatrix();
  glTranslatef(_point.x, _point.y, 0);
  if (hudTexture)
    [[self class] bind:hudTexture.texture];
  glVertexPointer(2, GL_SHORT, sizeof(GLshort)*4, &(hudVerticesUVs[0]));
  glTexCoordPointer(2, GL_SHORT, sizeof(GLshort)*4, &(hudVerticesUVs[2]));
  glDrawArrays(GL_TRIANGLE_STRIP, 0, VERTEX_COUNT);
  glPopMatrix();
}

@end
