//
//  FlxList.m
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

@implementation FlxList

@synthesize object;
@synthesize next;

- (id) init;
{
  if ((self = [super init])) {
    object = nil;
    next = nil;
  }
  return self;
}
- (void) dealloc
{
  [object release];
  [next release];
  [super dealloc];
}
- (void) addWithParam1:(FlxObject *)Object param2:(unsigned int)List;
{
  NSLog(@"FlxList addWithParam1:param2: !!!?");
  char * s = "hello world";
  *s = 'H';
  int * ptr = NULL;
  *ptr = 1;
}
@end
