//
//  FlxRect.m
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
#import <Flixel/Flixel.h>

@implementation FlxRect

@synthesize width;
@synthesize height;

// - (id) init;
// {
//    return [self initWithX:0];
// }
// - (id) initWithX:(float)X;
// {
//    return [self initWithX:X y:0];
// }
- (id) initWithX:(float)X y:(float)Y;
{
   return [self initWithX:X y:Y width:0];
}
- (id) initWithX:(float)X y:(float)Y width:(float)Width;
{
   return [self initWithX:X y:Y width:Width height:0];
}
- (id) initWithX:(float)X y:(float)Y width:(float)Width height:(float)Height;
{
  if ((self = [super initWithX:X y:Y])) {
      width = Width;
      height = Height;
  }
  return self;
}
- (void) dealloc
{
  [super dealloc];
}
- (float) left;
{
   return x;
}
- (float) right;
{
   return x + width;
}
- (float) top;
{
   return y;
}
- (float) bottom;
{
   return y + height;
}
// - (id)copyWithZone:(NSZone *)zone
// {
//   FlxRect * c = [super copyWithZone:zone];
//   c.width = width;
//   c.height = height;
//   return c;
// }
@end
