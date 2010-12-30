//
//  FlashFunction.m
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

#import <Flash/Flash.h>

@interface FlashFunction ()
@property (retain) id target;
@property (assign) SEL action;
- (void) setupInvocation;
@end

@implementation FlashFunction

@synthesize target, action;

- (void) setTarget:(id)o
{
  if (o == target)
    return;
  [target release];
  target = [o retain];
  [self setupInvocation];
}

- (void) setAction:(SEL)s
{
  if (s == action)
    return;
  action = s;
  [self setupInvocation];
}

+ (FlashFunction *) functionWithTarget:(id)target action:(SEL)action;
{
  FlashFunction * ret = [[[FlashFunction alloc] init] autorelease];
  ret.target = target;
  ret.action = action;
  return ret;
}

- (void) dealloc
{
  self.target = nil;
  [super dealloc];
}

- (void) setupInvocation
{
  if (target && action) {
    NSMethodSignature * sig = [target methodSignatureForSelector:action];
    [invocation release];
    if (sig) {
      invocation = [[NSInvocation invocationWithMethodSignature:sig] retain];
      [invocation setTarget:target];
      [invocation setSelector:action];
    }
  } else {
    [invocation release];
    invocation = nil;
  }
}

- (id) execute;
{
  //return [self.target performSelector:self.action];
  //how many arguments in invocation?
  if (invocation == nil)
    return nil;
  NSMethodSignature * sig = [invocation methodSignature];
  NSUInteger args = [sig numberOfArguments];
  for (NSUInteger i=2; i<args; ++i)
    [invocation setArgument:nil atIndex:i];
  [invocation invoke];
  id result = nil;
  if ([invocation.methodSignature methodReturnLength] == sizeof(id))
    [invocation getReturnValue:&result];
  return result;
}

- (id) executeWithObject:(id)obj;
{
  // return [self.target performSelector:self.action withObject:obj];
  //how many arguments in invocation?
  if (invocation == nil)
    return nil;
  NSMethodSignature * sig = [invocation methodSignature];
  NSUInteger args = [sig numberOfArguments];
  if (args >= 1+2)
    [invocation setArgument:&obj atIndex:2];
  for (NSUInteger i=1+2; i<args; ++i)
    [invocation setArgument:nil atIndex:i];
  [invocation invoke];
  id result = nil;
  if ([invocation.methodSignature methodReturnLength] == sizeof(id))
    [invocation getReturnValue:&result];
  return result;
}
- (id) executeWithObject:(id)obj1 withObject:(id)obj2;
{
  //return [self.target performSelector:self.action withObject:obj1 withObject:obj2];
  //how many arguments in invocation?
  if (invocation == nil)
    return nil;
  NSMethodSignature * sig = [invocation methodSignature];
  NSUInteger args = [sig numberOfArguments];
  if (args >= 1+2)
    [invocation setArgument:&obj1 atIndex:2];
  if (args >= 2+2)
    [invocation setArgument:&obj2 atIndex:3];
  for (NSUInteger i=2+2; i<args; ++i)
    [invocation setArgument:nil atIndex:i];
  [invocation invoke];
  id result = nil;
  if ([invocation.methodSignature methodReturnLength] == sizeof(id))
    [invocation getReturnValue:&result];
  return result;
}
- (id) executeWithObject:(id)obj1 withObject:(id)obj2 withObject:(id)obj3;
{
  if (invocation == nil)
    return nil;
  //how many arguments in invocation?
  NSMethodSignature * sig = [invocation methodSignature];
  NSUInteger args = [sig numberOfArguments];
  if (args >= 1+2)
    [invocation setArgument:&obj1 atIndex:2];
  if (args >= 2+2)
    [invocation setArgument:&obj2 atIndex:3];
  if (args >= 3+2)
    [invocation setArgument:&obj3 atIndex:4];
  for (NSUInteger i=3+2; i<args; ++i)
    [invocation setArgument:nil atIndex:i];
  [invocation invoke];
  id result = nil;
  if ([invocation.methodSignature methodReturnLength] == sizeof(id))
    [invocation getReturnValue:&result];
  return result;
}
- (id) executeWithObject:(id)obj1 withObject:(id)obj2 withObject:(id)obj3 withObject:(id)obj4;
{
  if (invocation == nil)
    return nil;
  NSMethodSignature * sig = [invocation methodSignature];
  NSUInteger args = [sig numberOfArguments];
  if (args >= 1+2)
    [invocation setArgument:&obj1 atIndex:2];
  if (args >= 2+2)
    [invocation setArgument:&obj2 atIndex:3];
  if (args >= 3+2)
    [invocation setArgument:&obj3 atIndex:4];
  if (args >= 4+2)
    [invocation setArgument:&obj4 atIndex:5];
  for (NSUInteger i=4+2; i<args; ++i)
    [invocation setArgument:nil atIndex:i];
  [invocation invoke];
  id result = nil;
  if ([invocation.methodSignature methodReturnLength] == sizeof(id))
    [invocation getReturnValue:&result];
  return result;
}
@end
