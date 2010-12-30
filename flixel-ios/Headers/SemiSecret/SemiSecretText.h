//
//  SemiSecretText.h
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

#import <UIKit/UIKit.h>

typedef enum {
  SemiSecretTextEffectNone,
  SemiSecretTextEffectEngravedShadow,
  SemiSecretTextEffectReverseEngravedShadow,
  SemiSecretTextEffectBlurredShadow,
} SemiSecretTextEffect;

typedef enum {
  SemiSecretTextAlignCenter,
  SemiSecretTextAlignLeft,
  SemiSecretTextAlignRight,
} SemiSecretTextAlign;

@class SemiSecretFont;

@interface SemiSecretText : UIView
{
  NSString * text;
  BOOL useSSFont;
  BOOL useUIFont;
  SemiSecretFont * ssfont;
  UIFont * uifont;
  CGColorRef color;
  CGColorRef shadowColor;
  CGGlyph * glyphs;
  unsigned glyphLength;
  CGFloat lineWidth;
  CGFloat textWidth;
  CGFloat textHeight;
  SemiSecretTextEffect effect;
  SemiSecretTextAlign align;
  BOOL wrapped;
  CGFloat lineSpacing;
  BOOL reposition;
  CGFloat padding;
  BOOL wrapOnSpace;
  BOOL debug;
}
+ (id) text;
@property (copy) NSString * text;
@property (assign) CGColorRef color;
@property (assign) CGColorRef shadowColor;
@property (retain) id font;
@property (assign) SemiSecretTextEffect effect;
@property (assign) SemiSecretTextAlign align;
@property (assign,getter=isWrapped) BOOL wrapped;
- (CGFloat) heightForLines:(NSInteger)lines givenWidth:(CGFloat)width;
@property (assign) CGFloat lineSpacing;
@property (assign) BOOL reposition;
@property (assign) CGFloat padding;
@property (assign) BOOL wrapOnSpace;
@property (assign) BOOL debug;
@end
