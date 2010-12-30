//
//  FlxGLView.h
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
#import <OpenGLES/ES1/gl.h>

@class EAGLContext;

@interface FlxGLView : UIView {
  EAGLContext * context;
  GLuint renderBuffer;
  GLuint frameBuffer;
  GLint backingWidth;
  GLint backingHeight;
}
@property(nonatomic,readonly) EAGLContext * context;
@property(nonatomic,readonly) GLuint renderBuffer;
@property(nonatomic,readonly) GLuint frameBuffer;
@property(nonatomic,readonly) GLint backingWidth;
@property(nonatomic,readonly) GLint backingHeight;
+ (void) setTextureScale:(float)scale;
+ (float) textureScale;
+ (GLshort) convertToShort:(float)value;
+ (float) convertFromShort:(GLshort)value;
+ (GLint) maxTextureSize;
@end
