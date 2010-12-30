//
//  FlashPoint.h
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

@interface FlashPoint : FlashObject
{
  float x;
  float y;
}
@property (assign,readonly) float length;
@property (assign) float x;
@property (assign) float y;
- (id) init;
- (id) initWithX:(float)X;
- (id) initWithX:(float)X y:(float)Y;

- (FlashPoint *) add:(FlashPoint *)v;

+ (float) distanceWithParam1:(FlashPoint *)pt1 param2:(FlashPoint *)pt2;
+ (float) distanceFrom:(FlashPoint *)pt1 to:(FlashPoint *)pt2;

//- (BOOL) isEqual:(id)anObject;
- (BOOL) isEqualToPoint:(FlashPoint *)toCompare; //equals

+ (FlashPoint *) interpolateWithParam1:(FlashPoint *)pt1 param2:(FlashPoint *)pt2 param3:(float)f;
+ (FlashPoint *) interpolateFrom:(FlashPoint *)pt1 to:(FlashPoint *)pt2 factor:(float)f;

- (void) normalize:(float)thickness;

- (void) offsetWithParam1:(float)dx param2:(float)dy;
- (void) offsetByX:(float)dx y:(float)dy;

+ (FlashPoint *) polarWithParam1:(float)len param2:(float)angle;
+ (FlashPoint *) polarWithLength:(float)len angle:(float)angle;

- (FlashPoint *) subtract:(FlashPoint *)v;


@end
