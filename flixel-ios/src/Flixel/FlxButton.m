//
//  FlxButton.m
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

@interface FlxButton ()
- (void) visibility:(BOOL)On;
@end

@implementation FlxButton

//@synthesize on;

- (id) initWithX:(int)X y:(int)Y callback:(FlashFunction *)Callback;
{
  x = X;
  y = Y;
  if ((self = [super init])) {
    x = X;
    y = Y;
    width = 100;
    height = 20;
    _off = [[[FlxSprite alloc] init] createGraphicWithParam1:width param2:height param3:0xff7f7f7f];
    _off.solid = NO;
    [self addWithParam1:_off param2:YES];
    _on = [[[FlxSprite alloc] init] createGraphicWithParam1:width param2:height param3:0xffffffff];
    _on.solid = NO;
    [self addWithParam1:_on param2:YES];
    _offT = nil;
    _onT = nil;
    _callback = [Callback retain];
    _onToggle = NO;
    _pressed = NO;
    _initialized = NO;
    _sf = nil;
  }
  return self;
}
- (void) dealloc
{
  [_off release];
  [_onT release];
  [_on release];
  [_sf release];
  [_callback release];
  [_offT release];
  [super dealloc];
}
- (FlxButton *) loadGraphic:(FlxSprite *)Image;
{
   return [self loadGraphicWithParam1:Image param2:nil];
}
- (FlxButton *) loadGraphicWithParam1:(FlxSprite *)Image param2:(FlxSprite *)ImageHighlight;
{
   [_off autorelease];
   _off = [((FlxSprite *)([self replaceWithParam1:_off param2:Image])) retain];
   if (ImageHighlight == nil)
     {
       if (_on != _off)
	 [self remove:_on];
       [_on autorelease];
       _on = [_off retain];
     }
   else {
     [_on autorelease];
     _on = [((FlxSprite *)([self replaceWithParam1:_on param2:ImageHighlight])) retain];
   }
   _on.solid = _off.solid = NO;
   _off.scrollFactor = scrollFactor;
   _on.scrollFactor = scrollFactor;
   width = _off.width;
   height = _off.height;
   [self refreshHulls];
   return self;
}
- (FlxButton *) loadText:(FlxText *)Text;
{
   return [self loadTextWithParam1:Text param2:nil];
}
- (FlxButton *) loadTextWithParam1:(FlxText *)Text param2:(FlxText *)TextHighlight;
{
  if (Text)
    Text.alignment = @"center";
  if (TextHighlight)
    TextHighlight.alignment = @"center";
  if (Text != nil)
    {
      if (_offT == nil)
	{
	  [_offT autorelease];
	  _offT = [Text retain];
	  [self add:_offT];
	}
      else {
	[_offT autorelease];
	_offT = [((FlxText *)([self replaceWithParam1:_offT param2:Text])) retain];
      }
    }
  if (TextHighlight == nil) {
    [_onT autorelease];
    _onT = [_offT retain];
  } else
    {
      if (_onT == nil)
	{
	  [_onT autorelease];
	  _onT = [TextHighlight retain];
	  [self add:_onT];
	}
      else {
	[_onT autorelease];
	_onT = [((FlxText *)([self replaceWithParam1:_onT param2:TextHighlight])) retain];
      }
    }
  _offT.scrollFactor = scrollFactor;
  _onT.scrollFactor = scrollFactor;
  return self;
}
- (void) update;
{
  if (!_initialized)
    {
//       if (FlxG.stage != nil)
// 	{
// 	  [FlxG.stage addEventListenerWithParam1:MouseEvent.MOUSE_UP param2:onMouseUp];
// 	  _initialized = YES;
// 	}
      //TODO: register for touch ended events!
      _initialized = YES;
    }
  [super update];
  [self visibility:NO];
  //TODO: take care of touches
  if (FlxG.touches.touching) {
    CGPoint p = FlxG.touches.screenTouchPoint;
    CGPoint selfP = [self getScreenXY];
    if (CGRectContainsPoint(CGRectMake(selfP.x, selfP.y, width, height), p))
	_pressed = YES;
    else
      _pressed = NO;
    [self visibility:_pressed];
  }

  if (FlxG.touches.touchesEnded) {
    //also check for callback - touch released on this button?
    CGPoint lastP = FlxG.touches.lastScreenTouchPoint;
    if (!(!exists || !visible || !active || _callback == nil)) {
      CGPoint selfP = [self getScreenXY];
      if (CGRectContainsPoint(CGRectMake(selfP.x, selfP.y, width, height), lastP))
	[_callback performSelector:@selector(execute)
		   withObject:nil
		   afterDelay:0.0];
    }
  }
  
  //   if ([self overlapsPointWithParam1:FlxG.mouse.screenX param2:FlxG.mouse.screenY])
//     {
//       if (![FlxG.mouse pressed])
// 	_pressed = NO;
//       else
// 	if (!_pressed)
// 	  _pressed = YES;
//       [self visibility:!_pressed];
//     }
  if (_onToggle)
    [self visibility:_off.visible];
}
- (void) predictiveUpdate
{
  return;
}
- (BOOL) on;
{
  return _onToggle;
}
- (void) setOn:(BOOL)On;
{
  _onToggle = On;
}
- (void) destroy;
{
//   if (FlxG.stage != nil)
//     [FlxG.stage removeEventListenerWithParam1:MouseEvent.MOUSE_UP param2:onMouseUp];
}
- (void) visibility:(BOOL)On;
{
  if (On)
    {
      _off.visible = NO;
      if (_offT != nil)
	_offT.visible = NO;
      _on.visible = YES;
      if (_onT != nil)
	_onT.visible = YES;
    }
  else
    {
      _on.visible = NO;
      if (_onT != nil)
	_onT.visible = NO;
      _off.visible = YES;
      if (_offT != nil)
	_offT.visible = YES;
    }
}
// - (void) onMouseUp:(MouseEvent *)event;
// {
//   if (!exists || !visible || !active || ![FlxG.mouse justReleased] || (_callback == nil))
//     return;
//   if ([self overlapsPointWithParam1:FlxG.mouse.screenX param2:FlxG.mouse.screenY])
//     [self _callback];
// }

// - (id) copyWithZone:(NSZone *)zone
// {
//   FlxButton * c = [super copyWithZone:zone];
//   c->_onToggle = _onToggle;
//   c->_off = [_off retain];
//   c->_on = [_on retain];
//   c->_offT = [_offT retain];
//   c->_onT = [_onT retain];
//   c->_callback = [_callback retain];
//   c->_pressed = _pressed;
//   c->_initialized = _initialized;
//   c->_sf = [_sf retain];
//   return c;
// }

@end
