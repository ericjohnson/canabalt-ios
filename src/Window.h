//
//  Window.h
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


@class Player;

extern const CGFloat WindowW;

@interface Window : FlxSprite
{
  FlxEmitter * shards;
  Player * player;
}

+ (id) windowAtPoint:(CGPoint)point
	      height:(CGFloat)height
	       group:(FlxGroup *)group
	      player:(Player *)plr
	      shards:(FlxEmitter *)glassShards;
//shards:(NSArray *)glassShards;
- (id) initAtPoint:(CGPoint)point
	    height:(CGFloat)height
	     group:(FlxGroup *)group
	    player:(Player *)plr
	    shards:(FlxEmitter *)glassShards;
//shards:(NSArray *)glassShards;

@end
