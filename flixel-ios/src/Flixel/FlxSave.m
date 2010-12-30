//
//  FlxSave.m
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

@implementation FlxSave

@synthesize name;
@synthesize data;

- (id) init;
{
  if ((self = [super init])) {
    name = nil;
    //_so = nil;
    data = nil;
  }
  return self;
}
- (void) dealloc
{
  [name release];
  [data release];
  //[_so release];
  [super dealloc];
}
- (BOOL) bind:(NSString *)Name;
{
   [name autorelease];
   name = nil;
//    [_so autorelease];
//    _so = nil;
   [data autorelease];
   data = nil;
   name = [Name retain];
//    @try
//       {
// 	//[_so autorelease];
// 	//_so = [[SharedObject getLocal:name] retain];
//       }
//    @catch (Error * e)
//       {
//          [FlxG log:@"WARNING: There was a problem binding to\nthe shared object data from FlxSave."];
//          [name autorelease];
// 	 name = nil;
//          [_so autorelease];
// 	 _so = nil;
//          [data autorelease];
// 	 data = nil;
//          return NO;
//       }
   [data autorelease];
   data = [[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:name]] retain];
   //data = [_so.data retain];
   return YES;
}
- (BOOL) writeWithParam1:(NSString *)FieldName param2:(id)FieldValue;
{
   return [self writeWithParam1:FieldName param2:FieldValue param3:0];
}
- (BOOL) writeWithParam1:(NSString *)FieldName param2:(id)FieldValue param3:(unsigned int)MinFileSize;
{
//    if (_so == nil)
  if (data == nil)
  {
    [FlxG log:@"WARNING: You must call FlxSave.bind()\nbefore calling FlxSave.write()."];
    return NO;
  }
  //[data objectAtIndex:FieldName] = FieldValue;
  [data setObject:FieldValue forKey:FieldName];
  return [self forceSave:MinFileSize];
}
- (id) read:(NSString *)FieldName;
{
   if (data == nil)
      {
         [FlxG log:@"WARNING: You must call FlxSave.bind()\nbefore calling FlxSave.read()."];
         return nil;
      }
   return [data objectForKey:FieldName];
}
- (BOOL) forceSave;
{
   return [self forceSave:0];
}
- (BOOL) forceSave:(unsigned int)MinFileSize;
{
   if (data == nil)
      {
         [FlxG log:@"WARNING: You must call FlxSave.bind()\nbefore calling FlxSave.forceSave()."];
         return NO;
      }
//    Object * status = nil;
//    @try
//       {
//          status = [_so flush:MinFileSize];
//       }
//    @catch (Error * e)
//       {
//          [FlxG log:@"WARNING: There was a problem flushing\nthe shared object data from FlxSave."];
//          return NO;
//       }
//    return status == SharedObjectFlushStatus.FLUSHED;
   [[NSUserDefaults standardUserDefaults] setObject:data forKey:name];
   return [[NSUserDefaults standardUserDefaults] synchronize];
}
- (BOOL) erase;
{
   return [self erase:0];
}
- (BOOL) erase:(unsigned int)MinFileSize;
{
   if (data == nil)
      {
         [FlxG log:@"WARNING: You must call FlxSave.bind()\nbefore calling FlxSave.erase()."];
         return NO;
      }
   //[_so clear];
   [data removeAllObjects];
   return [self forceSave:MinFileSize];
}
@end
