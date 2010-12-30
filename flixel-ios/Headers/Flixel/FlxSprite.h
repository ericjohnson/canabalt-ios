//
//  FlxSprite.h
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

const unsigned int LEFT;
const unsigned int RIGHT;
const unsigned int UP;
const unsigned int DOWN;

@class FlashFunction;
@class SemiSecretTexture;
@class FlxAnim;


@interface FlxSprite : FlxObject
{
  CGPoint offset;
  CGPoint scale;
  NSString * blend;
  BOOL antialiasing;
  BOOL finished;
//   unsigned int frameWidth;
//   unsigned int frameHeight;
  float frameWidth;
  float frameHeight;
  NSMutableArray * _animations;
  unsigned int _flipped;
  FlxAnim * _curAnim;
  unsigned int _curFrame;
  unsigned int _caf;
  float _frameTimer;
  FlashFunction * _callback;
  unsigned int _facing;
  float _bakedRotation;
//   FlashRectangle * _flashRect;
//   FlashRectangle * _flashRect2;
//   FlashPoint * _flashPointZero;
  SemiSecretTexture * texture;
  float _alpha;
  unsigned int _color;
  //FlashMatrix * _mtx;
  //
  GLubyte red;
  GLubyte green;
  GLubyte blue;
  GLubyte _colors[4*4];
  GLshort _verticesUVs[4*2+4*2];
  GLshort _uShort;
  GLshort _vShort;
  GLshort _uOffset;
  GLshort _vOffset;
  BOOL filled;
  BOOL useTextureVertexTexCoordData;
  float modelScale;
}
@property(nonatomic,assign) CGPoint scale;
@property(nonatomic,copy) NSString * blend;
@property(nonatomic,assign) unsigned int facing;
//@property(nonatomic,assign) unsigned int frameWidth;
@property(nonatomic,assign) float frameWidth;
@property(nonatomic,assign) unsigned int frame;
@property(nonatomic,assign) unsigned int color;
@property(nonatomic,assign) CGPoint offset;
@property(nonatomic,assign) float alpha;
@property(nonatomic,assign) BOOL antialiasing;
//@property(nonatomic,assign) unsigned int frameHeight;
@property(nonatomic,assign) float frameHeight;
@property(nonatomic,assign) BOOL finished;
+ (unsigned int) LEFT;
+ (unsigned int) RIGHT;
+ (unsigned int) UP;
+ (unsigned int) DOWN;
// - (id) init;
// - (id) initWithX:(float)X;
// - (id) initWithX:(float)X y:(float)Y;
+ (id) spriteWithGraphic:(NSString *)SimpleGraphic;
+ (id) spriteWithX:(float)X y:(float)Y graphic:(NSString *)SimpleGraphic;
- (id) initWithX:(float)X y:(float)Y graphic:(NSString *)SimpleGraphic;
- (id) initWithX:(float)X y:(float)Y graphic:(NSString *)SimpleGraphic modelScale:(float)ModelScale;
- (FlxSprite *) loadGraphic:(NSString *)Graphic;
- (FlxSprite *) loadGraphic:(NSString *)Graphic animated:(BOOL)Animated;
- (FlxSprite *) loadGraphic:(NSString *)Graphic animated:(BOOL)Animated reverse:(BOOL)Reverse;
- (FlxSprite *) loadGraphic:(NSString *)Graphic animated:(BOOL)Animated reverse:(BOOL)Reverse width:(unsigned int)Width;
- (FlxSprite *) loadGraphic:(NSString *)Graphic animated:(BOOL)Animated reverse:(BOOL)Reverse width:(unsigned int)Width height:(unsigned int)Height;
- (FlxSprite *) loadGraphic:(NSString *)Graphic animated:(BOOL)Animated reverse:(BOOL)Reverse width:(unsigned int)Width height:(unsigned int)Height unique:(BOOL)Unique;
- (FlxSprite *) loadGraphic:(NSString *)Graphic animated:(BOOL)Animated reverse:(BOOL)Reverse width:(unsigned int)Width height:(unsigned int)Height unique:(BOOL)Unique modelScale:(float)ModelScale;

- (FlxSprite *) loadGraphic:(NSString *)Graphic modelScale:(float)ModelScale;
- (FlxSprite *) loadGraphic:(NSString *)Graphic animated:(BOOL)Animated modelScale:(float)ModelScale;
- (FlxSprite *) loadGraphic:(NSString *)Graphic animated:(BOOL)Animated reverse:(BOOL)Reverse modelScale:(float)ModelScale;

- (FlxSprite *) loadRotatedGraphic:(NSString *)Graphic;
- (FlxSprite *) loadRotatedGraphic:(NSString *)Graphic rotations:(unsigned int)Rotations;
- (FlxSprite *) loadRotatedGraphic:(NSString *)Graphic rotations:(unsigned int)Rotations frame:(int)Frame;
- (FlxSprite *) loadRotatedGraphic:(NSString *)Graphic rotations:(unsigned int)Rotations frame:(int)Frame antiAliasing:(BOOL)AntiAliasing;
- (FlxSprite *) loadRotatedGraphic:(NSString *)Graphic rotations:(unsigned int)Rotations frame:(int)Frame antiAliasing:(BOOL)AntiAliasing autoBuffer:(BOOL)AutoBuffer;
- (FlxSprite *) loadRotatedGraphic:(NSString *)Graphic rotations:(unsigned int)Rotations modelScale:(float)ModelScale;
- (FlxSprite *) loadRotatedGraphic:(NSString *)Graphic rotations:(unsigned int)Rotations frame:(int)Frame modelScale:(float)ModelScale;
- (FlxSprite *) loadRotatedGraphic:(NSString *)Graphic rotations:(unsigned int)Rotations frame:(int)Frame antiAliasing:(BOOL)AntiAliasing autoBuffer:(BOOL)AutoBuffer modelScale:(float)ModelScale;
- (FlxSprite *) createGraphicWithWidth:(unsigned int)Width height:(unsigned int)Height;
- (FlxSprite *) createGraphicWithWidth:(unsigned int)Width height:(unsigned int)Height color:(unsigned int)Color;
- (FlxSprite *) createGraphicWithWidth:(unsigned int)Width height:(unsigned int)Height color:(unsigned int)Color unique:(BOOL)Unique;
- (FlxSprite *) createGraphicWithWidth:(unsigned int)Width height:(unsigned int)Height color:(unsigned int)Color unique:(BOOL)Unique key:(NSString *)Key;
- (void) draw:(FlxSprite *)Brush;
- (void) drawWithParam1:(FlxSprite *)Brush param2:(int)X;
- (void) drawWithParam1:(FlxSprite *)Brush param2:(int)X param3:(int)Y;
- (void) fill:(unsigned int)Color;
- (void) update;
- (void) render;
- (BOOL) overlapsPointWithParam1:(float)X param2:(float)Y;
- (BOOL) overlapsPointWithParam1:(float)X param2:(float)Y param3:(BOOL)PerPixel;
- (void) addAnimation:(NSString *)Name frames:(NSMutableArray *)Frames;
- (void) addAnimation:(NSString *)Name frames:(NSMutableArray *)Frames frameRate:(float)FrameRate;
- (void) addAnimation:(NSString *)Name frames:(NSMutableArray *)Frames frameRate:(float)FrameRate looped:(BOOL)Looped;
- (void) addAnimationCallback:(FlashFunction *)AnimationCallback;
- (void) play:(NSString *)AnimName;
- (void) playWithParam1:(NSString *)AnimName param2:(BOOL)Force;
- (void) randomFrame;
@end
