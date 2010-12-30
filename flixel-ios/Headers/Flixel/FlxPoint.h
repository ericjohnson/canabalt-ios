//
//  FlxPoint.h
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


@interface FlxPoint : NSObject //<NSCopying>
{
  float x;
  float y;
  float predictedX;
  float predictedY;
}
@property(nonatomic,assign) float x;
@property(nonatomic,assign) float y;
@property(nonatomic,assign) float predictedX;
@property(nonatomic,assign) float predictedY;
- (id) init;
- (id) initWithX:(float)X;
- (id) initWithX:(float)X y:(float)Y;

+ (id) pointWithX:(float)X y:(float)Y;

// - (id) initWithParam1:(float)X;
// - (id) initWithParam1:(float)X param2:(float)Y;

- (NSString *) toString;

@end
