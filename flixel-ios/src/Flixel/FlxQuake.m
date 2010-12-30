//
//  FlxQuake.m
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

@implementation FlxQuake

@synthesize x;
@synthesize y;
@synthesize scale;

- (id) initWithZoom:(float)Zoom;
{
  if ((self = [super init])) {
    scale = CGPointMake(1,1);
    _zoom = Zoom;
      [self start:0];
  }
  return self;
}
- (void) dealloc
{
  [super dealloc];
}
- (void) start;
{
   return [self start:0.05];
}
- (void) start:(float)Intensity;
{
  return [self startWithIntensity:Intensity];
}
- (void) startWithIntensity:(float)Intensity;
{
   return [self startWithIntensity:Intensity duration:0.5];
}
- (void) startWithIntensity:(float)Intensity duration:(float)Duration;
{
   [self stop];
   _intensity = Intensity;
   _timer = Duration;
}
- (void) stop;
{
   x = 0;
   y = 0;
   _intensity = 0;
   _timer = 0;
}
- (void) update;
{
   if (_timer > 0)
      {
         _timer -= FlxG.elapsed;
         if (_timer <= 0)
            {
               _timer = 0;
               x = 0;
               y = 0;
            }
         else
	   {
	     x = ([FlxU random] * _intensity * FlxG.width * 2 - _intensity * FlxG.width) * _zoom * scale.x;
	     y = ([FlxU random] * _intensity * FlxG.height * 2 - _intensity * FlxG.height) * _zoom * scale.y;
            }
      }
}
@end
