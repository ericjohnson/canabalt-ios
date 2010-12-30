//
//  Gib.m
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

#import "Gib.h"

static NSString * ImgDemoGibs = @"demo_gibs.png";

@implementation Gib

+ (id) gib
{
  return [[[self alloc] init] autorelease];
}

- (id) init
{
  //if ((self = [super initWithX:-100 y:-100 graphic:ImgDemoGibs])) {
  if ((self = [super initWithX:-100 y:-100 graphic:nil])) {
    [self loadGraphicWithParam1:ImgDemoGibs param2:YES];
    //self.size = CGSizeMake(20,20);
  }
  return self;
}

@end
