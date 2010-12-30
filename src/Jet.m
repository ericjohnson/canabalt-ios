//
//  Jet.m
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

#import "Jet.h"

@implementation Jet

+ (id) jet
{
  return [[[Jet alloc] init] autorelease];
}

- (id) init
{
  if ((self = [super initWithX:0 y:0 graphic:@"jet.png"])) {
    self.x = -500;
    scrollFactor.x = 0;
    scrollFactor.y = 0.3;
    timer = 0;
    limit = 12+FlxU.random*4;
    velocity.x = -1200;
    velocity.y = 0;
  }
  return self;
}

- (void) update
{
  timer += FlxG.elapsed;
  if (timer > limit) {
    self.x = 960;
    self.y = -20 + FlxU.random*120;
    if (FlxG.iPad)
      [[FlxG quake] startWithIntensity:0.02 duration:1.5];
    else
      [[FlxG quake] startWithIntensity:0.01 duration:1.5];
    [FlxG play:@"flyby.caf"];
    timer = 0;
    limit = 10+FlxU.random*20;
  }
  if (self.x < -self.width)
    return;
  [super update];
}

@end
