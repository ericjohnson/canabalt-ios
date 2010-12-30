//
//  BG.m
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


#import "BG.h"

@implementation BG

@synthesize random;

+ (id) bgWithImage:(NSString *)image
{
  return [[(BG *)[self alloc] initWithX:0 y:0 graphic:image] autorelease];
}

- (id) initWithX:(float)X y:(float)Y graphic:(NSString *)Graphic;
{
  if ((self = [super initWithX:X y:Y graphic:Graphic])) {
    random = NO;
  }
  return self;
}


- (void) update
{
  CGPoint _point = [self getScreenXY];
  if (_point.x + self.width < 0) {
    if (random) {
      x += FlxG.width*10 + FlxU.random*FlxG.width*10;
      scrollFactor.x = 2+FlxU.random*3;
    } else 
      x += width*2;
  }
}

@end
