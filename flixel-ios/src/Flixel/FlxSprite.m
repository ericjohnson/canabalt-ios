//
//  FlxSprite.m
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
#import <SemiSecret/SemiSecret.h>

const unsigned int LEFT = 0;
const unsigned int RIGHT = 1;
const unsigned int UP = 2;
const unsigned int DOWN = 3;

@interface FlxGame (BackingDimensions)
@property (readonly) GLint backingWidth;
@property (readonly) GLint backingHeight;
@end

@implementation FlxGame (BackingDimensions)
- (GLint) backingWidth
{
  return backingWidth;
}
- (GLint) backingHeight
{
  return backingHeight;
}
@end


@interface FlxSprite ()
- (void) calcFrame;
@property (readonly) float _bakedRotation;
- (void) resetHelpers;
- (void) setupUVs;
- (void) setupVertices;
- (void) setupTexCoords;
@property (assign) unsigned int _caf;
@property (assign) float _frameTimer;
@property (assign) unsigned int _curFrame;
@end

@implementation FlxSprite

@synthesize blend;

@synthesize _caf, _frameTimer, _curFrame;

@dynamic frame;

+ (unsigned int) LEFT;
{
  return LEFT;
}
+ (unsigned int) RIGHT;
{
  return RIGHT;
}
+ (unsigned int) UP;
{
  return UP;
}
+ (unsigned int) DOWN;
{
  return DOWN;
}

@synthesize _bakedRotation;

@synthesize scale;
@synthesize frameWidth;
@synthesize offset;
@synthesize antialiasing;
@synthesize frameHeight;
@synthesize finished;

+ (id) spriteWithX:(float)X y:(float)Y graphic:(NSString *)SimpleGraphic;
{
  return [[[self alloc] initWithX:X y:Y graphic:SimpleGraphic] autorelease];
}

+ (id) spriteWithGraphic:(NSString *)SimpleGraphic;
{
  return [[[self alloc] initWithX:0 y:0 graphic:SimpleGraphic] autorelease];
}

- (id) init;
{
  return [self initWithX:0];
}
- (id) initWithX:(float)X;
{
  return [self initWithX:X y:0];
}
- (id) initWithX:(float)X y:(float)Y;
{
  return [self initWithX:X y:Y graphic:nil];
}
- (id) initWithX:(float)X y:(float)Y graphic:(NSString *)SimpleGraphic;
{
  return [self initWithX:X y:Y graphic:SimpleGraphic modelScale:1.0];
}
- (id) initWithX:(float)X y:(float)Y graphic:(NSString *)SimpleGraphic modelScale:(float)ModelScale;
{
  //do it here, so it is available to inintializedPredictedState...
  if ((self = [super initWithX:X y:Y width:0 height:0])) {

    red = 255;
    green = 255;
    blue = 255;
    for (int i=0; i<4*4; ++i)
      _colors[i] = 255;
    filled = NO;
    
    x = X;
    y = Y;
    
    modelScale = ModelScale;
    if (SimpleGraphic == nil)
     [self createGraphicWithWidth:8 height:8];
    else
     [self loadGraphic:SimpleGraphic modelScale:modelScale];
    offset = CGPointZero;
    scale = CGPointMake(1,1);
    _alpha = 1;
    _color = 0x00ffffff;
    blend = nil;
    antialiasing = NO;
    finished = NO;
    _facing = RIGHT;
    _animations = [[NSMutableArray alloc] init];
    _flipped = 0;
    _curAnim = nil;
    _curFrame = 0;
    _caf = 0;
    _frameTimer = 0;
    _callback = nil;
    [self setupVertices];
    [self setupTexCoords];
  }
 return self;
}

- (void) dealloc
{
  [blend release];
  [_curAnim release];
  [_animations release];
  [_callback release];
  [super dealloc];
}

- (FlxSprite *) loadGraphic:(NSString *)Graphic;
{
  return [self loadGraphic:Graphic animated:NO];
}
- (FlxSprite *) loadGraphic:(NSString *)Graphic animated:(BOOL)Animated;
{
  return [self loadGraphic:Graphic animated:Animated reverse:NO];
}
- (FlxSprite *) loadGraphic:(NSString *)Graphic animated:(BOOL)Animated reverse:(BOOL)Reverse;
{
  return [self loadGraphic:Graphic animated:Animated reverse:Reverse width:0];
}
- (FlxSprite *) loadGraphic:(NSString *)Graphic animated:(BOOL)Animated reverse:(BOOL)Reverse width:(unsigned int)Width;
{
  return [self loadGraphic:Graphic animated:Animated reverse:Reverse width:Width height:0];
}
- (FlxSprite *) loadGraphic:(NSString *)Graphic animated:(BOOL)Animated reverse:(BOOL)Reverse width:(unsigned int)Width height:(unsigned int)Height;
{
  return [self loadGraphic:Graphic animated:Animated reverse:Reverse width:Width height:Height unique:NO];
}
- (FlxSprite *) loadGraphic:(NSString *)Graphic animated:(BOOL)Animated reverse:(BOOL)Reverse width:(unsigned int)Width height:(unsigned int)Height unique:(BOOL)Unique;
{
  return [self loadGraphic:Graphic animated:Animated reverse:Reverse width:Width height:Height unique:Unique modelScale:1.0];
}


- (FlxSprite *) loadGraphic:(NSString *)Graphic modelScale:(float)ModelScale;
{
  return [self loadGraphic:Graphic animated:NO modelScale:ModelScale];
}
- (FlxSprite *) loadGraphic:(NSString *)Graphic animated:(BOOL)Animated modelScale:(float)ModelScale;
{
  return [self loadGraphic:Graphic animated:Animated reverse:NO modelScale:ModelScale];
}
- (FlxSprite *) loadGraphic:(NSString *)Graphic animated:(BOOL)Animated reverse:(BOOL)Reverse modelScale:(float)ModelScale;
{
  return [self loadGraphic:Graphic animated:Animated reverse:Reverse width:0 height:0 unique:NO modelScale:ModelScale];
}


- (FlxSprite *) loadGraphic:(NSString *)Graphic
		   animated:(BOOL)Animated
		    reverse:(BOOL)Reverse
		      width:(unsigned int)Width
		     height:(unsigned int)Height
		     unique:(BOOL)Unique
		 modelScale:(float)ModelScale;
{
  modelScale = ModelScale;

  //reset colors to all white...
  [self fill:0xffffff];
  filled = NO;
  
  _bakedRotation = 0;

  [texture autorelease];
  texture = [[FlxG addTextureWithParam1:Graphic param2:Unique] retain];
  
  if (Reverse)
    _flipped = ((int)(texture.size.width)) >> 1;
  else
    _flipped = 0;

  if (Width == 0)
    {
      if (Animated) {
	Width = texture.size.height/modelScale;
      }
      else {
	Width = texture.size.width/modelScale;
      }
    }
  width = frameWidth = Width;
  if (Height == 0)
    {
      if (Animated)
	Height = width;
      else
	Height = texture.size.height/modelScale;
    }
  height = frameHeight = Height;
  if (Animated)
    texture.animated = YES;
  [self resetHelpers];
  return self;
}

- (FlxSprite *) loadRotatedGraphic:(NSString *)Graphic;
{
  return [self loadRotatedGraphic:Graphic rotations:16];
}
- (FlxSprite *) loadRotatedGraphic:(NSString *)Graphic rotations:(unsigned int)Rotations;
{
  return [self loadRotatedGraphic:Graphic rotations:Rotations frame:-1];
}
- (FlxSprite *) loadRotatedGraphic:(NSString *)Graphic rotations:(unsigned int)Rotations frame:(int)Frame;
{
  return [self loadRotatedGraphic:Graphic rotations:Rotations frame:Frame antiAliasing:NO];
}
- (FlxSprite *) loadRotatedGraphic:(NSString *)Graphic rotations:(unsigned int)Rotations frame:(int)Frame antiAliasing:(BOOL)AntiAliasing;
{
  return [self loadRotatedGraphic:Graphic rotations:Rotations frame:Frame antiAliasing:AntiAliasing autoBuffer:NO];
}
- (FlxSprite *) loadRotatedGraphic:(NSString *)Graphic rotations:(unsigned int)Rotations frame:(int)Frame antiAliasing:(BOOL)AntiAliasing autoBuffer:(BOOL)AutoBuffer;
{
  return [self loadRotatedGraphic:Graphic rotations:Rotations frame:Frame antiAliasing:AntiAliasing autoBuffer:AutoBuffer modelScale:1.0];
}

- (FlxSprite *) loadRotatedGraphic:(NSString *)Graphic rotations:(unsigned int)Rotations modelScale:(float)ModelScale;
{
  return [self loadRotatedGraphic:Graphic rotations:Rotations frame:-1 modelScale:ModelScale];
}
- (FlxSprite *) loadRotatedGraphic:(NSString *)Graphic rotations:(unsigned int)Rotations frame:(int)Frame modelScale:(float)ModelScale;
{
  return [self loadRotatedGraphic:Graphic rotations:Rotations frame:Frame antiAliasing:NO autoBuffer:NO modelScale:ModelScale];
}

- (FlxSprite *) loadRotatedGraphic:(NSString *)Graphic rotations:(unsigned int)Rotations frame:(int)Frame antiAliasing:(BOOL)AntiAliasing autoBuffer:(BOOL)AutoBuffer modelScale:(float)ModelScale;
{
  unsigned int rows = 4;
  modelScale = ModelScale;
  FlxSprite * brush = [(FlxSprite *)[[[FlxSprite alloc] init] autorelease] loadGraphic:Graphic animated:(Frame >= 0) modelScale:ModelScale];
  if (Frame >= 0)
    brush.frame = Frame;
  unsigned int max = brush.width;
  if (brush.height > max)
    max = brush.height;
  if (AutoBuffer)
    max *= 1.5;
  unsigned int cols = ceil(Rotations / rows);
  width = max * cols;
  height = max * rows;
  NSString * key = [NSString stringWithFormat:@"%@:%d:%fx%f", Graphic, Frame, width, height];
  BOOL skipGen = [FlxG checkBitmapCache:key];
  [self createGraphicWithWidth:width height:height color:0 unique:YES key:key];
  _bakedRotation = 360 / Rotations;
  if (!skipGen) {
    unsigned int r;
    unsigned int c;
    unsigned int bw2 = brush.width / 2;
    unsigned int bh2 = brush.height / 2;
    unsigned int gxc = max / 2;
    unsigned int gyc = max / 2;
    for (r = 0; r < rows; r++) {
      for (c = 0; c < cols; c++) {
	[self drawWithParam1:brush param2:gxc + max * c - bw2 param3:gyc-bh2];
	brush.angle += _bakedRotation;
      }
      gyc += max;
    }
  }
  frameWidth = frameHeight = width = height = max;
  [self resetHelpers];

  return self;
}
//   unsigned int rows = 4;
//   FlxSprite * brush = [(FlxSprite *)[[[FlxSprite alloc] init] autorelease] loadGraphicWithParam1:Graphic param2:(Frame >= 0)];
//   if (Frame >= 0)
//     brush.frame = Frame;
//   brush.antialiasing = AntiAliasing;
//   unsigned int max = brush.width;
//   if (brush.height > max)
//     max = brush.height;
//   if (AutoBuffer)
//     max *= 1.5;
//   unsigned int cols = ceil(Rotations / rows);
//   width = max * cols;
//   height = max * rows;
//   NSString * key = [NSString stringWithFormat:@"%@:%d:%fx%f", Graphic, Frame, width, height];
//   BOOL skipGen = [FlxG checkBitmapCache:key];
//   [self createGraphicWithParam1:width param2:height param3:0 param4:YES param5:key];
//   _bakedRotation = 360 / Rotations;
//   if (!skipGen)
//     {
//       unsigned int r;
//       unsigned int c;
//       unsigned int bw2 = brush.width / 2;
//       unsigned int bh2 = brush.height / 2;
//       unsigned int gxc = max / 2;
//       unsigned int gyc = max / 2;
//       for ( r = 0; r < rows; r++ )
// 	{
// 	  for ( c = 0; c < cols; c++ )
// 	    {
// 	      [self drawWithParam1:brush param2:gxc + max * c - bw2 param3:gyc - bh2];
// 	      brush.angle += _bakedRotation;
// 	    }
// 	  gyc += max;
// 	}
//     }
//   frameWidth = frameHeight = width = height = max;
//   [self resetHelpers];
//   return self;
//}

- (FlxSprite *) createGraphicWithWidth:(unsigned int)Width height:(unsigned int)Height;
{
  return [self createGraphicWithWidth:Width height:Height color:0xffffffff];
}
- (FlxSprite *) createGraphicWithWidth:(unsigned int)Width height:(unsigned int)Height color:(unsigned int)Color;
{
  return [self createGraphicWithWidth:Width height:Height color:Color unique:NO];
}
- (FlxSprite *) createGraphicWithWidth:(unsigned int)Width height:(unsigned int)Height color:(unsigned int)Color unique:(BOOL)Unique;
{
  return [self createGraphicWithWidth:Width height:Height color:Color unique:Unique key:nil];
}
- (FlxSprite *) createGraphicWithWidth:(unsigned int)Width height:(unsigned int)Height color:(unsigned int)Color unique:(BOOL)Unique key:(NSString *)Key;
{
  //just set texture to nil to indicate no texture...
  
  //ignore unique
//   if (Unique == YES) {
//     fprintf(stderr, "\n\n\n");
//     NSLog(@"createGraphic Unique!!");
//     fprintf(stderr, "\n\n\n");
//   }

  [self fill:Color];
  

  //set up colors
  
  width = frameWidth = Width;//texture.size.width; //special case, because texture will always by 8x8
  height = frameHeight = Height;//texture.size.height;
  [self resetHelpers];
  return self;
}


// - (FlashBitmapData *) pixels
// {
//   return _pixels;
// }

// - (void) setPixels:(FlashBitmapData *)Pixels
// {
//   [_pixels autorelease];
//   _pixels = [Pixels retain];
//   width = frameWidth = _pixels.width;
//   height = frameHeight = _pixels.height;
//   [self resetHelpers];
// }

// - (void) setX:(float)X
// {
//   x = X;
//   predictedX = x;
// //   NSLog(@"setX: %f", X);
// //   [self setupUVs];
// }

// - (void) setY:(float)Y
// {
//   y = Y;
//   predictedY = y;
// //   NSLog(@"setY: %f", Y);
// //   [self setupUVs];
// }

- (void) setWidth:(float)Width
{
  super.width = Width;
  [self resetHelpers];
}
- (void) setHeight:(float)Height
{
  super.height = Height;
  [self resetHelpers];
}

//- (void) setFrameHeight:(unsigned int)newFrameHeight
- (void) setFrameHeight:(float)newFrameHeight
{
  frameHeight = newFrameHeight;
  [self resetHelpers];
}
//- (void) setFrameWidth:(unsigned int)newFrameWidth
- (void) setFrameWidth:(float)newFrameWidth
{
  frameWidth = newFrameWidth;
  [self resetHelpers];
}

  //    width = Width;
//    NSLog(@"setWidth: %f", Width);
//    [self setupUVs];
//  }

//  - (void) setHeight:(float)Height
//  {
//    height = Height;
//    NSLog(@"setHeight: %f", Height);
//    [self setupUVs];
//  }

- (void) setupTexCoords
{
  if (texture == nil)
    return;

  int xframes = texture.size.width/frameWidth/modelScale;
  
  _uOffset = _caf % xframes;
  _vOffset = _caf / xframes;
  
  _uShort = [FlxGLView convertToShort:frameWidth*modelScale/texture.paddedSize.width];
  _vShort = [FlxGLView convertToShort:frameHeight*modelScale/texture.paddedSize.height];
  
  if (texture.atlasTexture) {
    // http://www.cocos2d-iphone.org/forum/topic/8267
    // The correct texture mapping for a given rect (rx, ry, rw, rh) in an image of size w x h is:
    // rect origin is zero based so the top left pixel is 0,0
    //  ((2*rx)+1)/(2*w), ((2*ry)+1))/(2*h)
    //   to
    //  (((2*rx)+1)+(rw*2)-2)/(2*w), (((2*ry)+1))+(rh*2)-2)/(2*h)
    //
    // For example an atlas of size 256x256 that contains a sprite image at 10,10 with size 100x100 the correct texture coordinates for each vertex are as follows:
    // 21/512, 21/512        -> (2*10+1)/(2*256)
    // 21/512, 219/512
    // 219/512, 219/512
    // 219/512, 21/512

    //TODO: why the extra *2 scale factor?
    CGRect r = CGRectMake(texture.offset.x + frameWidth * _uOffset * modelScale,
                          texture.offset.y + frameHeight * _vOffset * modelScale,
                          frameWidth * modelScale * 2,
                          frameHeight * modelScale * 2);
    CGPoint tl = CGPointMake((2*r.origin.x+1)/(2*texture.atlasTexture.paddedSize.width),
                             (2*r.origin.y+1)/(2*texture.atlasTexture.paddedSize.height));
    CGPoint br = CGPointMake((2*r.origin.x + 1 + r.size.width - 2)/(2*texture.atlasTexture.paddedSize.width),
                             (2*r.origin.y + 1 + r.size.height - 2)/(2*texture.atlasTexture.paddedSize.height));
                          
    _verticesUVs[2] = (GLshort)([FlxGLView convertToShort:tl.x]);
    _verticesUVs[3] = (GLshort)([FlxGLView convertToShort:tl.y]);
    _verticesUVs[6] = (GLshort)([FlxGLView convertToShort:br.x]);
    _verticesUVs[7] = (GLshort)([FlxGLView convertToShort:tl.y]);
    _verticesUVs[10] = (GLshort)([FlxGLView convertToShort:tl.x]);
    _verticesUVs[11] = (GLshort)([FlxGLView convertToShort:br.y]);
    _verticesUVs[14] = (GLshort)([FlxGLView convertToShort:br.x]);
    _verticesUVs[15] = (GLshort)([FlxGLView convertToShort:br.y]);
  } else {
    _verticesUVs[2] = _uOffset*_uShort;
    _verticesUVs[3] = _vOffset*_vShort;
    _verticesUVs[6] = (_uOffset+1)*_uShort;
    _verticesUVs[7] = _vOffset*_vShort;
    _verticesUVs[10] = _uOffset*_uShort;
    _verticesUVs[11] = (_vOffset+1)*_vShort;
    _verticesUVs[14] = (_uOffset+1)*_uShort;
    _verticesUVs[15] = (_vOffset+1)*_vShort;
  }
}

- (void) setupVertices
{
  if (_flipped) {
    _verticesUVs[0] = (GLshort)self.frameWidth;
    _verticesUVs[1] = 0;
    _verticesUVs[4] = 0;
    _verticesUVs[5] = 0;
    _verticesUVs[8] = (GLshort)self.frameWidth;
    _verticesUVs[9] = (GLshort)self.frameHeight;
    _verticesUVs[12] = 0;
    _verticesUVs[13] = (GLshort)self.frameHeight;
  } else {
    _verticesUVs[0] = 0;
    _verticesUVs[1] = 0;
    _verticesUVs[4] = (GLshort)self.frameWidth;
    _verticesUVs[5] = 0;
    _verticesUVs[8] = 0;
    _verticesUVs[9] = (GLshort)self.frameHeight;
    _verticesUVs[12] = (GLshort)self.frameWidth;
    _verticesUVs[13] = (GLshort)self.frameHeight;
  }
}

- (void) setupUVs
{
  [self setupVertices];
  [self setupTexCoords];
}

- (void) resetHelpers;
{
  [self setupVertices];
  [self setupTexCoords];

  origin.x = frameWidth / 2;
  origin.y = frameHeight / 2;
  _caf = 0;
  [self refreshHulls];
}

- (unsigned int) facing;
{  return _facing;
}
- (void) setFacing:(unsigned int)Direction;
{
  BOOL c = _facing != Direction;
  _facing = Direction;
  if (c)
    [self calcFrame];
}
- (float) alpha;
{
  return _alpha;
}
- (void) setAlpha:(float)Alpha;
{
  if (Alpha > 1)
    Alpha = 1;
  if (Alpha < 0)
    Alpha = 0;
  if (Alpha == _alpha)
    return;
  _alpha = Alpha;

//   if ((_alpha != 1) || (_color != 0x00ffffff)) {
//     [_ct autorelease];
//     _ct = [[FlashColorTransform alloc] initWithRedMultiplier:((float)( _color >> 16 )) / 255 greenMultiplier:((float)( _color >> 8 & 0xff )) / 255 blueMultiplier:((float)( _color & 0xff )) / 255 alphaMultiplier:_alpha];
//   } else {
//     [_ct autorelease];
//     _ct = nil;
//   }
  //update alpha
  _colors[3] = _colors[7] = _colors[11] = _colors[15] = (GLubyte)(_alpha*255);
  
  //as well as all other colors
  _colors[0] = _colors[4] = _colors[8] = _colors[12] = (GLubyte)(_alpha*red);
  _colors[1] = _colors[5] = _colors[9] = _colors[13] = (GLubyte)(_alpha*blue);
  _colors[2] = _colors[6] = _colors[10] = _colors[14] = (GLubyte)(_alpha*green);


  [self calcFrame];
}
- (unsigned int) color;
{
   return _color;
}
- (void) setColor:(unsigned int)Color;
{
  NSLog(@"setColor called!");
//   Color &= 0x00ffffff;
//   if (_color == Color)
//     return;
//   _color = Color;
//   if ((_alpha != 1) || (_color != 0x00ffffff)) {
//     [_ct autorelease];
//     _ct = [[FlashColorTransform alloc] initWithRedMultiplier:((float)( _color >> 16 )) / 255 greenMultiplier:((float)( _color >> 8 & 0xff )) / 255 blueMultiplier:((float)( _color & 0xff )) / 255 alphaMultiplier:_alpha];
//   }
//   else {
//     [_ct autorelease];
//     _ct = nil;
//   }
//   [self calcFrame];
}
- (void) draw:(FlxSprite *)Brush;
{
  [self drawWithParam1:Brush param2:0];
}
- (void) drawWithParam1:(FlxSprite *)Brush param2:(int)X;
{
  [self drawWithParam1:Brush param2:X param3:0];
}
- (void) drawWithParam1:(FlxSprite *)Brush param2:(int)X param3:(int)Y;
{

  //need to save away the following: glViewport, current frame buffer...
  //maybe more?

  //push new project matrix, but save the old one
  glMatrixMode(GL_PROJECTION);
  glPushMatrix();
  glLoadIdentity();
  glOrthof(0, width, height, 0, -1, 1);

  //back to model view
  glMatrixMode(GL_MODELVIEW);

  //save the old model view matrix, then push on a new one
  glPushMatrix();
  glLoadIdentity();

  //save away 
  int bx = Brush.x;
  int by = Brush.y;
  Brush.x = X + bx;
  Brush.y = Y + by;

  //set up the viewport
  glViewport(0,0,width,height);
  //render it!
  [Brush render];

  //restore the model view matrix
  glPopMatrix();

  //restore Brush
  Brush.x = bx;
  Brush.y = by;

  //restore the projection matrix
  glMatrixMode(GL_PROJECTION);
  glPopMatrix();

  //back to model view mode (presumed default)
  glMatrixMode(GL_MODELVIEW);

  //restore old viewport
  glViewport(FlxG.quake.x, FlxG.quake.y, FlxG.game.backingWidth, FlxG.game.backingHeight);

}


  //   FlashBitmapData * b = Brush._framePixels;
//   if (((Brush.angle == 0) || (Brush._bakedRotation > 0)) && (Brush.scale.x == 1) && (Brush.scale.y == 1) && (Brush.blend == nil))
//     {
//       _flashPoint.x = X;
//       _flashPoint.y = Y;
//       _flashRect2.width = b.width;
//       _flashRect2.height = b.height;
//       [_pixels copyPixelsWithParam1:b param2:_flashRect2 param3:_flashPoint param4:nil param5:nil param6:YES];
//       _flashRect2.width = _pixels.width;
//       _flashRect2.height = _pixels.height;
//       [self calcFrame];
//       return;
//     }
//   [_mtx identity];
//   [_mtx translateWithParam1:-Brush.origin.x param2:-Brush.origin.y];
//   [_mtx scaleWithParam1:Brush.scale.x param2:Brush.scale.y];
//   if (Brush.angle != 0)
//     [_mtx rotate:M_PI * 2 * (Brush.angle / 360)];
//   [_mtx translateWithParam1:X + Brush.origin.x param2:Y + Brush.origin.y];
//   [_pixels drawWithParam1:b param2:_mtx param3:nil param4:Brush.blend param5:nil param6:Brush.antialiasing];
//   [self calcFrame];
//}
- (void) fill:(unsigned int)Color;
{
//   useTextureVertexTexCoordData = NO;
  _bakedRotation = 0;
  [texture autorelease];
  texture = nil;

  red = (Color >> 16) & 0xff;
  green = (Color >> 8) & 0xff;
  blue = (Color >> 0) & 0xff;

  for (int i=0; i<4; ++i) {
    _colors[i*4] = red*_alpha;
    _colors[i*4+1] = green*_alpha;
    _colors[i*4+2] = blue*_alpha;
    _colors[i*4+3] = _alpha*255;
  }
   
  filled = YES;

}

- (void) updateAnimation;
{
  if (_bakedRotation)
    {
      unsigned int oc = _caf;
      _caf = fmod(angle,360) / _bakedRotation;
      if (oc != _caf)
 	[self calcFrame];
      return;
    }
  if ((_curAnim != nil) && (_curAnim.delay > 0) && (_curAnim.looped || !finished))
    {
      _frameTimer += FlxG.elapsed;
      while (_frameTimer > _curAnim.delay)
	{
	  _frameTimer -= _curAnim.delay;
	  if (_curFrame == _curAnim.frames.length - 1)
	    {
	      if (_curAnim.looped)
		_curFrame = 0;
	      finished = YES;
	    }
	  else
	    _curFrame++;
	  _caf = [[_curAnim.frames objectAtIndex:_curFrame] unsignedIntValue];
	  [self calcFrame];
	}
    }
}
- (void) update;
{
  [self updateMotion];
  [self updateAnimation];
  [self updateFlickering];
}

- (void) renderSprite;
{
  if (!self.visible)
    return;
  
  if (!enableBlend)
    glDisable(GL_BLEND);

  if (texture)
    [[self class] bind:texture.texture];
  else
    [[self class] unbind];

  CGPoint _point = [self getScreenXY];

  BOOL undoScreen = NO;
  if (blend && [blend isEqualToString:@"screen"]) {
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_COLOR);
    undoScreen = YES;
  }

  glPushMatrix();

  glTranslatef(_point.x, _point.y, 0);
  
  if (scale.x != 1 || scale.y != 1 || angle != 0 || _facing == LEFT) {
    glTranslatef(origin.x, origin.y, 0.0f);
    if (scale.x != 1 || scale.y != 1)
      glScalef(scale.x, scale.y, 1.0);
     if (angle != 0)
       glRotatef(angle, 0.0f, 0.0f, 1.0f);
     if (_facing == LEFT)
       glScalef(-1.0, 1.0, 1.0);
    glTranslatef(-origin.x, -origin.y, 0.0f);
  }

  if (_alpha != 1.0 || filled) {
    glEnableClientState(GL_COLOR_ARRAY);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, _colors);
  }

  glVertexPointer(2, GL_SHORT, sizeof(GLshort)*4, &(_verticesUVs[0]));
  if (texture)
    glTexCoordPointer(2, GL_SHORT, sizeof(GLshort)*4, &(_verticesUVs[2]));
  
  glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

  if (_alpha != 1.0 || filled)
    glDisableClientState(GL_COLOR_ARRAY);

  glPopMatrix();

  if (undoScreen)
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);

  if (!enableBlend)
    glEnable(GL_BLEND);
  
}

- (void) render;
{
   [self renderSprite];
}
- (BOOL) overlapsPointWithParam1:(float)X param2:(float)Y;
{
  return [self overlapsPointWithParam1:X param2:Y param3:NO];
}
- (BOOL) overlapsPointWithParam1:(float)X param2:(float)Y param3:(BOOL)PerPixel;
{
  X = X - [FlxU floor:FlxG.scroll.x];
  Y = Y - [FlxU floor:FlxG.scroll.y];
  CGPoint _point = [self getScreenXY];
  if (PerPixel) {
    NSLog(@"overlaps per pixel requested!");
    if ((X <= _point.x) || (X >= _point.x + frameWidth) || (Y <= _point.y) || (Y >= _point.y + frameHeight))
      return NO;
  }
    //     return [_framePixels hitTestWithParam1:[[[FlashPoint alloc] initWithX:0 y:0] autorelease] param2:0xFF param3:[[[FlashPoint alloc] initWithX:X - _point.x y:Y - _point.y] autorelease]];
  else
    if ((X <= _point.x) || (X >= _point.x + frameWidth) || (Y <= _point.y) || (Y >= _point.y + frameHeight))
      return NO;
  return YES;
}
- (void) addAnimation:(NSString *)Name frames:(NSMutableArray *)Frames;
{
   return [self addAnimation:Name frames:Frames frameRate:0];
}
- (void) addAnimation:(NSString *)Name frames:(NSMutableArray *)Frames frameRate:(float)FrameRate;
{
   return [self addAnimation:Name frames:Frames frameRate:FrameRate looped:YES];
}
- (void) addAnimation:(NSString *)Name frames:(NSMutableArray *)Frames frameRate:(float)FrameRate looped:(BOOL)Looped;
{
   [_animations push:[[(FlxAnim *)[FlxAnim alloc] initWithParam1:Name param2:Frames param3:FrameRate param4:Looped] autorelease]];
}
- (void) addAnimationCallback:(FlashFunction *)AnimationCallback;
{
  [_callback autorelease];
  _callback = [AnimationCallback retain];
}
- (void) play:(NSString *)AnimName;
{
  [self playWithParam1:AnimName param2:NO];
}
- (void) playWithParam1:(NSString *)AnimName param2:(BOOL)Force;
{
  if (!Force && (_curAnim != nil) && (AnimName == _curAnim.name))
    return;
  _curFrame = 0;
  _caf = 0;
  _frameTimer = 0;
  unsigned int al = _animations.length;
  for ( unsigned int i = 0; i < al; i++ )
    {
      if ([((FlxAnim *)[_animations objectAtIndex:i]).name compare:AnimName] == NSOrderedSame)
	{
	  [_curAnim autorelease];
	  _curAnim = [[_animations objectAtIndex:i] retain];
	  if (_curAnim.delay <= 0)
	    finished = YES;
	  else
	    finished = NO;
	  _caf = [[_curAnim.frames objectAtIndex:_curFrame] unsignedIntValue];
	  [self calcFrame];
	  return;
	}
    }
}
- (void) randomFrame;
{
  [_curAnim autorelease];
  _curAnim = nil;
  //_caf = ((int)( [FlxU random] * (_pixels.width / frameWidth) ));
  _caf = ((int)( [FlxU random] * (texture.size.width / frameWidth) ));
  [self calcFrame];
}
- (unsigned int) frame;
{
  return _caf;
}
- (void) setFrame:(unsigned int)Frame;
{
  [_curAnim autorelease];
  _curAnim = nil;
  _caf = Frame;
  [self calcFrame];
}
- (CGPoint) getScreenXY
{
  CGPoint Point;
  Point.x = floor(x + FlxU.roundingError) + floor(FlxG.scroll.x * scrollFactor.x) - offset.x;
  Point.y = floor(y + FlxU.roundingError) + floor(FlxG.scroll.y * scrollFactor.y) - offset.y;
  return Point;  
}
- (void) calcFrame;
{
  [self setupTexCoords];
}

@end
