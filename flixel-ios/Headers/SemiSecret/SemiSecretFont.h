//
//  SemiSecretFont.h
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

#import <CoreGraphics/CoreGraphics.h>

@interface SemiSecretFont : NSObject
{
  CGFontRef font;
  CGFloat size;
}
- (id) initWithSize:(CGFloat)size;
+ (SemiSecretFont *) fontWithName:(NSString *)name
			     size:(CGFloat) size;
- (id) fontWithSize:(CGFloat)size;
- (CGSize) sizeToRenderString:(NSString *)string;
// - (CGFloat) size;
// - (CGFontRef) font;
- (void) setGlyphs:(CGGlyph *)glyphs forCharacters:(unichar *)chars size:(NSUInteger)length;
- (void) renderText:(NSString *)text centeredAtPoint:(CGPoint) point inContext:(CGContextRef)context;

@property (readonly) CGFloat size;
@property (readonly) CGFontRef font;
@end
