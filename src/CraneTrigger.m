//
//  CraneTrigger.m
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

#import "CraneTrigger.h"
#import "Player.h"

@implementation CraneTrigger

+ (id) craneTriggerWithFrame:(CGRect)f player:(Player *)plr
{
  return [[[self alloc] initWithFrame:f player:plr] autorelease];
}
- (id) initWithFrame:(CGRect)f player:(Player *)plr
{
  if ((self = [super initWithX:f.origin.x y:f.origin.y width:f.size.width height:f.size.height])) {
    player = [plr retain];
  }
  return self;
}

- (void) dealloc
{
  [player release];
  [super dealloc];
}

- (void) update
{
  if ([self overlaps:player])
    player.craneFeet = YES;
}

- (void) render {}

@end
