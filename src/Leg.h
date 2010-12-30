//
//  Leg.h
//  Canabalt
//
//  Copyright Semi Secret Software 2009-2010. All rights reserved.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <Foundation/Foundation.h>

@class Player;
@class Sequence;

@interface Leg : FlxSprite
{
  CGFloat myY;
  Player * p;
  FlxEmitter * e;
  NSArray * en;
  Sequence * s;
  FlxSprite * top;
}

+ (id) legWithOrigin:(CGPoint)origin player:(Player *)player sequence:(Sequence *)sequence;
- (id) initWithOrigin:(CGPoint)origin player:(Player *)player sequence:(Sequence *)sequence;

- (void) add:(FlxEmitter *)gibs;

@end
