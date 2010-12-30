//
//  FlixelAPTBindings.h
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

@interface FlxQuake (FlxAPTBindings)
- (id) initWithParam1:(unsigned int)Zoom;
- (void) startWithParam1:(float)Intensity param2:(float)Duration;
@end

@interface FlxSprite (FlxAPTBindings)
- (void) addAnimationWithParam1:(NSString *)Name param2:(NSMutableArray *)Frames;
- (void) addAnimationWithParam1:(NSString *)Name param2:(NSMutableArray *)Frames param3:(float)FrameRate;
- (void) addAnimationWithParam1:(NSString *)Name param2:(NSMutableArray *)Frames param3:(float)FrameRate param4:(BOOL)Looped;
- (FlxSprite *) createGraphicWithParam1:(unsigned int)Width param2:(unsigned int)Height;
- (FlxSprite *) createGraphicWithParam1:(unsigned int)Width param2:(unsigned int)Height param3:(unsigned int)Color;
- (FlxSprite *) createGraphicWithParam1:(unsigned int)Width param2:(unsigned int)Height param3:(unsigned int)Color param4:(BOOL)Unique;
- (FlxSprite *) createGraphicWithParam1:(unsigned int)Width param2:(unsigned int)Height param3:(unsigned int)Color param4:(BOOL)Unique param5:(NSString *)Key;

- (FlxSprite *) loadGraphicWithParam1:(NSString *)Graphic param2:(BOOL)Animated;
- (FlxSprite *) loadGraphicWithParam1:(NSString *)Graphic param2:(BOOL)Animated param3:(BOOL)Reverse;
- (FlxSprite *) loadGraphicWithParam1:(NSString *)Graphic param2:(BOOL)Animated param3:(BOOL)Reverse param4:(unsigned int)Width;
- (FlxSprite *) loadGraphicWithParam1:(NSString *)Graphic param2:(BOOL)Animated param3:(BOOL)Reverse param4:(unsigned int)Width param5:(unsigned int)Height;
- (FlxSprite *) loadGraphicWithParam1:(NSString *)Graphic param2:(BOOL)Animated param3:(BOOL)Reverse param4:(unsigned int)Width param5:(unsigned int)Height param6:(BOOL)Unique;

- (FlxSprite *) loadRotatedGraphicWithParam1:(NSString *)Graphic param2:(unsigned int)Rotations;
- (FlxSprite *) loadRotatedGraphicWithParam1:(NSString *)Graphic param2:(unsigned int)Rotations param3:(int)Frame;
- (FlxSprite *) loadRotatedGraphicWithParam1:(NSString *)Graphic param2:(unsigned int)Rotations param3:(int)Frame param4:(BOOL)AntiAliasing;
- (FlxSprite *) loadRotatedGraphicWithParam1:(NSString *)Graphic param2:(unsigned int)Rotations param3:(int)Frame param4:(BOOL)AntiAliasing param5:(BOOL)AutoBuffer;
@end

@interface FlxEmitter (FlxAPTBindings)
- (FlxEmitter *) createSpritesWithParam1:(NSString *)Graphics param2:(unsigned int)Quantity;
- (FlxEmitter *) createSpritesWithParam1:(NSString *)Graphics param2:(unsigned int)Quantity param3:(unsigned int)BakedRotations;
- (FlxEmitter *) createSpritesWithParam1:(NSString *)Graphics param2:(unsigned int)Quantity param3:(unsigned int)BakedRotations param4:(BOOL)Multiple;
- (FlxEmitter *) createSpritesWithParam1:(NSString *)Graphics param2:(unsigned int)Quantity param3:(unsigned int)BakedRotations param4:(BOOL)Multiple param5:(float)Collide;
@end
