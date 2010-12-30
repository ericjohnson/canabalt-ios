//
//  FlxAnim.m
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

@implementation FlxAnim

@synthesize delay;
@synthesize name;
@synthesize looped;
@synthesize frames;

- (id) initWithParam1:(NSString *)Name param2:(NSMutableArray *)Frames;
{
   return [self initWithParam1:Name param2:Frames param3:0];
}
- (id) initWithParam1:(NSString *)Name param2:(NSMutableArray *)Frames param3:(float)FrameRate;
{
   return [self initWithParam1:Name param2:Frames param3:FrameRate param4:YES];
}
- (id) initWithParam1:(NSString *)Name param2:(NSMutableArray *)Frames param3:(float)FrameRate param4:(BOOL)Looped;
{
  if ((self = [super init])) {
    name = [Name copy];
    delay = 0;
    if (FrameRate > 0)
      delay = 1 / FrameRate;
    frames = [Frames copy];
    looped = Looped;
  }
  return self;
}
- (void) dealloc
{
  [name release];
  [frames release];
  [super dealloc];
}

// begin manually added for 'prettiness'
- (id) initWithName:(NSString *)Name frames:(NSMutableArray *)Frames; { return [self initWithParam1:Name param2:Frames]; }
- (id) initWithName:(NSString *)Name frames:(NSMutableArray *)Frames frameRate:(float)FrameRate; { return [self initWithParam1:Name param2:Frames param3:FrameRate]; }
- (id) initWithName:(NSString *)Name frames:(NSMutableArray *)Frames frameRate:(float)FrameRate looped:(BOOL)Looped; { return [self initWithParam1:Name param2:Frames param3:FrameRate param4:Looped]; }
// end manually added

@end
