//
//  RepeatBlock.m
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

#import "RepeatBlock.h"

@implementation RepeatBlock

+ (id) repeatBlockWithX:(float)X y:(float)Y width:(float)Width height:(float)Height;
{
  return [self repeatBlockWithX:X y:Y width:Width height:Height graphic:nil];
}

+ (id) repeatBlockWithX:(float)X y:(float)Y width:(float)Width height:(float)Height graphic:(NSString *)image;
{
  RepeatBlock * ret = [[[self alloc] initWithX:X y:Y width:Width height:Height] autorelease];
  [ret loadGraphic:image];
  return ret;
}

- (id) initWithX:(float)X y:(float)Y width:(float)Width height:(float)Height graphic:(NSString *)image;
{
  if ((self = [super initWithX:X y:Y width:Width height:Height])) {
    if (image)
      [self loadGraphic:image];
  }
  return self;
}

- (id) loadGraphic:(NSString *)RepeatGraphic empties:(unsigned int)Empties;
{
  if (RepeatGraphic == nil)
    return self;

  if (texture != nil) {
    [texture release];
    texture = nil;
  }

  //assume just one image in RepeatGraphic
  
  texture = [[FlxG addTextureWithParam1:RepeatGraphic param2:NO] retain];
  if (texture == nil) {
    NSLog(@"couldn't find texture");
    return self;
  }

  scrollFactor.x = 1;
  scrollFactor.y = 1;

  tileSize = texture.height;

  float widthTileSize = texture.width;
  float heightTileSize = texture.height;
  
  unsigned int widthInTiles = ceil(width*1.0/widthTileSize);
  unsigned int heightInTiles = ceil(height*1.0/heightTileSize);
  width = widthInTiles * widthTileSize;
  height = heightInTiles * heightTileSize;
  //unsigned int numTiles = widthInTiles*heightInTiles;
//   unsigned int numGraphics = texture.width/tileSize;

  
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

  uShort = [FlxGLView convertToShort:widthTileSize/texture.paddedWidth];
  vShort = [FlxGLView convertToShort:heightTileSize/texture.paddedHeight];

  
  //for (unsigned int i = 0; i < numTiles; ++i) {
  int vi = 0;
  for (unsigned int j=0; j<n; ++j) {
    for (unsigned int i=0; i<m; ++i) {
      if (i == 0) {
	if (j != 0) { //add in 'stitching'
	  verticesUVs[vi] = (GLshort)(m*widthTileSize);
	  verticesUVs[vi+1] = (GLshort)(j*heightTileSize);
	  verticesUVs[vi+4] = (GLshort)(0);
	  verticesUVs[vi+5] = (GLshort)(j*heightTileSize);
	  //doesn't matter what uvs are set to
	  verticesUVs[vi+2] = verticesUVs[vi+3] = verticesUVs[vi+6] = verticesUVs[vi+7] = 0;
	  vi += 8;
	}
      }
      verticesUVs[vi] = (GLshort)(i*widthTileSize);
      verticesUVs[vi+1] = (GLshort)(j*heightTileSize);
      verticesUVs[vi+4] = (GLshort)(i*widthTileSize);
      verticesUVs[vi+5] = (GLshort)((j+1)*heightTileSize);
      verticesUVs[vi+8] = (GLshort)((i+1)*widthTileSize);
      verticesUVs[vi+9] = (GLshort)(j*heightTileSize);
      verticesUVs[vi+12] = (GLshort)((i+1)*widthTileSize);
      verticesUVs[vi+13] = (GLshort)((j+1)*heightTileSize);

      if (texture.atlasTexture) {
	verticesUVs[vi+2] = (GLshort)(texture.atlasOffset.x + 0.5);
	verticesUVs[vi+3] = (GLshort)(texture.atlasOffset.y + 0.5);
	verticesUVs[vi+6] = (GLshort)(texture.atlasOffset.x + 0.5);
	verticesUVs[vi+7] = (GLshort)(vShort*texture.atlasScale.y + texture.atlasOffset.y + 0.5);
	verticesUVs[vi+10] = (GLshort)(uShort*texture.atlasScale.x + texture.atlasOffset.x + 0.5);
	verticesUVs[vi+11] = (GLshort)(texture.atlasOffset.y + 0.5);
	verticesUVs[vi+14] = (GLshort)(uShort*texture.atlasScale.x + texture.atlasOffset.x + 0.5);
	verticesUVs[vi+15] = (GLshort)(vShort*texture.atlasScale.y + texture.atlasOffset.y + 0.5);
      } else {
	verticesUVs[vi+2] = 0;
	verticesUVs[vi+3] = 0;
	verticesUVs[vi+6] = 0;
	verticesUVs[vi+7] = vShort;
	verticesUVs[vi+10] = uShort;
	verticesUVs[vi+11] = 0;
	verticesUVs[vi+14] = uShort;
	verticesUVs[vi+15] = vShort;
      }

      vi += 16;
    }
  }
  return self;
}



@end
