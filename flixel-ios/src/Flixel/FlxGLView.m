//
//  FlxGLView.m
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

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/glext.h>

#import <QuartzCore/QuartzCore.h>

@interface FlxTouches ()
- (void) processTouches:(NSSet *)newTouches;
@end

@interface FlxGLView ()
- (void) createBuffers;
- (void) destroyBuffers;
@end

static float textureScale = 1024.0;

@implementation FlxGLView

@synthesize context;
@synthesize renderBuffer;
@synthesize frameBuffer;
@synthesize backingWidth;
@synthesize backingHeight;

static EAGLContext * staticContext = nil;

+ (void) initialize
{
  if (self == [FlxGLView class]) {
    if (staticContext == nil) {
      staticContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
      [EAGLContext setCurrentContext:staticContext];
    }
  }
}


+ (void) setTextureScale:(float)scale;
{
  textureScale = scale;
}

+ (float) textureScale
{
  return textureScale;
}

+ (GLshort) convertToShort:(float)value
{
  return ((GLshort)((value)*self.textureScale) + 0.5); //rounding
}

+ (float) convertFromShort:(GLshort)value;
{
  return value*1.0/self.textureScale;
}

+ (GLint) maxTextureSize
{
//   GLint maxTextureSize;
//   glGetIntegerv(GL_MAX_TEXTURE_SIZE, &maxTextureSize);
//   return maxTextureSize;
  return 1024;
}

+ (Class) layerClass
{
  return [CAEAGLLayer class];
}

- (id) initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {

    if (FlxG.retinaDisplay)
      self.contentScaleFactor = 2.0;
    
    CAEAGLLayer * eaglLayer = (CAEAGLLayer *)self.layer;

//     eaglLayer.magnificationFilter = kCAFilterNearest;

// //     eaglLayer.contentsRect = CGRectMake(0.0000001, 0.0000001,
// //                                         1.0, 1.0);
//     eaglLayer.opaque = NO;
    
    eaglLayer.opaque = YES;
    eaglLayer.drawableProperties =
      [NSDictionary dictionaryWithObjectsAndKeys:
		    [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
		    //kEAGLColorFormatRGB565, kEAGLDrawablePropertyColorFormat, //kEAGLColorFormatRGBA8
		    kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, //kEAGLColorFormatRGBA8
		    nil];
    
    if (staticContext == nil)
      context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    else
      context = staticContext;

    if (!context || ![EAGLContext setCurrentContext:context]) {
      [self release];
      return nil;
    }

    [self createBuffers];
    
  }
  return self;
}

- (void) dealloc
{
  [self destroyBuffers];
  if ([EAGLContext currentContext] == context)
    [EAGLContext setCurrentContext:nil];
  [context release];
  staticContext = nil;
  [super dealloc];
}

// - (GLint) backingWidth
// {
//   if (FlxG.retinaDisplay)
//     return backingWidth/2;
//   return backingWidth;
// }

// - (GLint) backingHeight
// {
//   if (FlxG.retinaDisplay)
//     return backingHeight/2;
//   return backingHeight;  
// }

- (void) createBuffers;
{
  glGenFramebuffersOES(1, &frameBuffer);
  glGenRenderbuffersOES(1, &renderBuffer);

  glBindFramebufferOES(GL_FRAMEBUFFER_OES, frameBuffer);
  glBindRenderbufferOES(GL_RENDERBUFFER_OES, renderBuffer);
  [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer *)self.layer];
  glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, renderBuffer);

  glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
  glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);

  NSLog(@"backing dimensions: (%d,%d)", backingWidth, backingHeight);
  
  
  if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
    NSLog(@"FlxGLView: failed to make complete framebuffer object %x",
	  glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
}

- (void) destroyBuffers;
{
  if (frameBuffer != 0)
    glDeleteFramebuffersOES(1, &frameBuffer);
  frameBuffer = 0;
  if (renderBuffer != 0)
    glDeleteRenderbuffersOES(1, &renderBuffer);
  renderBuffer = 0;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [[FlxG touches] processTouches:[event allTouches]];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  NSMutableSet * realTouches = [NSMutableSet setWithSet:[event allTouches]];
  [realTouches minusSet:touches];
  [[FlxG touches] processTouches:realTouches];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  NSMutableSet * realTouches = [NSMutableSet setWithSet:[event allTouches]];
  [realTouches minusSet:touches];
  [[FlxG touches] processTouches:realTouches];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  [[FlxG touches] processTouches:[event allTouches]];
}

@end
