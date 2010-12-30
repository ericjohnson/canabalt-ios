//
//  FlxU.h
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

// @class FlxQuadTree;
// @class FlxRect;
// @class FlashObject;

// FlxQuadTree * quadTree;
// FlxRect * quadTreeBounds;

@interface NSArray (LengthProperty)
@property(nonatomic,readonly) NSUInteger length;
- (NSUInteger) indexOf:(id)object;
- (id) randomObject;
@end

@interface NSMutableArray (AS3)
- (void) push:(id)object;
@end

@interface FlxU : NSObject
{
}
+ (void) setSeed:(float)seed;
+ (float) seed;
+ (float) roundingError;
// @property(nonatomic,assign) float seed;
// @property(nonatomic,assign,readonly) float roundingError;

+ (void) openURL:(NSString *)URL;
+ (float) abs:(float)N;
+ (float) floor:(float)N;
+ (float) ceil:(float)N;
+ (float) random;
+ (float) random:(BOOL)UseGlobalSeed;
+ (float) randomize:(float)Seed;
+ (float) mutateWithParam1:(float)Seed param2:(float)Mutator;
+ (CGPoint) rotatePointWithParam1:(float)X param2:(float)Y param3:(float)PivotX param4:(float)PivotY param5:(float)Angle;
+ (float) getAngleWithParam1:(float)X param2:(float)Y;
// + (NSString *) getClassName:(FlashObject *)Obj;
// + (NSString *) getClassNameWithParam1:(FlashObject *)Obj param2:(BOOL)Simple;
// + (Class) getClass:(NSString *)Name;
+ (float) computeVelocity:(float)Velocity;
+ (float) computeVelocityWithParam1:(float)Velocity param2:(float)Acceleration;
+ (float) computeVelocityWithParam1:(float)Velocity param2:(float)Acceleration param3:(float)Drag;
+ (float) computeVelocityWithParam1:(float)Velocity param2:(float)Acceleration param3:(float)Drag param4:(float)Max;
+ (void) setWorldBounds;
+ (void) setWorldBounds:(float)X;
+ (void) setWorldBoundsWithParam1:(float)X param2:(float)Y;
+ (void) setWorldBoundsWithParam1:(float)X param2:(float)Y param3:(float)Width;
+ (void) setWorldBoundsWithParam1:(float)X param2:(float)Y param3:(float)Width param4:(float)Height;
+ (BOOL) overlapWithParam1:(FlxObject *)Object1 param2:(FlxObject *)Object2;
+ (BOOL) overlapWithParam1:(FlxObject *)Object1 param2:(FlxObject *)Object2 target:(id)target action:(SEL)action;
+ (BOOL) collideWithParam1:(FlxObject *)Object1 param2:(FlxObject *)Object2;
+ (BOOL) alternateCollideWithParam1:(FlxObject *)Object1 param2:(FlxObject *)Object2;
+ (BOOL) collideObject:(FlxObject *)object withGroup:(FlxGroup *)group;
+ (BOOL) solveXCollisionWithParam1:(FlxObject *)Object1 param2:(FlxObject *)Object2;
+ (BOOL) solveYCollisionWithParam1:(FlxObject *)Object1 param2:(FlxObject *)Object2;

@end
