//
//  SemiSecretTexture.h
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

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>

@class UIView;

typedef enum {
  SSTextureFilteringDefault,
  SSTextureFilteringNearest,
  SSTextureFilteringLinear,
} SSTextureFiltering;

typedef enum {
  SSTextureDepth32Bits,
  SSTextureDepth16Bits5551,
  SSTextureDepth16Bits4444,
} SSTextureDepth;

@interface SemiSecretTexture : NSObject <NSCopying>
{
  GLuint texture;
  CGSize size;
  CGSize paddedSize;
  CGPoint offset;
  SemiSecretTexture * atlasTexture;
  CGPoint atlasOffset;
  CGPoint atlasScale;
  GLshort vertexData[4*2];
  GLshort * texCoords;
  unsigned int frames;
  BOOL animated;
  GLubyte * data;
}
@property (readonly) GLuint texture;
@property (readonly) CGSize size;
@property (readonly) CGSize paddedSize;
@property (readonly) CGPoint offset;

@property (readonly) unsigned int width;
@property (readonly) unsigned int height;
@property (readonly) unsigned int paddedWidth;
@property (readonly) unsigned int paddedHeight;

@property (readonly) unsigned int frames;
@property (readonly) GLshort * vertices;
@property (readonly) GLshort * texCoords;
@property (assign) BOOL animated;

@property (readonly) SemiSecretTexture * atlasTexture;
@property (readonly) CGPoint atlasOffset;
@property (readonly) CGPoint atlasScale;

+ (void) setTextureFilteringMode:(SSTextureFiltering)filtering;
+ (SSTextureFiltering) textureFilteringMode;
+ (void) setTextureDepth:(SSTextureDepth)depth;
+ (SSTextureDepth) textureDepth;

+ (id) textureWithImage:(NSString *)filename;
+ (id) textureWithView:(UIView *)view;
+ (id) textureWithColor:(unsigned int)color;
+ (id) textureWithCGColor:(CGColorRef)cgcolor;
+ (id) textureWithSize:(CGSize)size images:(NSArray *)images locations:(NSDictionary *)locations;
+ (id) textureWithAtlasTexture:(SemiSecretTexture *)atlasTexture offset:(CGPoint)offset size:(CGSize)size;

- (id) initWithImage:(NSString *)filename;
- (id) initWithView:(UIView *)view;
- (id) initWithColor:(unsigned int)color;
- (id) initWithCGColor:(CGColorRef)cgcolor;
- (id) initWithSize:(CGSize)size images:(NSArray *)images locations:(NSDictionary *)locations;
- (id) initWithAtlasTexture:(SemiSecretTexture *)atlasTexture offset:(CGPoint)offset size:(CGSize)size;

+ (NSMutableDictionary *) textureMap;

@end
