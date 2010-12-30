//
//  FlxState.h
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

//@class FlxSprite;
@class FlxGroup;

// FlxSprite * screen;
// unsigned int bgColor;

//@interface FlxState : Sprite //why a subclass of Sprite? // -> because needs access to Sprite.parent??
@interface FlxState : NSObject
{
  FlxGroup * defaultGroup;
  unsigned int bgColor;
  float red;
  float green;
  float blue;
  float alpha;
}
@property(nonatomic,retain) FlxGroup * defaultGroup;
@property(nonatomic,assign) unsigned int bgColor;
- (id) init;
- (void) create;
- (FlxObject *) add:(FlxObject *)Core;
- (void) remove:(FlxObject *)Core;
- (void) preProcess;
- (void) update;
- (void) collide;
- (void) render;
- (void) postProcess;
- (void) destroy;
- (void) setPaused:(BOOL)paused;
@end
