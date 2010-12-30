//
//  FlxTileblock.h
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


#import <Flixel/FlxObject.h>
#import <OpenGLES/ES1/gl.h>

@class SemiSecretTexture;

@interface FlxTileblock : FlxObject
{
  SemiSecretTexture * texture;
  GLshort * verticesUVs;
  GLshort uShort;
  GLshort vShort;

  CGFloat tileSize;
  unsigned int vertexCount;
  unsigned int empties;
  unsigned int byteCount;
}

+ (id) tileblockWithX:(float)X y:(float)Y width:(float)Width height:(float)Height;
- (id) initWithX:(float)X y:(float)Y width:(float)Width height:(float)Height;
- (id) loadGraphic:(NSString *)TileGraphic;
- (id) loadGraphic:(NSString *)TileGraphic empties:(unsigned int)Empties;
- (void) render;

@end

