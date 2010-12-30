//
//  FlxState.m
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

@implementation FlxState

@synthesize defaultGroup;
@synthesize bgColor;

- (id) init;
{
  if ((self = [super init])) {
    defaultGroup = [[FlxGroup alloc] init];
    bgColor = 0x000000;

    //     if (screen == nil)
//       {
// 	screen = [[FlxSprite alloc] init];
// 	[screen createGraphicWithParam1:FlxG.width param2:FlxG.height param3:0 param4:YES];
// 	screen.origin.x = screen.origin.y = 0;
// 	screen.antialiasing = YES;
//       }
  }
  return self;
}
- (void) dealloc
{
  [defaultGroup release];
  [super dealloc];
}
- (void) setPaused:(BOOL)paused;
{
}
- (void) setBgColor:(unsigned int)BGColor;
{
  bgColor = BGColor;
  red = ((bgColor >> 16) & 0xff)/255.0;
  green = ((bgColor >> 8) & 0xff)/255.0;
  blue = ((bgColor >> 0) & 0xff)/255.0;
  alpha = ((bgColor >> 24) & 0xff)/255.0;
}

- (void) create;
{
}
- (FlxObject *) add:(FlxObject *)Core;
{
   return [defaultGroup add:Core];
}
- (void) remove:(FlxObject *)Core;
{
  [defaultGroup remove:Core];
}
- (void) preProcess;
{
  //   [screen fill:bgColor];
  glClearColor(red, green, blue, alpha);
}
- (void) update;
{
   [defaultGroup update];
}
- (void) collide;
{
   [defaultGroup collide];
}
- (void) render;
{
  [defaultGroup render];
}
- (void) postProcess;
{
}
- (void) destroy;
{
  [defaultGroup destroy];
}
@end
