//
//  FlxPoint.m
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

@implementation FlxPoint

@synthesize x;
@synthesize y;
@synthesize predictedX;
@synthesize predictedY;

+ (id) pointWithX:(float)X y:(float)Y;
{
  return [[[self alloc] initWithX:X y:Y] autorelease];
}

- (id) init;
{
   return [self initWithX:0];
}
- (id) initWithX:(float)X;
{
   return [self initWithX:X y:0];
}
- (id) initWithX:(float)X y:(float)Y;
{
  if ((self = [super init])) {
      x = X;
      y = Y;
  }
  return self;
}
- (void) dealloc
{
  [super dealloc];
}
- (NSString *) toString;
{
  //return [FlxU getClassNameWithParam1:self param2:YES];
  return [self description];
}

- (void) setX:(float)X
{
  x = X;
  predictedX = x;
}

- (void) setY:(float)Y
{
  y = Y;
  predictedY = y;
}

// - (id) initWithParam1:(float)X; { return [self initWithX:X]; }
// - (id) initWithParam1:(float)X param2:(float)Y; { return [self initWithX:X y:Y]; }

// - (id)copyWithZone:(NSZone *)zone
// {
//   FlxPoint * c = [[[self class] allocWithZone:zone] init];
//   c.x = x;
//   c.y = y;
//   return c;
// }

@end
