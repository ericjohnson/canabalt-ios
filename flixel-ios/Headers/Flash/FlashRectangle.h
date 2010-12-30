//
//  FlashRectangle.h
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

#import <Flash/FlashObject.h>

@interface FlashRectangle : FlashObject
{
  float x;
  float y;
  float width;
  float height;
}
@property (assign) float bottom;
@property (retain) FlashPoint * bottomRight;
@property (assign) float height;
@property (assign) float left;
@property (assign) float right;
@property (retain) FlashPoint * size;
@property (assign) float top;
@property (retain) FlashPoint * topLeft;
@property (assign) float width;
@property (assign) float x;
@property (assign) float y;
- (id) init;
- (id) initWithX:(float)X;
- (id) initWithX:(float)X y:(float)Y;
- (id) initWithX:(float)X y:(float)Y width:(float)Width;
- (id) initWithX:(float)X y:(float)Y width:(float)Width height:(float)Height;

- (BOOL) containsWithParam1:(float)X param2:(float)Y;
- (BOOL) containsX:(float)X y:(float)Y;

- (BOOL) containsPoint:(FlashPoint *)point;
- (BOOL) containsRect:(FlashRectangle *)rect;

- (BOOL) isEqualToRectangle:(FlashRectangle *)toCompare;

- (void) inflateWithParam1:(float)dx param2:(float)dy;
- (void) inflateByX:(float)dx y:(float)dy;

- (void) inflatePoint:(FlashPoint *)point;

- (FlashRectangle *) intersection:(FlashRectangle *)toIntersect;

- (BOOL) intersects:(FlashRectangle *)toIntersect;

- (BOOL) isEmpty;

- (void) offsetWithParam1:(float)dx param2:(float)dy;
- (void) offsetByX:(float)dx y:(float)dy;
- (void) offsetPoint:(FlashPoint *)point;

- (void) setEmpty;

- (FlashRectangle *) union:(FlashRectangle *)toUnion;

@end
