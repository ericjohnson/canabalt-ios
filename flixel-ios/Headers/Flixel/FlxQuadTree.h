//
//  FlxQuadTree.h
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

@class FlxList;
@class FlashFunction;

@interface FlxQuadTree : FlxRect
{
  BOOL _canSubdivide;
  FlxList * _headA;
  FlxList * _tailA;
  FlxList * _headB;
  FlxList * _tailB;
  FlxQuadTree * _nw;
  FlxQuadTree * _ne;
  FlxQuadTree * _se;
  FlxQuadTree * _sw;
  float _l;
  float _r;
  float _t;
  float _b;
  float _hw;
  float _hh;
  float _mx;
  float _my;
  void * poolEntry;
  int poolRetainCount;
  id target;
  SEL action;
}
- (id) initWithX:(float)X y:(float)Y width:(float)Width height:(float)Height;
- (id) initWithX:(float)X y:(float)Y width:(float)Width height:(float)Height parent:(FlxQuadTree *)Parent;
- (void) addWithParam1:(FlxObject *)Object param2:(unsigned int)List;
- (BOOL) overlap;
- (BOOL) overlap:(BOOL)BothLists;
//- (BOOL) overlapWithParam1:(BOOL)BothLists param2:(FlashFunction *)Callback;
- (BOOL) overlapWithParam1:(BOOL)BothLists target:(id)target action:(SEL)action;

// begin manually added for 'prettiness'
- (void) addObject:(FlxObject *)Object list:(unsigned int)List;
// - (BOOL) overlapBothLists:(BOOL)BothLists callback:(FlashFunction *)Callback;
- (BOOL) overlapBothLists:(BOOL)BothLists target:(id)target action:(SEL)action;
// end manually added

+ (float) MIN;
+ (unsigned int) A_LIST;
+ (unsigned int) B_LIST;

@end
