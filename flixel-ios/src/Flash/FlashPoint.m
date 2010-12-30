//
//  FlashPoint.m
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

#import <Flash/Flash.h>

@implementation FlashPoint

@synthesize x;
@synthesize y;

- (id) init { return [self initWithX:0]; }
- (id) initWithX:(float)X { return [self initWithX:X y:0]; }
- (id) initWithX:(float)X y:(float)Y
{
  if ((self = [super init])) {
    self.x = X;
    self.y = Y;
  }
  return self;
}

- (FlashPoint *) add:(FlashPoint *)v;
{
  FlashPoint * res = [[[FlashPoint alloc] init] autorelease];
  res.x = self.x+v.x;
  res.y = self.y+v.y;
  return res;
}

+ (float) distanceWithParam1:(FlashPoint *)pt1 param2:(FlashPoint *)pt2;
{
  return sqrt((pt1.x-pt2.x)*(pt1.x-pt2.x) + (pt1.y-pt2.y)*(pt1.y-pt2.y));
}

+ (float) distanceFrom:(FlashPoint *)pt1 to:(FlashPoint *)pt2; { return [self distanceWithParam1:pt1 param2:pt2]; }

- (BOOL) isEqual:(id)anObject
{
  if ([anObject isKindOfClass:[FlashPoint class]])
    return [self isEqualToPoint:(FlashPoint *)anObject];
  return NO;
}

- (BOOL) isEqualToPoint:(FlashPoint *)toCompare
{
  return self.x == toCompare.x && self.y == toCompare.y;
}

+ (FlashPoint *) interpolateWithParam1:(FlashPoint *)pt1 param2:(FlashPoint *)pt2 param3:(float)f;
{
  FlashPoint * ret = [[[FlashPoint alloc] init] autorelease];
  ret.x = (pt1.x-pt2.x)*f + pt2.x;
  ret.y = (pt1.y-pt2.y)*f + pt2.y;
  return ret;
}
+ (FlashPoint *) interpolateFrom:(FlashPoint *)pt1 to:(FlashPoint *)pt2 factor:(float)f { return [self interpolateWithParam1:pt1 param2:pt2 param3:f]; }

- (float) length
{
  return sqrt(self.x*self.x + self.y+self.y);
}

- (void) normalize:(float)thickness;
{
  float scale = thickness/self.length;
  self.x *= scale;
  self.y *= scale;
}

- (void) offsetWithParam1:(float)dx param2:(float)dy;
{
  self.x += dx;
  self.y += dy;
}
- (void) offsetByX:(float)dx y:(float)dy { return [self offsetWithParam1:dx param2:dy]; }

+ (FlashPoint *) polarWithParam1:(float)len param2:(float)angle;
{
  FlashPoint * ret = [[[FlashPoint alloc] init] autorelease];
  ret.x = len*cos(angle);
  ret.y = len*sin(angle);
  return ret;
}
+ (FlashPoint *) polarWithLength:(float)len angle:(float)angle { return [self polarWithParam1:len param2:angle]; }

- (FlashPoint *) subtract:(FlashPoint *)v;
{
  FlashPoint * res = [[[FlashPoint alloc] init] autorelease];
  res.x = self.x-v.x;
  res.y = self.y-v.y;
  return res;
}

@end
