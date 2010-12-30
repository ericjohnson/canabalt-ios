//
//  Shard.h
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


typedef struct {
  GLshort p0[2];
  GLubyte c0[4];
  GLshort p1[2];
  GLubyte c1[4];
  GLshort p2[2];
  GLubyte c2[4];
  GLshort p3[2];
  GLubyte c3[4];
  GLshort p4[2];
  GLubyte c4[4];
} ShardGLData;

@interface ShardEmitter : FlxEmitter
{
  ShardGLData * glData;
  NSUInteger shardCount;
}
+ (ShardEmitter *) shardEmitterWithShardCount:(NSUInteger)shardCount;
- (id) initWithShardCount:(NSUInteger)ShardCount;
@end


@interface Shard : FlxObject
{
  int t;
  ShardGLData * glData;
  float frameWidth;
  float frameHeight;
}
@end
