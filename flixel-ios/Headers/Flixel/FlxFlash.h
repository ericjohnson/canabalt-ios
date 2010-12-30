//
//  FlxFlash.h
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

#import <Flixel/FlxSprite.h>

@interface FlxFlash : FlxSprite
{
   float _delay;
   FlashFunction * _complete;
}
- (id) init;
- (void) start;
- (void) start:(unsigned int)Color;
- (void) startWithParam1:(unsigned int)Color param2:(float)Duration;
- (void) startWithParam1:(unsigned int)Color param2:(float)Duration param3:(FlashFunction *)FlashComplete;
- (void) startWithParam1:(unsigned int)Color param2:(float)Duration param3:(FlashFunction *)FlashComplete param4:(BOOL)Force;
- (void) stop;
- (void) update;
@end
