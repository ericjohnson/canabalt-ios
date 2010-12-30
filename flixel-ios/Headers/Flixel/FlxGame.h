//
//  FlxGame.h
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

#import <OpenGLES/ES1/gl.h>

@class FlxGroup;
@class FlxState;

@class EAGLContext;
@class UIWindow;

typedef enum {
  FlxGameOrientationPortrait,
  FlxGameOrientationLandscape,
} FlxGameOrientation;

@interface FlxGame : NSObject //Sprite
{
  NSString * _iState;
  BOOL _created;
  FlxState * _state;
  
  float _zoom;
  float modelZoom;
  BOOL textureBufferZoom;
  
  int _gameXOffset;
  int _gameYOffset;
  NSString * _frame;
  float _elapsed;
  unsigned int _total;
  BOOL _paused;

  BOOL autorotate;
  FlxGameOrientation gameOrientation;
  UIDeviceOrientation currentOrientation;
  float autorotateAngle;
  float autorotateAngleGoal;
  
  UIDeviceOrientation orientation;
  
  //
  UIWindow * window;
  EAGLContext * context;
  GLuint renderBuffer;
  GLuint frameBuffer;
  GLint backingWidth;
  GLint backingHeight;
  UIImageView * defaultView;

  GLshort blackVertices[10*2];
  GLubyte blackColors[10*4];
  
  //
  BOOL recursing;
  BOOL displayLinkSupported;

  BOOL iPad;

  id newState;
  id displayLink;

  NSInteger frameInterval;
}

@property(nonatomic,readonly) float zoom;
@property(nonatomic,readonly) BOOL textureBufferZoom;
@property(nonatomic,readonly) float modelZoom;
@property(nonatomic,assign) BOOL autorotate;
@property(nonatomic,readonly) FlxGameOrientation gameOrientation;
@property(nonatomic,readonly) UIDeviceOrientation currentOrientation;
@property(nonatomic,assign) BOOL paused;
@property(nonatomic,assign) NSInteger frameInterval;
@property(nonatomic,readonly) UIWindow * window;

- (id) initWithOrientation:(FlxGameOrientation)gameOrientation state:(NSString *)InitialState;
- (id) initWithOrientation:(FlxGameOrientation)gameOrientation state:(NSString *)InitialState zoom:(float)Zoom;
- (id) initWithOrientation:(FlxGameOrientation)gameOrientation state:(NSString *)InitialState zoom:(float)Zoom useTextureBufferZoom:(BOOL)textureBufferZoom;
- (id) initWithOrientation:(FlxGameOrientation)gameOrientation state:(NSString *)InitialState zoom:(float)Zoom useTextureBufferZoom:(BOOL)textureBufferZoom modelZoom:(float)modelZoom;
- (void) start;
- (void) showSoundTray;
- (void) showSoundTray:(BOOL)Silent;
- (void) switchState:(FlxState *)State;
+ (void) setSlowdown:(unsigned int)slowdown;
+ (unsigned int) slowdown;
- (void) resetProjection;
- (void) didEnterBackground;
- (void) willEnterForeground;
@end
