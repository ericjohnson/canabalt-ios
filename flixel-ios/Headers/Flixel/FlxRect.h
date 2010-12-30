//
//  FlxRect.h
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

#import <Flixel/FlxPoint.h>

@interface FlxRect : FlxPoint
{
   float width;
   float height;
}
@property(nonatomic,readonly) float right;
@property(nonatomic,readonly) float bottom;
@property(nonatomic,readonly) float top;
@property(nonatomic,assign) float width;
@property(nonatomic,readonly) float left;
@property(nonatomic,assign) float height;
// - (id) init;
// - (id) initWithX:(float)X;
// - (id) initWithX:(float)X y:(float)Y;
- (id) initWithX:(float)X y:(float)Y width:(float)Width;
- (id) initWithX:(float)X y:(float)Y width:(float)Width height:(float)Height;

@end
