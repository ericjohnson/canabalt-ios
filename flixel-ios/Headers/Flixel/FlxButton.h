//
//  FlxButton.h
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

@class FlxSprite;
@class FlxText;
@class FlashFunction;
@class FlxPoint;

@interface FlxButton : FlxGroup
{
   BOOL _onToggle;
   FlxSprite * _off;
   FlxSprite * _on;
   FlxText * _offT;
   FlxText * _onT;
   FlashFunction * _callback;
   BOOL _pressed;
   BOOL _initialized;
   FlxPoint * _sf;
}
@property(nonatomic,assign) BOOL on;
- (id) initWithX:(int)X y:(int)Y callback:(FlashFunction *)Callback;
- (FlxButton *) loadGraphic:(FlxSprite *)Image;
- (FlxButton *) loadGraphicWithParam1:(FlxSprite *)Image param2:(FlxSprite *)ImageHighlight;
- (FlxButton *) loadText:(FlxText *)Text;
- (FlxButton *) loadTextWithParam1:(FlxText *)Text param2:(FlxText *)TextHighlight;
- (void) update;
- (void) destroy;
@end
