//
//  SemiSecretFont.m
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


#import <SemiSecret/SemiSecret.h>

@implementation SemiSecretFont

- (NSString *) description
{
  return [NSString stringWithFormat:@"<SemiSecretFont: name:%@, size:%.1f>", NSStringFromClass([self class]), size];
}

+ (SemiSecretFont *)fontWithName:(NSString *)name
			    size:(CGFloat) size;
{
  //dynamically search for a class with this name
  Class klass = NSClassFromString([NSString stringWithFormat:@"%@Font", name]);
  //NSLog(@"looking for font: %@", name);
  //  NSLog(@"klass: %@", klass);
  SemiSecretFont * font = nil;
  if (klass)
    font = [[[klass alloc] initWithSize:size] autorelease];
  return font;
}

- (id) fontWithSize:(CGFloat)s
{
  Class klass = [self class];
  SemiSecretFont * f = nil;
  f = [[[klass alloc] initWithSize:s] autorelease];
  return f;
}

//this is not meant to be instantiated directly!
- (id) initWithSize:(CGFloat)fontsize
{
  if ((self = [super init])) {
    size = fontsize;
    font = nil;
  }
  return self;
}

- (void) setGlyphs:(CGGlyph *)glyphs forCharacters:(unichar *)chars size:(NSUInteger)length
{
  for (unsigned i=0; i<length; ++i)
    glyphs[i] = chars[i]-29;
}

- (CGSize) sizeToRenderString:(NSString *)string;
{
  unsigned glyphLength = [string length];
  CGGlyph * glyphs = malloc(sizeof(CGGlyph)*glyphLength);
  unichar * chars = malloc(sizeof(unichar)*glyphLength);
  [string getCharacters:chars];

  //need to plugin in a more generic solution to get glyphs
  [self setGlyphs:glyphs forCharacters:chars size:glyphLength];

  free(chars);

  int * advances = malloc(sizeof(int)*glyphLength);
  CGRect * bboxes = malloc(sizeof(CGRect)*glyphLength);

  CGFontGetGlyphAdvances(font, glyphs, glyphLength, advances);
  int total = 0;
  for (unsigned i=0; i<glyphLength; ++i)
    total += advances[i];
  
  CGFontGetGlyphBBoxes(font, glyphs, glyphLength, bboxes);
  
  CGFloat width = total*size/CGFontGetUnitsPerEm(font);
  CGFloat height = CGFontGetCapHeight(font)*size/CGFontGetUnitsPerEm(font);
  
  free(advances);
  free(bboxes);
  
  return CGSizeMake(width, height);

}

- (CGFloat) size
{
  return size;
}
- (CGFontRef) font
{
  return font;
}

- (void) renderText:(NSString *)text centeredAtPoint:(CGPoint) point inContext:(CGContextRef)context
{
  unsigned len;
  CGGlyph * glyphs;
  unichar * chars;
  len = [text length];
  glyphs = malloc(sizeof(CGGlyph)*len);
  chars = malloc(sizeof(unichar)*len);
  [text getCharacters:chars];
  free(chars);
  
  [self setGlyphs:glyphs forCharacters:chars size:len];

  CGSize textsize = [self sizeToRenderString:text];

  CGFloat x = point.x-textsize.width/2;
  CGFloat y = point.y+textsize.height/2;

  CGContextSetFont(context, font);
  CGContextSetFontSize(context, size);

  CGContextSetTextDrawingMode(context, kCGTextFillStroke);
  CGContextShowGlyphsAtPoint(context, x, y, glyphs, len);

  free(glyphs);
}


@end
