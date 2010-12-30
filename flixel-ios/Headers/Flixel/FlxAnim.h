//
//  FlxAnim.h
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

@interface FlxAnim : NSObject
{
   NSString * name;
   float delay;
   NSMutableArray * frames;
   BOOL looped;
}
@property(nonatomic,assign) float delay;
@property(nonatomic,copy) NSString * name;
@property(nonatomic,assign) BOOL looped;
@property(nonatomic,copy) NSMutableArray * frames;
- (id) initWithParam1:(NSString *)Name param2:(NSMutableArray *)Frames;
- (id) initWithParam1:(NSString *)Name param2:(NSMutableArray *)Frames param3:(float)FrameRate;
- (id) initWithParam1:(NSString *)Name param2:(NSMutableArray *)Frames param3:(float)FrameRate param4:(BOOL)Looped;

// begin manually added for 'prettiness'
- (id) initWithName:(NSString *)Name frames:(NSMutableArray *)Frames;
- (id) initWithName:(NSString *)Name frames:(NSMutableArray *)Frames frameRate:(float)FrameRate;
- (id) initWithName:(NSString *)Name frames:(NSMutableArray *)Frames frameRate:(float)FrameRate looped:(BOOL)Looped;
// end manually added

@end
