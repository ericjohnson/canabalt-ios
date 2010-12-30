//
//  FlxEmitter.h
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

#import <Flixel/FlxGroup.h>


@interface FlxEmitter : FlxGroup
{
  CGPoint minParticleSpeed;
  CGPoint maxParticleSpeed;
  CGPoint particleDrag;
  float minRotation;
  float maxRotation;
  float gravity;
  BOOL on;
  float delay;
  unsigned int quantity;
  BOOL _explode;
  float _timer;
  unsigned int _particle;
  unsigned int _counter;
}
@property(nonatomic,assign) unsigned int quantity;
@property(nonatomic,assign) BOOL on;
@property(nonatomic,assign) float gravity;
@property(nonatomic,assign) CGPoint minParticleSpeed;
@property(nonatomic,assign) float minRotation;
@property(nonatomic,assign) CGPoint maxParticleSpeed;
@property(nonatomic,assign) float delay;
@property(nonatomic,assign) float maxRotation;
@property(nonatomic,assign) CGPoint particleDrag;
- (id) initWithX:(float)X y:(float)Y;
- (FlxEmitter *) createSprites:(NSString *)Graphics;
- (FlxEmitter *) createSprites:(NSString *)Graphics quantity:(unsigned int)Quantity;
- (FlxEmitter *) createSprites:(NSString *)Graphics quantity:(unsigned int)Quantity bakedRotations:(unsigned int)BakedRotations;
- (FlxEmitter *) createSprites:(NSString *)Graphics quantity:(unsigned int)Quantity bakedRotations:(unsigned int)BakedRotations multiple:(BOOL)Multiple;
- (FlxEmitter *) createSprites:(NSString *)Graphics quantity:(unsigned int)Quantity bakedRotations:(unsigned int)BakedRotations multiple:(BOOL)Multiple collide:(float)Collide;
- (FlxEmitter *) createSprites:(NSString *)Graphics quantity:(unsigned int)Quantity bakedRotations:(unsigned int)BakedRotations multiple:(BOOL)Multiple collide:(float)Collide modelScale:(float)ModelScale;
- (FlxEmitter *) createSprites:(NSString *)Graphics quantity:(unsigned int)Quantity bakedRotations:(unsigned int)BakedRotations multiple:(BOOL)Multiple modelScale:(float)ModelScale;
- (FlxEmitter *) createSprites:(NSString *)Graphics quantity:(unsigned int)Quantity bakedRotations:(unsigned int)BakedRotations modelScale:(float)ModelScale;
- (void) setSizeWithParam1:(unsigned int)Width param2:(unsigned int)Height;
- (void) setXSpeed;
- (void) setXSpeed:(float)Min;
- (void) setXSpeedWithParam1:(float)Min param2:(float)Max;
- (void) setYSpeed;
- (void) setYSpeed:(float)Min;
- (void) setYSpeedWithParam1:(float)Min param2:(float)Max;
- (void) setRotation;
- (void) setRotation:(float)Min;
- (void) setRotationWithParam1:(float)Min param2:(float)Max;
- (void) update;
- (void) start;
- (void) start:(BOOL)Explode;
- (void) startWithParam1:(BOOL)Explode param2:(float)Delay;
- (void) startWithParam1:(BOOL)Explode param2:(float)Delay param3:(unsigned int)Quantity;
- (void) emitParticle;
- (void) stop;
- (void) stop:(float)Delay;
- (void) at:(FlxObject *)Object;
- (void) kill;
@end
