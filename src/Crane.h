//
//  Crane.h
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

@class CraneTrigger;
@class CBlock;
@class Player;

@interface Crane : FlxObject
{
  CraneTrigger * trigger;
  CBlock * beam;
  FlxTileblock * post;
  FlxSprite * counterweight;
  FlxSprite * cabin;
  FlxSprite * pulley;
  FlxSprite * antenna1;
  FlxSprite * antenna2;
  FlxSprite * antenna3;
}
- (id) initWithMaxWidth:(float)maxWidth;
- (void) createWithX:(float)X y:(float)Y width:(float)Width height:(float)Height player:(Player *)player;
@property (nonatomic,readonly) CraneTrigger * trigger;
@end
