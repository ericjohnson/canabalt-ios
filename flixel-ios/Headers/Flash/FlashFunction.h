//
//  FlashFunction.h
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

#import <Flash/FlashObject.h>

@interface FlashFunction : FlashObject
{
  id target;
  SEL action;
  NSInvocation * invocation;
}
+ (FlashFunction *) functionWithTarget:(id)target action:(SEL)action;
- (id) execute;
- (id) executeWithObject:(id)obj;
- (id) executeWithObject:(id)obj1 withObject:(id)obj2;
- (id) executeWithObject:(id)obj1 withObject:(id)obj2 withObject:(id)obj3;
- (id) executeWithObject:(id)obj1 withObject:(id)obj2 withObject:(id)obj3 withObject:(id)obj4;
@end
