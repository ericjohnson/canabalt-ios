//
//  FlxQuake.h
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

@interface FlxQuake : NSObject
{
   float _zoom;
   float _intensity;
   float _timer;
   int x;
   int y;
  CGPoint scale;
}
@property(nonatomic,assign) int x;
@property(nonatomic,assign) int y;
@property(nonatomic,assign) CGPoint scale;
- (id) initWithZoom:(float)Zoom;
- (void) start;
- (void) start:(float)Intensity;
- (void) startWithIntensity:(float)Intensity;
- (void) startWithIntensity:(float)Intensity duration:(float)Duration;
- (void) stop;
- (void) update;
@end
