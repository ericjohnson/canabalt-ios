//
//  Smoke.h
//  Canabalt
//
//  Copyright Semi Secret Software 2009-2010. All rights reserved.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <Flixel/Flixel.h>

typedef struct {
  GLshort p0[2];
  GLshort t0[2];
  GLshort p1[2];
  GLshort t1[2];
  GLshort p2[2];
  GLshort t2[2];
  GLshort p3[2];
  GLshort t3[2];
  GLshort p4[2];
  GLshort t4[2];
  GLshort p5[2];
  GLshort t5[2];
} SmokeGLData;

@class SemiSecretTexture;

@interface SmokeEmitter : FlxEmitter
{
  SmokeGLData * glData;
  NSUInteger smokeCount;
  SemiSecretTexture * texture;
}
+ (SmokeEmitter *) smokeEmitterWithSmokeCount:(NSUInteger)smokeCount;
- (id) initWithSmokeCount:(NSUInteger)smokeCount;
@end

@interface Smoke : FlxObject
{
  SmokeGLData * glData;
  SemiSecretTexture * texture;
  float frameWidth;
  float frameHeight;
  unsigned int caf;
}
- (void) randomFrame;
@end
