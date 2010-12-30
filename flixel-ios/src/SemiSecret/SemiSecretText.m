//
//  SemiSecretText.m
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

#define PADDING 5.0

@interface SemiSecretText ()
- (void) computeNewBounds;
- (NSInteger) nextWrapOffsetForGlyphs:(NSInteger)offset;
@end

@implementation SemiSecretText

@dynamic font;
@synthesize color, text, effect, align, shadowColor;
@synthesize wrapped;
@synthesize lineSpacing;

@synthesize reposition;

@synthesize padding;

@synthesize wrapOnSpace;

@synthesize debug;

+ (id) text
{
  return [[[self alloc] initWithFrame:CGRectZero] autorelease];
}

- (NSString *) description
{
  return [NSString stringWithFormat:@"<SemiSecretText: text:%@, bounds:[%f,%f,%f,%f]>", self.text, self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height];
}


- (id) initWithFrame:(CGRect)frame
{
  if ([super initWithFrame:frame] == nil)
    return nil;
  wrapOnSpace = YES;
  padding = PADDING;
  reposition = YES;
  color = CGColorRetain([UIColor whiteColor].CGColor);
  shadowColor = CGColorRetain([UIColor blackColor].CGColor);
  text = @"";
  self.font = [SemiSecretFont fontWithName:@"Flixel" size:8.0];
  self.opaque = NO;
  effect = SemiSecretTextEffectNone;
  align = SemiSecretTextAlignCenter;
  self.userInteractionEnabled = NO;
  lineSpacing = 1.6;
  return self;
}

- (void) dealloc
{
  [text release];
  CGColorRelease(color);
  CGColorRelease(shadowColor);
  self.font = nil;
  if (glyphs)
    free(glyphs);
  [super dealloc];
}

- (void) setPadding:(CGFloat)newPadding
{
  if (padding == newPadding)
    return;
  padding = newPadding;
  [self computeNewBounds];
  [self setNeedsDisplay];
}

- (void) setText:(NSString *)newText
{
  if (text == newText) {
    return;
  }
  [text autorelease];
  text = [newText copy];
  [self computeNewBounds];
  [self setNeedsDisplay];
}

- (void) setFont:(id)newFont
{
  if (!newFont) { //release
    useUIFont = NO;
    useSSFont = NO;
    [ssfont release];
    [uifont release];
    ssfont = nil;
    uifont = nil;
    [self computeNewBounds];
    [self setNeedsDisplay];
    return;
  }
  //what is the type?
  if ([newFont isKindOfClass:[UIFont class]]) {
    useSSFont = NO;
    useUIFont = YES;
    if (uifont == newFont)
      return;
    [uifont release];
    uifont = newFont;
    [uifont retain];
    [self computeNewBounds];
    [self setNeedsDisplay];
  } else if ([newFont isKindOfClass:[SemiSecretFont class]]) {
    useSSFont = YES;
    useUIFont = NO;
    if (ssfont == newFont)
      return;
    [ssfont release];
    ssfont = newFont;
    [ssfont retain];
    [self computeNewBounds];
    [self setNeedsDisplay];
  }
}
- (id) font
{
  if (useSSFont)
    return ssfont;
  if (useUIFont)
    return uifont;
  return nil;
}

- (void) setColor:(CGColorRef)newColor
{
  if (color == newColor)
    return;
  CGColorRelease(color);
  color = newColor;
  CGColorRetain(color);
  [self setNeedsDisplay];
}

- (void) setShadowColor:(CGColorRef)newColor
{
  if (shadowColor == newColor)
    return;
  CGColorRelease(shadowColor);
  shadowColor = newColor;
  CGColorRetain(shadowColor);
  [self setNeedsDisplay];
}

- (void) setAlign:(SemiSecretTextAlign)Align
{
  if (align == Align)
    return;
  align = Align;
  [self setNeedsDisplay];
}

- (void) setEffect:(SemiSecretTextEffect)newEffect
{
  if (newEffect == effect)
    return;
  effect = newEffect;
  [self setNeedsDisplay];
}

- (CGFloat) heightForLines:(NSInteger)lines givenWidth:(CGFloat)width
{
  CGFloat y = 0.0;
  NSInteger offset = 0;
  CGRect frameCopy = self.frame;
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
			  width, self.frame.size.height);
  NSInteger currentLine = 0;
  while (offset != [text length] &&
	 (currentLine < lines || lines == -1)) {
    NSInteger nextOffset = [self nextWrapOffsetForGlyphs:offset];
    offset = nextOffset;
    y += textHeight*self.lineSpacing;
    currentLine++;
  }
  if (y == 0)
    y = textHeight*self.lineSpacing;

  self.frame = frameCopy;
  return y+self.padding*2;
}

- (void) drawRect:(CGRect)rect
{
  //fill rect with red
  CGContextRef context = UIGraphicsGetCurrentContext();

  if (debug) {
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillRect(context, rect);
  }

  if (useSSFont) {
    if (glyphs) {
      CGAffineTransform fontTransform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
      
      CGContextSetTextMatrix(context, fontTransform);
      
      CGContextSetFont(context, ssfont.font);
      CGContextSetFontSize(context, ssfont.size);
      CGContextSetTextDrawingMode(context, kCGTextFill);


      NSInteger offset = 0;
      CGFloat y = 0.0;
      while (offset != [text length]) {
	NSInteger nextOffset = [self nextWrapOffsetForGlyphs:offset];
	
	//strip out drawing spaces and newline characters...
	NSInteger notBlankOffset = nextOffset;
	if (notBlankOffset < [text length]) {
	  while ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[text characterAtIndex:notBlankOffset-1]] &&
		 notBlankOffset > offset) {
	    notBlankOffset--;
	  }
	}

	CGFloat x = padding;
	if (align == SemiSecretTextAlignCenter) {
	  x = floor((self.frame.size.width-lineWidth)/2);
	} else if (align == SemiSecretTextAlignRight) {
	  x = self.frame.size.width-lineWidth-padding;
	}

	//offset:notBlankOffset-offset
	
	switch (effect) {
	case SemiSecretTextEffectEngravedShadow:
	  {
	    CGContextSetFillColorWithColor(context, shadowColor);
	    CGContextShowGlyphsAtPoint(context, x, padding+textHeight-1.0+y, &glyphs[offset], notBlankOffset-offset);

	    break;
	  }
	case SemiSecretTextEffectReverseEngravedShadow:
	  {
	    CGContextSetFillColorWithColor(context, shadowColor);
	    CGContextShowGlyphsAtPoint(context, x, padding+textHeight+1.0+y, &glyphs[offset], notBlankOffset-offset);

	    break;
	  }
	case SemiSecretTextEffectBlurredShadow:
	  {
	    CGContextSetShadowWithColor(context,
					CGSizeMake(0,0),
					5.0,
					shadowColor);
	    break;
	  }
	}
	CGContextSetFillColorWithColor(context, color);
	
	if (y + textHeight*lineSpacing < self.bounds.size.height || !wrapped) {
	  //don't draw
	  CGContextShowGlyphsAtPoint(context, x, padding+textHeight+y, &glyphs[offset], notBlankOffset-offset);
	}
	offset = nextOffset;

	y += textHeight*lineSpacing;
      }
    }
  }
  if (useUIFont && uifont) {
    
    switch (effect) {
    case SemiSecretTextEffectEngravedShadow:
      {
	CGContextSetFillColorWithColor(context, shadowColor);
	[text drawAtPoint:CGPointMake(10.0,10.0-1.0)
	      withFont:uifont];
	break;
      }
    case SemiSecretTextEffectReverseEngravedShadow:
      {
	CGContextSetFillColorWithColor(context, shadowColor);
	[text drawAtPoint:CGPointMake(10.0,10.0+1.0)
	      withFont:uifont];
	break;
      }
    case SemiSecretTextEffectBlurredShadow:
      {
	CGContextSetShadowWithColor(context,
				    CGSizeMake(0,0),
				    5.0,
				    shadowColor);
	break;
      }
    }

    CGContextSetFillColorWithColor(context, color);
    [text drawAtPoint:CGPointMake(10.0,10.0)
	  withFont:uifont];

  }
}

- (NSInteger) nextWrapOffsetForGlyphs:(NSInteger)offset
{
  NSInteger i;
  CGFloat unitsPerEm = CGFontGetUnitsPerEm(ssfont.font);
  int * advances = malloc(sizeof(int)*glyphLength);
  CGFontGetGlyphAdvances(ssfont.font, glyphs, glyphLength, advances);

  if (offset == [text length]) {
    lineWidth = 0;
    free(advances);
    return NSNotFound;
  }
  if (!wrapped) {
    lineWidth = 0;
    for (i=offset; i<[text length]; ++i)
      lineWidth += advances[i]*ssfont.size/unitsPerEm;
    free(advances);
    return [text length];
  }

  //search for new line
  NSRange newlineRange = [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]
 			       options:0
 			       range:NSMakeRange(offset, [text length]-offset)];

  CGFloat width = self.bounds.size.width;


  CGFloat offsetWidth = 0.0;
  NSInteger nextOffset = offset;
  for (nextOffset=offset; nextOffset<glyphLength; ++nextOffset) {
    offsetWidth += advances[nextOffset]*ssfont.size/unitsPerEm;
    if (offsetWidth > width-self.padding*2) {
      break;
    }
  }

  if (newlineRange.location != NSNotFound &&
      newlineRange.location <= nextOffset) {
    nextOffset = newlineRange.location+1;
    lineWidth = 0;
    for (i=offset; i<nextOffset; ++i)
      lineWidth += advances[i]*ssfont.size/unitsPerEm;
    free(advances);
    return nextOffset;
  }


  if (nextOffset == [text length]) {
    nextOffset = [text length];
  } else if (nextOffset == offset) {
    //search for next (forward) occurrence of whitespace
    NSRange whiteSpaceRange = [text rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]
				    options:0
				    range:NSMakeRange(nextOffset, [text length]-nextOffset)];
    if (wrapOnSpace == NO)
      whiteSpaceRange = [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]
					      options:0
						range:NSMakeRange(nextOffset, [text length]-nextOffset)];
    if (whiteSpaceRange.location == NSNotFound)
      nextOffset = [text length];
    else { //search for end of whitespace
      NSRange nonWhiteSpaceRange = [text rangeOfCharacterFromSet:[[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet]
					 options:0
					 range:NSMakeRange(whiteSpaceRange.location, [text length]-whiteSpaceRange.location)];
      if (nonWhiteSpaceRange.location == NSNotFound)
	nextOffset = [text length];
      else
	nextOffset = nonWhiteSpaceRange.location+1;
    } 
  } else {
    //back up to the end of a word (look for whitespace)
    //unless that puts us back at 'offset', in which case we have
    //to display this whole word (look for next whitespace)
    NSRange whiteSpaceRange = [text rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]
				    options:NSBackwardsSearch
				    range:NSMakeRange(offset,nextOffset-offset)];
    if (wrapOnSpace == NO)
      whiteSpaceRange = [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]
					      options:NSBackwardsSearch
						range:NSMakeRange(offset,nextOffset-offset)];
    //did we just find the same offset (where we started?)
    if (whiteSpaceRange.location == nextOffset) {
      //search for the end of the whitespace
      NSRange nonWhiteSpaceRange = [text rangeOfCharacterFromSet:[[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet]
					 options:0
					 range:NSMakeRange(whiteSpaceRange.location, [text length]-whiteSpaceRange.location)];
      if (wrapOnSpace == NO)
	nonWhiteSpaceRange = [text rangeOfCharacterFromSet:[[NSCharacterSet newlineCharacterSet] invertedSet]
						   options:0
						     range:NSMakeRange(whiteSpaceRange.location, [text length]-whiteSpaceRange.location)];
      if (nonWhiteSpaceRange.location == NSNotFound)
	nextOffset = [text length];
      else
	nextOffset = nonWhiteSpaceRange.location+1;
    } else if (whiteSpaceRange.location == NSNotFound) {
      //search for the next occurrence of whitespace
      whiteSpaceRange = [text rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]
			      options:0
			      range:NSMakeRange(nextOffset, [text length]-nextOffset)];
      if (wrapOnSpace == NO)
	whiteSpaceRange = [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]
						options:0
						  range:NSMakeRange(nextOffset, [text length]-nextOffset)];
      if (whiteSpaceRange.location == NSNotFound)
	nextOffset = [text length];
      else { //search for end of whitespace
	NSRange nonWhiteSpaceRange = [text rangeOfCharacterFromSet:[[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet]
					   options:0
					   range:NSMakeRange(whiteSpaceRange.location, [text length]-whiteSpaceRange.location)];
	if (wrapOnSpace == NO)
	  nonWhiteSpaceRange = [text rangeOfCharacterFromSet:[[NSCharacterSet newlineCharacterSet] invertedSet]
						     options:0
						       range:NSMakeRange(whiteSpaceRange.location, [text length]-whiteSpaceRange.location)];
	  
	if (nonWhiteSpaceRange.location == NSNotFound)
	  nextOffset = [text length];
	else
	  nextOffset = nonWhiteSpaceRange.location;
      }
    } else {
      //we're done!!
      nextOffset = whiteSpaceRange.location+1;
    }
  }

  lineWidth = 0;
  for (i=offset; i<nextOffset; ++i)
    lineWidth += advances[i]*ssfont.size/unitsPerEm;
  free(advances);
  return nextOffset;
}

- (void) computeNewBounds
{
  if (text && useSSFont && ssfont) {
    if (glyphs)
      free(glyphs);
    glyphLength = [text length];
    glyphs = malloc(sizeof(CGGlyph)*glyphLength);
    unichar * chars = malloc(sizeof(unichar)*glyphLength);
    [text getCharacters:chars];
    [ssfont setGlyphs:glyphs forCharacters:chars size:glyphLength];

    free(chars);

    int * advances = malloc(sizeof(int)*glyphLength);

    CGFontGetGlyphAdvances(ssfont.font, glyphs, glyphLength, advances);
    int total = 0;
    for (unsigned i=0; i<glyphLength; ++i) {
      total += advances[i];
    }

    textWidth = total*ssfont.size/CGFontGetUnitsPerEm(ssfont.font);
    textHeight = CGFontGetCapHeight(ssfont.font)*ssfont.size/CGFontGetUnitsPerEm(ssfont.font);

    free(advances);

    //DOESN'T PLAY WELL WITH FlxText, so leave it out
    //we may need to remember the previous position
    //if align is right or left (default is center)
    CGRect previous_frame = self.frame;

    //set up new bounds
    //add some padding
    self.bounds = CGRectMake(0, 0, textWidth+padding*2, textHeight+padding*2);

    //THIS MAY NOT PLAY WELL WITH FlxText
    //may need to set new center
    if (reposition) {
      if (self.align == SemiSecretTextAlignLeft)
	self.center = CGPointMake(self.center.x-(self.frame.origin.x-previous_frame.origin.x),
				  self.center.y);
      if (self.align == SemiSecretTextAlignRight)
	self.center = CGPointMake(self.center.x+(self.frame.origin.x-previous_frame.origin.x),
				  self.center.y);
    }

  }
  if (text && useUIFont && uifont) {
    CGSize size = [text sizeWithFont:uifont];
    textWidth = size.width;
    textHeight = size.height;

    //we may need to remember the previous position
    //if align is right or left (default is center)
    CGRect previous_frame = self.frame;

    //set up new bounds
    //add some padding
    self.bounds = CGRectMake(0, 0, textWidth+padding*2, textHeight+padding*2);
    
    //may need to set new center
    if (self.align == SemiSecretTextAlignLeft)
      self.center = CGPointMake(self.center.x-(self.frame.origin.x-previous_frame.origin.x),
				self.center.y);
    if (self.align == SemiSecretTextAlignRight)
      self.center = CGPointMake(self.center.x+(self.frame.origin.x-previous_frame.origin.x),
				self.center.y);
  }
}


@end
