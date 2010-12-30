//
//  FlxTileblock.m
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

@interface FlxTileblock ()
- (void) renderBlock;
@end

@implementation FlxTileblock

+ (id) tileblockWithX:(float)X y:(float)Y width:(float)Width height:(float)Height;
{
  return [[[self alloc] initWithX:X y:Y width:Width height:Height] autorelease];
}

- (id) initWithX:(float)X y:(float)Y width:(float)Width height:(float)Height;
{
  if ((self = [super initWithX:X y:Y width:Width height:Height])) {
    fixed = YES;
    byteCount = 0;
    verticesUVs = NULL;
    [self refreshHulls];
  }
  return self;
}

- (void) dealloc
{
  [texture release];
  [super dealloc];
}

- (id) loadGraphic:(NSString *)TileGraphic;
{
  return [self loadGraphic:TileGraphic empties:0];
}

// - (void) setY:(float)newY
// {
//   NSLog(@"setting y to : %f, old : %f", newY, self.y);
//   [super setY:newY];
// }

- (id) loadGraphic:(NSString *)TileGraphic empties:(unsigned int)Empties;
{
  if (TileGraphic == nil) {
    NSLog(@"can't load a null graphic");
    return self;
  }

  if (texture != nil) {
    [texture release];
    texture = nil;
  }
  
  texture = [[FlxG addTextureWithParam1:TileGraphic param2:NO] retain];
  if (texture == nil) {
    NSLog(@"couldn't find texture");
    return self;
  }
  tileSize = texture.height;
  unsigned int widthInTiles = ceil(width*1.0/tileSize);
  unsigned int heightInTiles = ceil(height*1.0/tileSize);
  width = widthInTiles * tileSize;
  height = heightInTiles * tileSize;
  //unsigned int numTiles = widthInTiles*heightInTiles;
  unsigned int numGraphics = texture.width/tileSize;

  int m = widthInTiles;
  int n = heightInTiles;

  vertexCount = 4*m + (2 + 4*m)*(n-1);
  unsigned int newByteCount = sizeof(GLshort)*vertexCount*2*2;
  if (verticesUVs != NULL && newByteCount > byteCount)
    free(verticesUVs);
  if (verticesUVs == NULL || newByteCount > byteCount) {
    byteCount = newByteCount;
    verticesUVs = malloc(byteCount);
  }
  
  uShort = [FlxGLView convertToShort:tileSize/texture.paddedWidth];
  vShort = [FlxGLView convertToShort:tileSize/texture.paddedHeight];
  
  //for (unsigned int i = 0; i < numTiles; ++i) {
  int vi = 0;
  for (unsigned int j=0; j<n; ++j) {
    for (unsigned int i=0; i<m; ++i) {
      if (i == 0) {
	if (j != 0) { //add in 'stitching'
	  verticesUVs[vi] = (GLshort)(m*tileSize);
	  verticesUVs[vi+1] = (GLshort)(j*tileSize);
	  verticesUVs[vi+4] = (GLshort)(0);
	  verticesUVs[vi+5] = (GLshort)(j*tileSize);
	  //doesn't matter what uvs are set to
	  verticesUVs[vi+2] = verticesUVs[vi+3] = verticesUVs[vi+6] = verticesUVs[vi+7] = 0;
	  vi += 8;
	}
      }
      verticesUVs[vi] = (GLshort)(i*tileSize);
      verticesUVs[vi+1] = (GLshort)(j*tileSize);
      verticesUVs[vi+4] = (GLshort)(i*tileSize);
      verticesUVs[vi+5] = (GLshort)((j+1)*tileSize);
      verticesUVs[vi+8] = (GLshort)((i+1)*tileSize);
      verticesUVs[vi+9] = (GLshort)(j*tileSize);
      verticesUVs[vi+12] = (GLshort)((i+1)*tileSize);
      verticesUVs[vi+13] = (GLshort)((j+1)*tileSize);
      if (FlxU.random * (numGraphics + Empties) > Empties || Empties == 0) {
	int gi = FlxU.random*numGraphics;
	if (texture.atlasTexture) {
	  verticesUVs[vi+2] = (GLshort)(gi*uShort*texture.atlasScale.x + texture.atlasOffset.x + 0.5);
	  verticesUVs[vi+3] = (GLshort)(0 + texture.atlasOffset.y + 0.5);
	  verticesUVs[vi+6] = (GLshort)(gi*uShort*texture.atlasScale.x + texture.atlasOffset.x + 0.5);
	  verticesUVs[vi+7] = (GLshort)(vShort*texture.atlasScale.y + texture.atlasOffset.y + 0.5);
	  verticesUVs[vi+10] = (GLshort)((gi+1)*uShort*texture.atlasScale.x + texture.atlasOffset.x + 0.5);
	  verticesUVs[vi+11] = (GLshort)(0 + texture.atlasOffset.y + 0.5);
	  verticesUVs[vi+14] = (GLshort)((gi+1)*uShort*texture.atlasScale.x + texture.atlasOffset.x + 0.5);
	  verticesUVs[vi+15] = (GLshort)(vShort*texture.atlasScale.y + texture.atlasOffset.y + 0.5);
	} else {
	  verticesUVs[vi+2] = gi*uShort;
	  verticesUVs[vi+3] = 0;
	  verticesUVs[vi+6] = gi*uShort;
	  verticesUVs[vi+7] = vShort;
	  verticesUVs[vi+10] = (gi+1)*uShort;
	  verticesUVs[vi+11] = 0;
	  verticesUVs[vi+14] = (gi+1)*uShort;
	  verticesUVs[vi+15] = vShort;
	}
      } else {
	//blank entry
	verticesUVs[vi+2] = verticesUVs[vi+3] = verticesUVs[vi+6] = verticesUVs[vi+7] =
	  verticesUVs[vi+10] = verticesUVs[vi+11] = verticesUVs[vi+14] = verticesUVs[vi+15] = 0;
      }
      vi += 16;
    }
  }
  return self;
}

- (void) render;
{
  [self renderBlock];
}

- (void) renderBlock
{
  if (texture == nil)
    return;
  CGPoint _point = [self getScreenXY];
  [[self class] bind:texture.texture];
  glPushMatrix();
  glTranslatef(_point.x, _point.y, 0);
  glVertexPointer(2, GL_SHORT, sizeof(GLshort)*4, &verticesUVs[0]);
  glTexCoordPointer(2, GL_SHORT, sizeof(GLshort)*4, &verticesUVs[2]);
  glDrawArrays(GL_TRIANGLE_STRIP, 0, vertexCount);
  glPopMatrix();
}

@end
