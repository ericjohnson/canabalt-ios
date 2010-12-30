//
//  FlxSave.h
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

@interface FlxSave : NSObject
{
  //Object * data;
  NSString * name;
  NSMutableDictionary * data;
  //SharedObject * _so;
}
@property(nonatomic,copy) NSString * name;
//@property(nonatomic,retain) Object * data;
@property(nonatomic,readonly) NSMutableDictionary * data;
- (id) init;
- (BOOL) bind:(NSString *)Name;
- (BOOL) writeWithParam1:(NSString *)FieldName param2:(id)FieldValue;
- (BOOL) writeWithParam1:(NSString *)FieldName param2:(id)FieldValue param3:(unsigned int)MinFileSize;
- (id) read:(NSString *)FieldName;
- (BOOL) forceSave;
- (BOOL) forceSave:(unsigned int)MinFileSize;
- (BOOL) erase;
- (BOOL) erase:(unsigned int)MinFileSize;
@end
