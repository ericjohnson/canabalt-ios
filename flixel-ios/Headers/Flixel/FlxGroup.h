//
//  FlxGroup.h
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

@class FlxStaticBuckets;

@interface FlxGroup : FlxObject
{
  NSMutableArray * members;
  CGPoint _last;
  BOOL _first;
}
@property(nonatomic,copy) NSMutableArray * members;
// - (id) init;
- (FlxObject *) add:(FlxObject *)Object;
- (FlxObject *) addWithParam1:(FlxObject *)Object param2:(BOOL)ShareScroll;
- (FlxObject *) replaceWithParam1:(FlxObject *)OldObject param2:(FlxObject *)NewObject;
- (FlxObject *) replaceObjectAtIndex:(unsigned int)index withObject:(FlxObject *)object;
- (FlxObject *) remove:(FlxObject *)Object;
- (FlxObject *) getFirstAvail;
- (BOOL) resetFirstAvail;
- (BOOL) resetFirstAvail:(float)X;
- (BOOL) resetFirstAvailWithParam1:(float)X param2:(float)Y;
- (FlxObject *) getFirstExtant;
- (FlxObject *) getFirstAlive;
- (FlxObject *) getFirstDead;
- (int) countLiving;
- (int) countDead;
- (FlxObject *) getRandom;
- (void) update;
- (void) render;
- (void) kill;
- (void) destroy;
- (void) resetWithParam1:(float)X param2:(float)Y;
- (void) removeAllObjects;
@end
