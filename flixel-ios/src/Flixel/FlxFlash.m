//
//  FlxFlash.m
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

@implementation FlxFlash

- (id) init;
{
  if ((self = [super initWithX:0 y:0 graphic:nil modelScale:1.0])) {
    //[self createGraphicWithParam1:FlxG.width param2:FlxG.height param3:0 param4:YES];
    //has to be white, so that when we use the color array, it will blend correctly
    [self createGraphicWithParam1:FlxG.width param2:FlxG.height param3:0xffffffff param4:YES];
    scrollFactor.x = 0;
    scrollFactor.y = 0;
    exists = NO;
  }
  return self;
}
- (void) dealloc
{
  [_complete release];
  [super dealloc];
}
- (void) start;
{
   return [self start:0xffffffff];
}
- (void) start:(unsigned int)Color;
{
   return [self startWithParam1:Color param2:1];
}
- (void) startWithParam1:(unsigned int)Color param2:(float)Duration;
{
   return [self startWithParam1:Color param2:Duration param3:nil];
}
- (void) startWithParam1:(unsigned int)Color param2:(float)Duration param3:(FlashFunction *)FlashComplete;
{
   return [self startWithParam1:Color param2:Duration param3:FlashComplete param4:NO];
}
- (void) startWithParam1:(unsigned int)Color param2:(float)Duration param3:(FlashFunction *)FlashComplete param4:(BOOL)Force;
{
   if (!Force && exists)
      return;
   [self fill:Color];
   _delay = Duration;
   [_complete autorelease];
   _complete = [FlashComplete retain];
   self.alpha = 1;
   self.visible = YES;
   exists = YES;
}
- (void) stop;
{
   exists = NO;
   self.visible = NO;
}
- (void) update;
{
   self.alpha -= FlxG.elapsed / _delay;
   if (self.alpha <= 0)
      {
         exists = NO;
	 self.visible = NO;
         if (_complete != nil)
	    [_complete execute];
      }
}

- (void) predictiveUpdate
{
}

// - (void) initializePredictedState
// {
//   predictedState = [[FlxFade alloc] init];
// }

// - (void) backupState
// {
//   [super backupState];
//   ((FlxFade *)predictedState).alpha = self.alpha;
// }

// - (void) restoreState
// {
//   [super restoreState];
//   self.alpha = ((FlxFade *)predictedState).alpha;
// }

// - (id) copyWithZone:(NSZone *)zone
// {
//   FlxFlash * c = [super copyWithZone:zone];
//   c->_delay = _delay;
//   c->_complete = [_complete retain];
//   return c;
// }

@end
