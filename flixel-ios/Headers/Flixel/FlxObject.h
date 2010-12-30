//
//  FlxObject.h
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

#import <Flixel/FlxRect.h>

@interface FlxObject : FlxRect <NSCopying>
{
  BOOL exists;
  BOOL active;
  BOOL visible;
  BOOL solid;
  BOOL fixed;
  CGPoint velocity;
  CGPoint acceleration;
  CGPoint drag;
  CGPoint maxVelocity;
  float angle;
  float angularVelocity;
  float angularAcceleration;
  float angularDrag;
  float maxAngular;
  CGPoint origin;
  float thrust;
  float maxThrust;
  CGPoint scrollFactor;
  BOOL _flicker;
  float _flickerTimer;
  float health;
  BOOL dead;
//   FlxPoint * _point;
//   FlxRect * _rect;
//   FlashPoint * _flashPoint;
  BOOL moves;
  CGRect colHullX;
  CGRect colHullY;
  CGPoint colVector;
  NSMutableArray * colOffsets;
  BOOL _group;
  BOOL onFloor;
  BOOL collideLeft;
  BOOL collideRight;
  BOOL collideTop;
  BOOL collideBottom;
  BOOL debug;
  BOOL enableBlend;
}
@property(nonatomic,assign) BOOL enableBlend;
@property(nonatomic,assign) BOOL collideTop;
@property(nonatomic,assign) float maxAngular;
@property(nonatomic,assign) float angularDrag;
@property(nonatomic,assign) BOOL collideLeft;
@property(nonatomic,assign) BOOL active;
@property(nonatomic,assign) float health;
@property(nonatomic,assign) BOOL solid;
@property(nonatomic,assign) BOOL collideRight;
@property(nonatomic,assign) float angularVelocity;
@property(nonatomic,assign) BOOL dead;
@property(nonatomic,assign) CGPoint colVector;
@property(nonatomic,assign) BOOL onFloor;
@property(nonatomic,assign) BOOL collideBottom;
@property(nonatomic,assign) float angle;
@property(nonatomic,assign) CGPoint velocity;
@property(nonatomic,assign) float thrust;
@property(nonatomic,assign) CGPoint origin;
@property(nonatomic,assign) BOOL moves;
@property(nonatomic,assign) float angularAcceleration;
@property(nonatomic,assign) BOOL exists;
@property(nonatomic,assign) CGRect colHullX;
@property(nonatomic,assign) CGPoint acceleration;
@property(nonatomic,assign) CGPoint scrollFactor;
@property(nonatomic,assign) CGPoint drag;
@property(nonatomic,assign) float maxThrust;
@property(nonatomic,assign) BOOL fixed;
@property(nonatomic,assign) CGRect colHullY;
@property(nonatomic,assign) CGPoint maxVelocity;
@property(nonatomic,assign) BOOL visible;
@property(nonatomic,copy) NSMutableArray * colOffsets;
@property(nonatomic,assign) BOOL debug;
// - (id) init;
// - (id) initWithParam1:(float)X;
// - (id) initWithParam1:(float)X param2:(float)Y;
// - (id) initWithParam1:(float)X param2:(float)Y param3:(float)Width;
// - (id) initWithParam1:(float)X param2:(float)Y param3:(float)Width param4:(float)Height;
- (id) initWithX:(float)X y:(float)y width:(float)width height:(float)height;
- (void) destroy;
- (void) refreshHulls;
- (void) update;
- (void) render;
- (BOOL) overlaps:(FlxObject *)Object;
- (BOOL) overlapsPointWithParam1:(float)X param2:(float)Y;
- (BOOL) overlapsPointWithParam1:(float)X param2:(float)Y param3:(BOOL)PerPixel;
- (BOOL) collide;
- (BOOL) collide:(FlxObject *)Object;
- (void) preCollide:(FlxObject *)Object;
// - (void) hitLeftAgainstObject:(FlxObject *)Contact withVelocity:(float)Velocity;
// - (void) hitRightAgainstObject:(FlxObject *)Contact withVelocity:(float)Velocity;
// - (void) hitTopAgainstObject:(FlxObject *)Contact withVelocity:(float)Velocity;
// - (void) hitBottomAgainstObject:(FlxObject *)Contact withVelocity:(float)Velocity;
- (void) hitLeftWithParam1:(FlxObject *)Contact param2:(float)Velocity;
- (void) hitRightWithParam1:(FlxObject *)Contact param2:(float)Velocity;
- (void) hitTopWithParam1:(FlxObject *)Contact param2:(float)Velocity;
- (void) hitBottomWithParam1:(FlxObject *)Contact param2:(float)Velocity;
- (void) hurt:(float)Damage;
- (void) kill;
- (void) flicker;
- (void) flicker:(float)Duration;
- (BOOL) flickering;
- (CGPoint) getScreenXY;
- (BOOL) onScreen;
- (void) resetWithParam1:(float)X param2:(float)Y;
//protected in actionscript, can't be in objective-c
- (void) updateMotion;
- (void) updateFlickering;
+ (void) bind:(GLuint)texture;
+ (void) unbind;
- (void) onEmit;
@end
