//
//  FlashRectangle.m
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

@implementation FlashRectangle

@synthesize x, y, width, height;

- (id) init
{ return [self initWithX:0]; }
- (id) initWithX:(float)X
{ return [self initWithX:X y:0]; }
- (id) initWithX:(float)X y:(float)Y
{ return [self initWithX:X y:Y width:0]; }
- (id) initWithX:(float)X y:(float)Y width:(float)Width
{ return [self initWithX:X y:Y width:Width height:0]; }
- (id) initWithX:(float)X y:(float)Y width:(float)Width height:(float)Height
{
  if ((self = [super init])) {
    self.x = X;
    self.y = Y;
    self.width = Width;
    self.height = Height;
  }
  return self;
}

- (float) bottom { return y+height; }
- (void) setBottom:(float)bottom { /*y = bottom-height;*/ height = bottom-y; }
- (FlashPoint *) bottomRight { return [[[FlashPoint alloc] initWithX:self.right y:self.bottom] autorelease]; }
- (void) setBottomRight:(FlashPoint *)bottomRight
{
//   x = bottomRight.x-width;
//   y = bottomRight.y-height;
  width = bottomRight.x-x;
  height = bottomRight.y-y;
}
- (float) left { return x; }
- (void) setLeft:(float)left { x = left; }
- (float) right { return x+width; }
- (void) setRight:(float)right { /*x = right-width;*/ width = right-x; }
- (FlashPoint *) size { return [[[FlashPoint alloc] initWithX:width y:height] autorelease]; }
- (void) setSize:(FlashPoint *)size
{
  width = size.x;
  height = size.y;
}
- (float) top { return y; }
- (void) setTop:(float)top { y = top; }
- (FlashPoint *) topLeft { return [[[FlashPoint alloc] initWithX:x y:y] autorelease]; }
- (void) setTopLeft:(FlashPoint *)topLeft
{
  x = topLeft.x;
  y = topLeft.y;
}

- (BOOL) containsWithParam1:(float)X param2:(float)Y;
{
  return x <= X && x+width >= X && y <= Y && y+height >= Y;
}
- (BOOL) containsX:(float)X y:(float)Y { return [self containsWithParam1:X param2:Y]; }

- (BOOL) containsPoint:(FlashPoint *)point;
{
  return [self containsX:point.x y:point.y];
}

- (BOOL) containsRect:(FlashRectangle *)rect;
{
  return [self containsPoint:rect.topLeft] && [self containsPoint:rect.bottomRight];
}

// - (BOOL) isEqual:(id)anObject
// {
//   if ([anObject isKindOfClass:[FlashRectangle class]])
//     return [self isEqualToRectange:(FlashRectangle *)anObject];
//   return NO;
// }
- (BOOL) isEqualToRectangle:(FlashRectangle *)toCompare;
{
  return self.x == toCompare.x && self.y == toCompare.y &&
    self.width == toCompare.width && self.height == toCompare.height;
}

- (void) inflateWithParam1:(float)dx param2:(float)dy;
{
  x -= dx;
  width += 2*dx;
  y -= dy;
  height += 2*dy;
}
- (void) inflateByX:(float)dx y:(float)dy { return [self inflateWithParam1:dx param2:dy]; }

- (void) inflatePoint:(FlashPoint *)point
{
  return [self inflateByX:point.x y:point.y];
}

- (FlashRectangle *) intersection:(FlashRectangle *)toIntersect;
{
  FlashRectangle * ret = [[[FlashRectangle alloc] init] autorelease];

  ret.left = MAX(self.left, toIntersect.top);
  ret.top = MAX(self.top, toIntersect.top);
  ret.right = MIN(self.right, toIntersect.right);
  ret.bottom = MIN(self.bottom, toIntersect.bottom);

  return ret;
}

- (BOOL) intersects:(FlashRectangle *)toIntersect
{
  FlashRectangle * intersection = [self intersection:toIntersect];
  return ![intersection isEmpty];
}

- (BOOL) isEmpty
{
  return width > 0 && height > 0;
}

- (void) offsetWithParam1:(float)dx param2:(float)dy
{
  x += dx;
  y += dy;
}
- (void) offsetByX:(float)dx y:(float)dy { return [self offsetWithParam1:dx param2:dy]; }
- (void) offsetPoint:(FlashPoint *)point
{
  return [self offsetByX:point.x y:point.y];
}

- (void) setEmpty
{
  x = y = width = height = 0;
}

- (FlashRectangle *) union:(FlashRectangle *)toUnion;
{
  FlashRectangle * ret = [[[FlashRectangle alloc] init] autorelease];

  ret.left = MIN(self.left, toUnion.top);
  ret.top = MIN(self.top, toUnion.top);
  ret.right = MAX(self.right, toUnion.right);
  ret.bottom = MAX(self.bottom, toUnion.bottom);

  return ret;
}

@end
