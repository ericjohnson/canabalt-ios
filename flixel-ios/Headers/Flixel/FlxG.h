//
//  FlxG.h
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

#import <AVFoundation/AVFoundation.h>
#import <OpenAL/alc.h>

@class FlxG;

@class FlxObject;
@class FlxPoint;
@class FlashPoint;
@class FlxQuake;
@class FlxFlash;
@class FlxFade;
@class FlxSound;
@class FlxState;
@class FlxGame;
@class FlxTouches;

@interface NSArray (IntArray)
+ (NSArray *) intArrayWithSize:(NSUInteger)size ints:(int)first, ...;
@end

@interface NSMutableArray (IntArray)
+ (NSMutableArray *) intArrayWithSize:(NSUInteger)size ints:(int)first, ...;
@end



@interface FlxG : NSObject
{
}

+ (void) setMusic:(FlxSound *)music;
+ (FlxSound *) music;
+ (void) setQuake:(FlxQuake *)quake;
+ (FlxQuake *) quake;
+ (void) setLevel:(int)level;
+ (int) level;
+ (void) setState:(FlxState *)state;
+ (FlxState *) state;
+ (void) setElapsed:(float)elapsed;
+ (float) elapsed;
+ (void) setMaxElapsed:(float)maxElapsed;
+ (float) maxElapsed;
+ (void) setScroll:(FlashPoint *)scroll;
+ (FlashPoint *) scroll;
+ (void) setScore:(int)score;
+ (int) score;
+ (void) setFlash:(FlxFlash *)flash;
+ (FlxFlash *) flash;
+ (void) setLevels:(NSMutableArray *)levels;
+ (NSMutableArray *) levels;
+ (void) setFade:(FlxFade *)fade;
+ (FlxFade *) fade;
+ (void) setHeight:(int)height;
+ (int) height;
+ (void) setTimeScale:(float)timeScale;
+ (float) timeScale;
+ (FlxTouches *) touches;
+ (void) setScores:(NSMutableArray *)scores;
+ (NSMutableArray *) scores;
+ (void) setWidth:(int)width;
+ (int) width;
//+ (void) setGame:(FlxGame *)game;
+ (FlxGame *) game;

+ (void) setPauseFollow:(BOOL)pauseFollow;
+ (BOOL) pauseFollow;

+ (BOOL) iPad;
+ (BOOL) retinaDisplay;
+ (BOOL) iPhone1G;
+ (BOOL) iPhone3G;
+ (BOOL) iPhone3GS;
+ (BOOL) iPodTouch1G;
+ (BOOL) iPodTouch2G;
+ (BOOL) iPodTouch3G;

+ (void) loadTextureAtlas;
+ (BOOL) groupIntoTextureAtlas:(NSArray *)images;
+ (BOOL) groupIntoTextureAtlas:(NSArray *)images ofSize:(CGSize)size;
+ (void) groupIntoTextureAtlases:(NSArray *)images ofSize:(CGSize)size;

+ (void) log:(NSString *)Data;
+ (void) playMusic:(NSString *)Music;
+ (void) playMusicWithParam1:(NSString *)Music param2:(float)Volume;
+ (BOOL) isOtherMusicPlaying;
+ (void) fadeOutMusic:(float)duration;
+ (void) pauseMusic;
+ (void) unpauseMusic;
+ (void) loadSound:(NSString *)filename;
+ (FlxSound *) play:(NSString *)EmbeddedSound;
+ (FlxSound *) playWithParam1:(NSString *)EmbeddedSound param2:(float)Volume;
+ (FlxSound *) playWithParam1:(NSString *)EmbeddedSound param2:(float)Volume param3:(BOOL)Looped;
+ (FlxSound *) play:(NSString *)EmbeddedSound withVolume:(float)Volume;
+ (FlxSound *) play:(NSString *)EmbeddedSound withVolume:(float)Volume looped:(BOOL)Looped;
+ (BOOL) playing:(NSString *)EmbeddedSound;
+ (void) stop:(NSString *)EmbeddedSound;
+ (void) vibrate;
+ (BOOL) checkBitmapCache:(NSString *)Key;
+ (SemiSecretTexture *) addTextureWithParam1:(NSString *)Graphic param2:(BOOL)Unique;
+ (SemiSecretTexture *) createBitmapWithParam1:(unsigned int)Width param2:(unsigned int)Height param3:(unsigned int)Color param4:(BOOL)Unique param5:(NSString *)Key;
+ (void) clearTextureCache;

+ (void) setTexture:(SemiSecretTexture *)Texture forKey:(NSString *)Key;

+ (void) updateSounds;

+ (void) follow:(FlxObject *)Target;
+ (void) followWithParam1:(FlxObject *)Target param2:(float)Lerp;
+ (void) followAdjust;
+ (void) followAdjust:(float)LeadX;
+ (void) followAdjustWithParam1:(float)LeadX param2:(float)LeadY;
+ (void) followBounds;
+ (void) followBounds:(int)MinX;
+ (void) followBoundsWithParam1:(int)MinX param2:(int)MinY;
+ (void) followBoundsWithParam1:(int)MinX param2:(int)MinY param3:(int)MaxX;
+ (void) followBoundsWithParam1:(int)MinX param2:(int)MinY param3:(int)MaxX param4:(int)MaxY;
+ (void) followBoundsWithParam1:(int)MinX param2:(int)MinY param3:(int)MaxX param4:(int)MaxY param5:(BOOL)UpdateWorldBounds;

+ (void) didEnterBackground;
+ (void) willEnterForeground;
+ (void) willResignActive;
+ (void) didBecomeActive;

+ (CGFloat) screenScale;

@end
