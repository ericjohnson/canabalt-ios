//
//  SemiSecretTexture.m
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

#import <SemiSecret/SemiSecret.h>
#import <Flixel/FlxGLView.h>
#import <Flixel/FlxG.h>

static NSMutableDictionary * textureMap = nil;

//#define USE_SHORT
//#define USE_4_4_4_4

@interface SemiSecretTexture ()
- (void) prepareWithWidth:(int)width height:(int)height;
- (void) createTexture;
- (void) setupVerticesTexCoords;
@end

@implementation SemiSecretTexture

static SSTextureFiltering textureFilteringMode = SSTextureFilteringDefault;
static SSTextureDepth textureDepth = SSTextureDepth32Bits;


+ (void) setTextureFilteringMode:(SSTextureFiltering)filtering;
{
  textureFilteringMode = filtering;
}
+ (SSTextureFiltering) textureFilteringMode;
{
  return textureFilteringMode;
}

+ (void) setTextureDepth:(SSTextureDepth)depth;
{
  textureDepth = depth;
}
+ (SSTextureDepth) textureDepth;
{
  return textureDepth;
}

@synthesize texture;
@synthesize size;
@synthesize paddedSize;
@synthesize offset;

@synthesize atlasTexture;
@synthesize atlasOffset;
@synthesize atlasScale;

@synthesize frames, texCoords;
@dynamic vertices;
@synthesize animated;


- (GLshort *) vertices;
{
  return &vertexData[0];
}

- (unsigned int) width;
{
  return (unsigned int)size.width;
}
- (unsigned int) height;
{
  return (unsigned int)size.height;
}
- (unsigned int) paddedWidth;
{
  return (unsigned int)paddedSize.width;
}
- (unsigned int) paddedHeight;
{
  return (unsigned int)paddedSize.height;
}

+ (NSMutableDictionary *)textureMap
{
  return textureMap;
}

+ (void) initialize
{
  if (self == [SemiSecretTexture class]) {
    textureMap = [[NSMutableDictionary alloc] init];
    [self setTextureFilteringMode:SSTextureFilteringDefault];
  }
}

+ (id) textureWithImage:(NSString *)filename
{
  return [[(SemiSecretTexture *)[self alloc] initWithImage:filename] autorelease];
}
+ (id) textureWithColor:(unsigned int)color
{
  return [[[self alloc] initWithColor:color] autorelease];
}
+ (id) textureWithCGColor:(CGColorRef)cgcolor
{
  return [[[self alloc] initWithCGColor:cgcolor] autorelease];
}
+ (id) textureWithView:(UIView *)view
{
  return [[[self alloc] initWithView:view] autorelease];
}
+ (id) textureWithSize:(CGSize)size images:(NSArray *)images locations:(NSDictionary *)locations;
{
  return [[[self alloc] initWithSize:size images:images locations:locations] autorelease];
}
+ (id) textureWithAtlasTexture:(SemiSecretTexture *)atlasTexture offset:(CGPoint)offset size:(CGSize)size;
{
  return [[[self alloc] initWithAtlasTexture:atlasTexture offset:offset size:size] autorelease];
}

- (id) initWithImage:(NSString *)filename
{
  if ((self = [super init])) {

    //NSLog(@"SemiSecretTexture initWithImage:%@", filename);

    //UIImage * image = [UIImage imageNamed:filename];
    NSString * imageFile = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename];
    UIImage * image = [UIImage imageWithContentsOfFile:imageFile];

    if (image == nil) {
      NSLog(@"SemiSecretTexture initWithImage: could not find image named: %@", filename);
      [self release];
      return nil;
    }

    [self prepareWithWidth:CGImageGetWidth(image.CGImage) height:CGImageGetHeight(image.CGImage)];

    if (data == NULL) {
      [self release];
      return nil;
    }

    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data,
						 paddedSize.width,
						 paddedSize.height,
						 8,
						 paddedSize.width*4,
						 colorspace,
						 kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorspace);
    CGContextDrawImage(context,
		       CGRectMake(0, paddedSize.height-size.height, size.width, size.height),
		       image.CGImage);
    CGContextRelease(context);

    [self createTexture];
    [self setupVerticesTexCoords];
  
    free(data);
  }
  return self;
}

- (id) initWithView:(UIView *)view
{
  if ((self = [super init])) {

    [self prepareWithWidth:view.bounds.size.width height:view.bounds.size.height];

    if (data == NULL) {
      [self release];
      return nil;
    }

    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data,
						 paddedSize.width,
						 paddedSize.height,
						 8,
						 paddedSize.width*4,
						 colorspace,
						 kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorspace);


    //why the two of these back to back? can be replaced with one? (copied from previous implementation)
    CGContextTranslateCTM(context, 0.0, paddedSize.height-size.height);
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    //
    UIGraphicsPushContext(context);
    [view drawRect:CGRectMake(0, 0, size.width, size.height)];
    UIGraphicsPopContext();

    CGContextRelease(context);

    [self createTexture];
    [self setupVerticesTexCoords];
  
    free(data);
  }
  return self;
}


- (id) initWithColor:(unsigned int)color
{
  if ((self = [super init])) {

    [self prepareWithWidth:8 height:8];

    if (data == NULL) {
      [self release];
      return nil;
    }
    
    GLubyte r = (GLubyte)((color >> 16) & 0xff);
    GLubyte g = (GLubyte)((color >> 8) & 0xff);
    GLubyte b = (GLubyte)(color & 0xff);
    GLubyte a = (GLubyte)((color >> 24) & 0xff);

    for (int i = 0; i < size.width*size.height*4; i += 4) {
      data[i] = r;
      data[i+1] = g;
      data[i+2] = b;
      data[i+3] = a;
    }

    [self createTexture];
    [self setupVerticesTexCoords];

    free(data);
  }
    
  return self;
}

- (id) initWithCGColor:(CGColorRef)cgcolor
{
  if ((self = [super init])) {

    size_t componentCount = CGColorGetNumberOfComponents(cgcolor);
    if (componentCount != 4) {
      NSLog(@"SemiSecretTexture - invalid component count in color...");
      [self release];
      return nil;
    }

    [self prepareWithWidth:8 height:8];

    if (data == NULL) {
      [self release];
      return nil;
    }
    
    const CGFloat * components = CGColorGetComponents(cgcolor);
    GLubyte r = (GLubyte)(components[0]*255);
    GLubyte g = (GLubyte)(components[1]*255);
    GLubyte b = (GLubyte)(components[2]*255);
    GLubyte a = (GLubyte)(components[3]*255);

    for (int i = 0; i < size.width*size.height*4; i += 4) {
      data[i] = r;
      data[i+1] = g;
      data[i+2] = b;
      data[i+3] = a;
    }

    [self createTexture];
    [self setupVerticesTexCoords];

    free(data);
  }
    
  return self;
}

- (id) initWithSize:(CGSize)Size images:(NSArray *)images locations:(NSDictionary *)locations
{
  if ((self = [super init])) {

    //NSLog(@"creating atlas texture: size: (%f,%f)", Size.width, Size.height);
    
    [self prepareWithWidth:Size.width height:Size.height];

    if (data == NULL) {
      [self release];
      return nil;
    }

    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data,
						 paddedSize.width,
						 paddedSize.height,
						 8,
						 paddedSize.width*4,
						 colorspace,
						 kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorspace);

    for (NSString * imageFile in images) {
      UIImage * image = [UIImage imageNamed:imageFile];
      CGRect location = [[locations objectForKey:imageFile] CGRectValue];
      if (image == nil ||
	  CGRectEqualToRect(location, CGRectZero))
	continue;
      CGContextDrawImage(context,
			 CGRectMake(location.origin.x,
				    //paddedSize.height-Size.height+location.origin.y,
				    paddedSize.height-Size.height+(Size.height-location.origin.y-location.size.height),
				    location.size.width, location.size.height),
			 image.CGImage);
    }
    
    CGContextRelease(context);

    [self createTexture];
    [self setupVerticesTexCoords];
  
    free(data);
  }
  return self;
}

- (id) initWithAtlasTexture:(SemiSecretTexture *)AtlasTexture offset:(CGPoint)Offset size:(CGSize)Size
{
  if ((self = [super init])) {

    texture = AtlasTexture.texture;
    size = Size;
    //just for atlas textures
    paddedSize = Size;
    offset = Offset;
    
    atlasTexture = [AtlasTexture retain];

    atlasOffset = CGPointMake((float)([FlxGLView convertToShort:(offset.x/AtlasTexture.paddedSize.width)]),
  			      (float)([FlxGLView convertToShort:(offset.y/AtlasTexture.paddedSize.height)]));

    atlasScale = CGPointMake(size.width/AtlasTexture.paddedSize.width,
 			     size.height/AtlasTexture.paddedSize.height);
    
    [self setupVerticesTexCoords];
    
  }
  return self;
}

- (void) dealloc
{
  if (texture != 0)
    glDeleteTextures(1, &texture);
  free(texCoords);
  if (atlasTexture)
    [atlasTexture release];
  [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
  return [self retain];
}

// - (NSString *) description
// {
//   return [NSString stringWithFormat:@"<SemiSecretTexture:%x>", self];
// }

- (void) prepareWithWidth:(int)width height:(int)height;
{
  size = CGSizeMake(width, height);
  int paddedWidth = width;
  int paddedHeight = height;
  if (width != 1 && (width & (width-1))) {
    paddedWidth = 1;
    while (paddedWidth < width)
      paddedWidth <<= 1;
  }
  if (height != 1 && (height & (height-1))) {
    paddedHeight = 1;
    while (paddedHeight < height)
      paddedHeight <<= 1;
  }

  paddedSize = CGSizeMake(paddedWidth, paddedHeight);
  
  data = calloc(paddedWidth*4, paddedHeight);
  if (data == NULL) {
    NSLog(@"SemiSecretTexture prepareWithWidth: calloc failed");
  }
  
  GLint maxTextureSize;
  glGetIntegerv(GL_MAX_TEXTURE_SIZE, &maxTextureSize);
  if (paddedWidth > maxTextureSize ||
      paddedHeight > maxTextureSize) {
    NSLog(@"SemiSecretTexture: maximum texture size is %d, requested image is too large (%dx%d)",
	  maxTextureSize, paddedWidth, paddedHeight);
  }
}

- (void) setAnimated:(BOOL)Animated
{
  if (animated == Animated)
    return;
  animated = Animated;

  GLshort uShort = 0;
  GLshort vShort = 0;
  
  if (animated) {
    //if it's animated, then width needs to be height
    vertexData[2] = (GLshort)size.height;
    vertexData[6] = (GLshort)size.height;
    frames = (unsigned int)(size.width / size.height);
    uShort = [FlxGLView convertToShort:size.height/paddedSize.width];
    vShort = [FlxGLView convertToShort:size.height/paddedSize.height];
  } else {
    vertexData[2] = (GLshort)size.width;
    vertexData[6] = (GLshort)size.width;
    frames = 1;
    uShort = [FlxGLView convertToShort:size.width/paddedSize.width];
    vShort = [FlxGLView convertToShort:size.height/paddedSize.height];
  }

  if (texCoords)
    free(texCoords);
  texCoords = (GLshort *)malloc(sizeof(GLshort)*(4*2)*frames);

  for (int i=0; i<frames; ++i) {
    if (atlasTexture != nil) {
      texCoords[i*8+0] = (GLshort)((i*uShort)*atlasScale.x + atlasOffset.x + 0.5);
      texCoords[i*8+1] = (GLshort)(atlasOffset.y + 0.5);
      texCoords[i*8+2] = (GLshort)(((i+1)*uShort)*atlasScale.x + atlasOffset.x + 0.5);
      texCoords[i*8+3] = (GLshort)(atlasOffset.y + 0.5);
      texCoords[i*8+4] = (GLshort)((i*uShort)*atlasScale.x + atlasOffset.x + 0.5);
      texCoords[i*8+5] = (GLshort)(vShort*atlasScale.y + atlasOffset.y + 0.5);
      texCoords[i*8+6] = (GLshort)(((i+1)*uShort)*atlasScale.x + atlasOffset.x + 0.5);
      texCoords[i*8+7] = (GLshort)(vShort*atlasScale.y + atlasOffset.y + 0.5);
    } else {
      texCoords[i*8+0] = i*uShort;
      texCoords[i*8+1] = 0;
      texCoords[i*8+2] = (i+1)*uShort;
      texCoords[i*8+3] = 0;
      texCoords[i*8+4] = i*uShort;
      texCoords[i*8+5] = vShort;
      texCoords[i*8+6] = (i+1)*uShort;
      texCoords[i*8+7] = vShort;
    }      
  }

}

- (void) setupVerticesTexCoords
{

    //setup vertex data
  vertexData[0] = 0;
  vertexData[1] = 0;
  vertexData[2] = (GLshort)size.width;
  vertexData[3] = 0;
  vertexData[4] = 0;
  vertexData[5] = (GLshort)size.height;
  vertexData[6] = (GLshort)size.width;
  vertexData[7] = (GLshort)size.height;

  texCoords = NULL;
  //make sure setAnimated actually creates tex coord data
  animated = YES;
  self.animated = NO;
  
}

- (void) createTexture;
{
  if (textureDepth == SSTextureDepth16Bits5551) {
    GLubyte * truncatedData = calloc(paddedSize.width*2,paddedSize.height);
    if (data == NULL) {
      NSLog(@"SemiSecretTexture createTexture: calloc failed (5551)");
    }
    GLubyte r, g, b, a;
    GLshort packed;
    for (int i = 0; i < paddedSize.width*paddedSize.height*4; i += 4) {
      r = (data[i]) >> (8-5);
      g = data[i+1] >> (8-5);
      b = data[i+2] >> (8-5);
      a = data[i+3] >> (8-1);
      packed = ((r & 0x1f) << (5+5+1)) |
	((g & 0x1f) << (5+1)) |
	((b & 0x1f) << (1)) |
	(a & 0x1);
      truncatedData[(i >> 1)] = (packed >> 0) & 0xff;
      truncatedData[(i >> 1)+1] = (packed >> 8) & 0xff;
    }
    free(data);
    data = truncatedData;
  } else if (textureDepth == SSTextureDepth16Bits4444) {
    GLubyte * truncatedData = calloc(paddedSize.width*2,paddedSize.height);
    if (data == NULL) {
      NSLog(@"SemiSecretTexture createTexture: calloc failed (4444)");
    }
    GLubyte r, g, b, a;
    GLshort packed;
    for (int i = 0; i < paddedSize.width*paddedSize.height*4; i += 4) {
      r = data[i] >> 4;
      g = data[i+1] >> 4;
      b = data[i+2] >> 4;
      a = data[i+3] >> 4;
      packed = ((r & 0xf) << 12) | ((g & 0xf) << 8) | ((b & 0xf) << 4) | (a & 0xf);
      truncatedData[(i >> 1)] = (packed >> 0) & 0xff;
      truncatedData[(i >> 1)+1] = (packed >> 8) & 0xff;
    }
    free(data);
    data = truncatedData;
  }

  GLint lastTexture;
  glGetIntegerv(GL_TEXTURE_BINDING_2D, &lastTexture);
  if (texture == 0) { //when we reload, no need to generate a new texture
    glGenTextures(1, &texture);
    if (texture == 0) {
      NSLog(@"generated texture with 0 for name!");
    }
  }
  glBindTexture(GL_TEXTURE_2D, texture);
  if (textureFilteringMode == SSTextureFilteringDefault) {
    if (FlxG.iPad || FlxG.retinaDisplay) {
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    } else {
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    }
  } else {
    if (textureFilteringMode == SSTextureFilteringLinear) {
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    } else {
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    }
  }
  if (textureDepth == SSTextureDepth16Bits5551)
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, paddedSize.width, paddedSize.height, 0, GL_RGBA, GL_UNSIGNED_SHORT_5_5_5_1, data);
  else if (textureDepth == SSTextureDepth16Bits4444)
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, paddedSize.width, paddedSize.height, 0, GL_RGBA, GL_UNSIGNED_SHORT_4_4_4_4, data);
  else
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, paddedSize.width, paddedSize.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);

  glBindTexture(GL_TEXTURE_2D, lastTexture);
}

- (NSString *) description
{
  return [NSString stringWithFormat:@"<SemiSecretTexture:%x, atlasTexture:%@, texture:%d>", self, atlasTexture ? @"YES" : @"NO", texture];
}

@end
