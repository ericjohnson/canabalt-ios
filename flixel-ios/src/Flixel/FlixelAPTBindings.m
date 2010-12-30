//
//  FlixelAPTBindings.m
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


@implementation FlxQuake (FlxAPTBindings)
- (id) initWithParam1:(unsigned int)Zoom
{
  return [self initWithZoom:Zoom];
}
- (void) startWithParam1:(float)Intensity param2:(float)Duration;
{
  [self startWithIntensity:Intensity duration:Duration];
}
@end

@implementation FlxSprite (FlxAPTBindings)
- (FlxSprite *) loadGraphicWithParam1:(NSString *)Graphic param2:(BOOL)Animated;
{
  return [self loadGraphic:Graphic animated:Animated];
}
- (FlxSprite *) loadGraphicWithParam1:(NSString *)Graphic param2:(BOOL)Animated param3:(BOOL)Reverse;
{
  return [self loadGraphic:Graphic animated:Animated reverse:Reverse];
}
- (FlxSprite *) loadGraphicWithParam1:(NSString *)Graphic param2:(BOOL)Animated param3:(BOOL)Reverse param4:(unsigned int)Width;
{
  return [self loadGraphic:Graphic animated:Animated reverse:Reverse width:Width];
}
- (FlxSprite *) loadGraphicWithParam1:(NSString *)Graphic param2:(BOOL)Animated param3:(BOOL)Reverse param4:(unsigned int)Width param5:(unsigned int)Height;
{
  return [self loadGraphic:Graphic animated:Animated reverse:Reverse width:Width height:Height];
}
- (FlxSprite *) loadGraphicWithParam1:(NSString *)Graphic param2:(BOOL)Animated param3:(BOOL)Reverse param4:(unsigned int)Width param5:(unsigned int)Height param6:(BOOL)Unique;
{
  return [self loadGraphic:Graphic animated:Animated reverse:Reverse width:Width height:Height unique:Unique];
}

- (void) addAnimationWithParam1:(NSString *)Name param2:(NSMutableArray *)Frames;
{
  [self addAnimation:Name frames:Frames];
}
- (void) addAnimationWithParam1:(NSString *)Name param2:(NSMutableArray *)Frames param3:(float)FrameRate;
{
  [self addAnimation:Name frames:Frames frameRate:FrameRate];
}
- (void) addAnimationWithParam1:(NSString *)Name param2:(NSMutableArray *)Frames param3:(float)FrameRate param4:(BOOL)Looped;
{
  [self addAnimation:Name frames:Frames frameRate:FrameRate looped:Looped];
}
- (FlxSprite *) createGraphicWithParam1:(unsigned int)Width param2:(unsigned int)Height;
{
  return [self createGraphicWithWidth:Width height:Height];
}
- (FlxSprite *) createGraphicWithParam1:(unsigned int)Width param2:(unsigned int)Height param3:(unsigned int)Color;
{
  return [self createGraphicWithWidth:Width height:Height color:Color];
}
- (FlxSprite *) createGraphicWithParam1:(unsigned int)Width param2:(unsigned int)Height param3:(unsigned int)Color param4:(BOOL)Unique;
{
  return [self createGraphicWithWidth:Width height:Height color:Color unique:Unique];
}
- (FlxSprite *) createGraphicWithParam1:(unsigned int)Width param2:(unsigned int)Height param3:(unsigned int)Color param4:(BOOL)Unique param5:(NSString *)Key;
{
  return [self createGraphicWithWidth:Width height:Height color:Color unique:Unique key:Key];
}


- (FlxSprite *) loadRotatedGraphicWithParam1:(NSString *)Graphic param2:(unsigned int)Rotations;
{
  return [self loadRotatedGraphic:Graphic rotations:Rotations];
}
- (FlxSprite *) loadRotatedGraphicWithParam1:(NSString *)Graphic param2:(unsigned int)Rotations param3:(int)Frame;
{
  return [self loadRotatedGraphic:Graphic rotations:Rotations frame:Frame];
}
- (FlxSprite *) loadRotatedGraphicWithParam1:(NSString *)Graphic param2:(unsigned int)Rotations param3:(int)Frame param4:(BOOL)AntiAliasing;
{
  return [self loadRotatedGraphic:Graphic rotations:Rotations frame:Frame antiAliasing:AntiAliasing];
}
- (FlxSprite *) loadRotatedGraphicWithParam1:(NSString *)Graphic param2:(unsigned int)Rotations param3:(int)Frame param4:(BOOL)AntiAliasing param5:(BOOL)AutoBuffer;
{
  return [self loadRotatedGraphic:Graphic rotations:Rotations frame:Frame antiAliasing:AntiAliasing autoBuffer:AutoBuffer];
}
@end

@implementation FlxEmitter (FlxAPTBindings)
- (FlxEmitter *) createSpritesWithParam1:(NSString *)Graphics param2:(unsigned int)Quantity;
{
  return [self createSprites:Graphics quantity:Quantity];
}
- (FlxEmitter *) createSpritesWithParam1:(NSString *)Graphics param2:(unsigned int)Quantity param3:(unsigned int)BakedRotations;
{
  return [self createSprites:Graphics quantity:Quantity bakedRotations:BakedRotations];
}
- (FlxEmitter *) createSpritesWithParam1:(NSString *)Graphics param2:(unsigned int)Quantity param3:(unsigned int)BakedRotations param4:(BOOL)Multiple;
{
  return [self createSprites:Graphics quantity:Quantity bakedRotations:BakedRotations multiple:Multiple];
}
- (FlxEmitter *) createSpritesWithParam1:(NSString *)Graphics param2:(unsigned int)Quantity param3:(unsigned int)BakedRotations param4:(BOOL)Multiple param5:(float)Collide;
{
  return [self createSprites:Graphics quantity:Quantity bakedRotations:BakedRotations multiple:Multiple collide:Collide];
}
@end
