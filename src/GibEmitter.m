//
//  GibEmitter.m
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

#import "GibEmitter.h"
#import <SemiSecret/SemiSecretTexture.h>

static NSString * ImgDemoGibs = @"demo_gibs.png";

@interface GibObject ()
- (id) initWithGLData:(GibGLData *)glData texture:(SemiSecretTexture *)texture;
- (void) setupVertices;
- (void) setupTexCoords;
@end

@implementation GibEmitter

+ (GibEmitter *) gibEmitterWithGibCount:(NSUInteger)gibCount
{
  return [[[self alloc] initWithGibCount:gibCount] autorelease];
}

- (id) initWithGibCount:(NSUInteger)GibCount
{
  if ((self = [super init])) {
    texture = [[FlxG addTextureWithParam1:ImgDemoGibs param2:NO] retain];
    gibCount = GibCount;
    glData = (GibGLData *)malloc(sizeof(GibGLData)*gibCount);
    for (int i=0; i<gibCount; i++) {
      GibObject * gib = [[GibObject alloc] initWithGLData:&(glData[i]) texture:texture];
      [gib randomFrame];
      [members addObject:gib];
      [gib release];
    }
  }
  return self;
}

- (void) dealloc
{
  free(glData);
  [texture release];
  [super dealloc];
}

- (void) render
{
  [FlxObject bind:texture.texture];

  glVertexPointer(2, GL_SHORT, sizeof(GLshort)*4, &(glData[0].p0));
  glTexCoordPointer(2, GL_SHORT, sizeof(GLshort)*4, &(glData[0].t0));

  glDrawArrays(GL_TRIANGLE_STRIP, 0, gibCount*6);
}

@end


@implementation GibObject

- (id) initWithGLData:(GibGLData *)GLData texture:(SemiSecretTexture *)Texture
{
  if ((self = [super initWithX:0 y:0 width:0 height:0])) {
    glData = GLData;
    texture = [Texture retain];

    self.x = -100;
    self.y = -100;
    width = frameWidth = texture.size.height;
    height = frameHeight = texture.size.height;

    caf = 0;

    [self setupTexCoords];
    [self setupVertices];
  }
  return self;
}

- (void) dealloc
{
  [texture release];
  [super dealloc];
}

- (void) randomFrame
{
  caf = ((int)([FlxU random] * (texture.size.width / frameWidth) ));
  [self setupTexCoords];
}

- (void) update
{
  [super update];
  [self setupVertices];
}

- (void) setExists:(BOOL)Exists
{
  [super setExists:Exists];
  [self setupVertices];
}

- (void) kill
{
  [super kill];
  [self setupVertices];
}

- (void) onEmit
{
}

- (void) setVisible:(BOOL)v
{
  [super setVisible:v];
  [self setupVertices];
}

- (void) setActive:(BOOL)a
{
  [super setActive:a];
  [self setupVertices];
}

- (void) setupTexCoords
{
  int xframes = texture.size.width/frameWidth;

  GLshort uOffset = caf % xframes;
  GLshort vOffset = caf / xframes;

  GLshort uShort = [FlxGLView convertToShort:frameWidth/texture.paddedSize.width];
  GLshort vShort = [FlxGLView convertToShort:frameHeight/texture.paddedSize.height];
  
  if (texture.atlasTexture) {
    // http://www.cocos2d-iphone.org/forum/topic/8267
    // The correct texture mapping for a given rect (rx, ry, rw, rh) in an image of size w x h is:
    // rect origin is zero based so the top left pixel is 0,0
    //  ((2*rx)+1)/(2*w), ((2*ry)+1))/(2*h)
    //   to
    //  (((2*rx)+1)+(rw*2)-2)/(2*w), (((2*ry)+1))+(rh*2)-2)/(2*h)
    //
    // For example an atlas of size 256x256 that contains a sprite image at 10,10 with size 100x100 the correct texture coordinates for each vertex are as follows:
    // 21/512, 21/512        -> (2*10+1)/(2*256)
    // 21/512, 219/512
    // 219/512, 219/512
    // 219/512, 21/512

    //TODO: why the extra *2 scale factor?
    CGRect r = CGRectMake(texture.offset.x + frameWidth * uOffset,
                          texture.offset.y + frameHeight * vOffset,
                          frameWidth * 2,
                          frameHeight * 2);
    CGPoint tl = CGPointMake((2*r.origin.x+1)/(2*texture.atlasTexture.paddedSize.width),
                             (2*r.origin.y+1)/(2*texture.atlasTexture.paddedSize.height));
    CGPoint br = CGPointMake((2*r.origin.x + 1 + r.size.width - 2)/(2*texture.atlasTexture.paddedSize.width),
                             (2*r.origin.y + 1 + r.size.height - 2)/(2*texture.atlasTexture.paddedSize.height));
                          
    glData->t1[0] = (GLshort)([FlxGLView convertToShort:tl.x]);
    glData->t1[1] = (GLshort)([FlxGLView convertToShort:tl.y]);
    glData->t2[0] = (GLshort)([FlxGLView convertToShort:br.x]);
    glData->t2[1] = (GLshort)([FlxGLView convertToShort:tl.y]);
    glData->t3[0] = (GLshort)([FlxGLView convertToShort:tl.x]);
    glData->t3[1] = (GLshort)([FlxGLView convertToShort:br.y]);
    glData->t4[0] = (GLshort)([FlxGLView convertToShort:br.x]);
    glData->t4[1] = (GLshort)([FlxGLView convertToShort:br.y]);
  } else {
    glData->t1[0] = uOffset*uShort;
    glData->t1[1] = vOffset*vShort;
    glData->t2[0] = (uOffset+1)*uShort;
    glData->t2[1] = vOffset*vShort;
    glData->t3[0] = uOffset*uShort;
    glData->t3[1] = (vOffset+1)*vShort;
    glData->t4[0] = (uOffset+1)*uShort;
    glData->t4[1] = (vOffset+1)*vShort;
  }
  
}

- (void) setupVertices
{
  if (visible && exists && active) {
    CGPoint p = [self getScreenXY];
    p.x = p.x + frameWidth/2.0;
    p.y = p.y + frameHeight/2.0;

    CGPoint p1 = CGPointMake(-(frameWidth/2.0),
                             -(frameHeight/2.0));
    CGPoint p2 = CGPointMake(frameWidth/2.0,
                             -(frameHeight/2.0));
    CGPoint p3 = CGPointMake(-(frameWidth/2.0),
                             frameHeight/2.0);
    CGPoint p4 = CGPointMake(frameWidth/2.0,
                             frameHeight/2.0);
    
    CGAffineTransform t1 = CGAffineTransformMakeRotation(angle*M_PI/180.0);
    p1 = CGPointApplyAffineTransform(p1, t1);
    p2 = CGPointApplyAffineTransform(p2, t1);
    p3 = CGPointApplyAffineTransform(p3, t1);
    p4 = CGPointApplyAffineTransform(p4, t1);
  
    glData->p1[0] = (GLshort)(p1.x + p.x);
    glData->p1[1] = (GLshort)(p1.y + p.y);
    glData->p2[0] = (GLshort)(p2.x + p.x);
    glData->p2[1] = (GLshort)(p2.y + p.y);
    glData->p3[0] = (GLshort)(p3.x + p.x);
    glData->p3[1] = (GLshort)(p3.y + p.y);
    glData->p4[0] = (GLshort)(p4.x + p.x);
    glData->p4[1] = (GLshort)(p4.y + p.y);

    glData->p0[0] = glData->p1[0];
    glData->p0[1] = glData->p1[1];
    glData->p5[0] = glData->p4[0];
    glData->p5[1] = glData->p4[1];
  } else {
    glData->p0[0] = 0;
    glData->p0[1] = 0;
    glData->p1[0] = 0;
    glData->p1[1] = 0;
    glData->p2[0] = 0;
    glData->p2[1] = 0;
    glData->p3[0] = 0;
    glData->p3[1] = 0;
    glData->p4[0] = 0;
    glData->p4[1] = 0;
    glData->p5[0] = 0;
    glData->p5[1] = 0;
  }
}

- (void) render
{
}

@end
