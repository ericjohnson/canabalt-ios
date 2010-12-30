//
//  FlxText.m
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
#import <SemiSecret/SemiSecret.h>

@interface FlxSprite ()
- (void) resetHelpers;
@end

@interface FlxText ()
- (void) setupNewText;
@end

@interface SemiSecretText()
- (void) computeNewBounds;
@end

@implementation FlxText

@synthesize sstext;

- (float) height
{
  if (regen)
    [self setupNewText];
  return super.height;
}

+ (id) textWithWidth:(unsigned int)Width text:(NSString *)Text font:(NSString *)Font size:(float)Size modelScale:(float)ModelScale;
{
  FlxText * ret = [[[self alloc] initWithX:0 y:0 width:Width text:Text modelScale:ModelScale] autorelease];
  ret.size = Size;
  ret.font = Font;
  return ret;
}

+ (id) textWithWidth:(unsigned int)Width text:(NSString *)Text font:(NSString *)Font size:(float)Size;
{
  FlxText * ret = [[[self alloc] initWithX:0 y:0 width:Width text:Text] autorelease];
  ret.size = Size;
  ret.font = Font;
  return ret;
}


+ (id) textWithWidth:(unsigned int)Width text:(NSString *)Text;
{
  FlxText * ret = [[[self alloc] initWithX:0 y:0 width:Width text:Text] autorelease];
  return ret;
}

- (id) initWithX:(float)X y:(float)Y width:(unsigned int)Width;
{
   return [self initWithX:X y:Y width:Width text:nil];
}
- (id) initWithX:(float)X y:(float)Y width:(unsigned int)Width modelScale:(float)ModelScale;
{
  return [self initWithX:X y:Y width:Width text:nil modelScale:ModelScale];  
}
- (id) initWithX:(float)X y:(float)Y width:(unsigned int)Width text:(NSString *)Text;
{
  return [self initWithX:X y:Y width:Width text:Text modelScale:1.0];
}
- (id) initWithX:(float)X y:(float)Y width:(unsigned int)Width text:(NSString *)Text modelScale:(float)ModelScale;
{
  if ((self = [super initWithX:X y:Y graphic:nil modelScale:ModelScale])) {

    regen = YES;

    if (Text == nil)
      Text = @"";
    width = Width;
    sstext = [[SemiSecretText alloc] initWithFrame:CGRectZero];
    sstext.padding = sstext.padding*modelScale;
    sstext.reposition = NO;
    sstext.text = Text;
    sstext.wrapped = YES;
    //default font needs to work correctly on ipad
    SemiSecretFont * f = sstext.font;
    f = [(SemiSecretFont *)(sstext.font) fontWithSize:f.size*modelScale];
    sstext.font = f;
    sstext.align = SemiSecretTextAlignLeft;
    //need to set this here, so that the texture actually gets rendered (rather than a filled polygon)
    filled = NO;
  }
  return self;
}
- (void) dealloc
{
  [sstext release];
  [super dealloc];
}
- (FlxText *) setFormat;
{
   return [self setFormat:nil];
}
- (FlxText *) setFormat:(NSString *)Font;
{
   return [self setFormatWithParam1:Font param2:8];
}
- (FlxText *) setFormatWithParam1:(NSString *)Font param2:(float)Size;
{
   return [self setFormatWithParam1:Font param2:Size param3:0xffffff];
}
- (FlxText *) setFormatWithParam1:(NSString *)Font param2:(float)Size param3:(unsigned int)Color;
{
   return [self setFormatWithParam1:Font param2:Size param3:Color param4:nil];
}
- (FlxText *) setFormatWithParam1:(NSString *)Font param2:(float)Size param3:(unsigned int)Color param4:(NSString *)Alignment;
{
   return [self setFormatWithParam1:Font param2:Size param3:Color param4:Alignment param5:0];
}
- (FlxText *) setFormatWithParam1:(NSString *)Font param2:(float)Size param3:(unsigned int)Color param4:(NSString *)Alignment param5:(unsigned int)ShadowColor;
{
  if (Font) {
    SemiSecretFont * f = [SemiSecretFont fontWithName:Font size:Size*modelScale];
    sstext.font = f;
  } else if (Size) {
    SemiSecretFont * f = [(SemiSecretFont *)(sstext.font) fontWithSize:Size*modelScale];
    sstext.font = f;
  }
  
  if (Color)
    [self setColor:Color];

  if (Alignment)
    [self setAlignment:Alignment];

  if (ShadowColor)
    [self setShadow:ShadowColor];
  
  regen = YES;
  return self;
}
- (NSString *) text;
{
  return sstext.text;
}
- (void) setText:(NSString *)Text;
{
  sstext.text = Text;
  regen = YES;
}
- (float) size;
{
  return (float)(((SemiSecretFont *)sstext.font).size)/modelScale;
}
- (void) setSize:(float)Size;
{
  sstext.font = [sstext.font fontWithSize:Size*modelScale];
  regen = YES;
}
- (unsigned int) color;
{
  const CGFloat * colors = CGColorGetComponents(sstext.color);
  size_t colorCount = CGColorGetNumberOfComponents(sstext.color);
  unsigned int c = 0;
  if (colorCount >= 3) {
    c |= (((int)(colors[0]*255)) << 16);
    c |= (((int)(colors[1]*255)) << 8);
    c |= (((int)(colors[2]*255)) << 0);
  }
  return c;
}
- (void) setColor:(unsigned int)Color;
{
  CGFloat r = ((Color >> 16) & 0xff) / 255.0;
  CGFloat g = ((Color >> 8) & 0xff) / 255.0;
  CGFloat b = ((Color >> 0) & 0xff) / 255.0;
  sstext.color = [UIColor colorWithRed:r green:g blue:b alpha:1.0].CGColor;
  regen = YES;
}
- (NSString *) font;
{
  NSString * fontClass = NSStringFromClass(sstext.font);
  return [fontClass stringByReplacingOccurrencesOfString:@"Font" withString:@"" options:0 range:NSMakeRange([fontClass length]-4, 4)];
}
- (void) setFont:(NSString *)Font;
{
  if (Font == nil)
    Font = @"Flixel";
  sstext.font = [SemiSecretFont fontWithName:Font size:((SemiSecretFont *)sstext.font).size];
  regen = YES;
}
- (NSString *) alignment;
{
  switch (sstext.align) {
  case SemiSecretTextAlignLeft:
    return @"left";
  case SemiSecretTextAlignCenter:
    return @"center";
  case SemiSecretTextAlignRight:
    return @"right";
  }
  return @"left";
}
- (void) setAlignment:(NSString *)Alignment;
{
  if (Alignment) {
    if ([Alignment compare:@"center"] == NSOrderedSame)
      sstext.align = SemiSecretTextAlignCenter;
    else if ([Alignment compare:@"justify"] == NSOrderedSame)
      sstext.align = SemiSecretTextAlignLeft; //not yet implemented
    else if ([Alignment compare:@"left"] == NSOrderedSame)
      sstext.align = SemiSecretTextAlignLeft;
    else if ([Alignment compare:@"right"] == NSOrderedSame)
      sstext.align = SemiSecretTextAlignRight;
    else
      sstext.align = SemiSecretTextAlignLeft;
  } else
    sstext.align = SemiSecretTextAlignLeft;
  regen = YES;
}
- (unsigned int) shadow;
{
  const CGFloat * colors = CGColorGetComponents(sstext.shadowColor);
  size_t colorCount = CGColorGetNumberOfComponents(sstext.shadowColor);
  unsigned int c = 0;
  if (colorCount >= 3) {
    c |= (((int)(colors[0]*255)) << 16);
    c |= (((int)(colors[1]*255)) << 8);
    c |= (((int)(colors[2]*255)) << 0);
  }
  return c;
}
- (void) setShadow:(unsigned int)ShadowColor;
{
  //shadowColor
  if (ShadowColor > 0) {
    CGFloat r = ((ShadowColor >> 16) & 0xff) / 255.0;
    CGFloat g = ((ShadowColor >> 8) & 0xff) / 255.0;
    CGFloat b = ((ShadowColor >> 0) & 0xff) / 255.0;
    sstext.effect = SemiSecretTextEffectBlurredShadow;
    sstext.shadowColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0].CGColor;
  } else {
    sstext.effect = SemiSecretTextEffectNone;
  }
  regen = YES;
}

- (void) setupNewText;
{
  CGFloat Height = [sstext heightForLines:-1 givenWidth:width*modelScale];
  height = Height/modelScale;
  sstext.frame = CGRectMake(0, 0, width*modelScale, height*modelScale);

  //manually manage the texture ourselves, rather than through FlxG, so that we aren't
  //constantly allocating new memory without releasing it...
  if (texture) {
    [texture release];
    texture = nil;
  }

  texture = [[SemiSecretTexture alloc] initWithView:sstext];
  frameWidth = width;
  frameHeight = height;

  [self resetHelpers];
  
  regen = NO;
}


- (void) render
{
  if (regen)
    [self setupNewText];
  [super render];
}


- (void) sizeToFit
{
  //how many lines is it? if it's just one line, then we can do it
  //if it's more than one line, find the line that has the minimal width -> punt for now...
  [sstext computeNewBounds];
  //new width...
  width = sstext.bounds.size.width/modelScale;
  [self setupNewText];
}

@end
