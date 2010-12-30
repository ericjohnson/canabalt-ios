//
//  FlxSound.h
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

@interface FlxSound : FlxObject
{
//    BOOL survive;
//    BOOL _init;
//    Sound * _sound;
//    SoundChannel * _channel;
//    SoundTransform * _transform;
//    float _position;
  float _volume;
  void * soundParameters;
  //    float _volumeAdjust;
//    BOOL _looped;
  FlxObject * _core;
  float _radius;
  BOOL _pan;
//    float _fadeOutTimer;
//    float _fadeOutTotal;
//    BOOL _pauseOnFadeOut;
//    float _fadeInTimer;
//    float _fadeInTotal;
//    FlxPoint * _point2;
}
// @property(nonatomic,assign) BOOL survive;
@property(nonatomic,assign) float volume;
- (id) init;
- (FlxSound *) loadEmbedded:(NSString *)EmbeddedSound;
- (FlxSound *) loadEmbeddedWithParam1:(NSString *)EmbeddedSound param2:(BOOL)Looped;
- (FlxSound *) loadStream:(NSString *)SoundURL;
- (FlxSound *) loadStreamWithParam1:(NSString *)SoundURL param2:(BOOL)Looped;
- (FlxSound *) proximityWithParam1:(float)X param2:(float)Y param3:(FlxObject *)Core param4:(float)Radius;
- (FlxSound *) proximityWithParam1:(float)X param2:(float)Y param3:(FlxObject *)Core param4:(float)Radius param5:(BOOL)Pan;
- (void) play;
- (void) pause;
- (void) stop;
- (void) fadeOut:(float)Seconds;
- (void) fadeOutWithParam1:(float)Seconds param2:(BOOL)PauseInstead;
- (void) fadeIn:(float)Seconds;
- (void) update;
- (void) destroy;
@end
