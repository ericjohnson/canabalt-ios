//
//  FlxText.h
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

@class SemiSecretText;

@interface FlxText : FlxSprite
{
  SemiSecretText * sstext;
  //TextField * _tf;
   BOOL _regen;
   unsigned int _shadow;
  BOOL regen;
}
@property(nonatomic,copy) NSString * text;
@property(nonatomic,assign) float size;
@property(nonatomic,copy) NSString * alignment;
@property(nonatomic,assign) unsigned int shadow;
@property(nonatomic,copy) NSString * font;
@property(nonatomic,assign) unsigned int color;
+ (id) textWithWidth:(unsigned int)Width text:(NSString *)Text;
+ (id) textWithWidth:(unsigned int)Width text:(NSString *)Text font:(NSString *)Font size:(float)Size;
+ (id) textWithWidth:(unsigned int)Width text:(NSString *)Text font:(NSString *)Font size:(float)Size modelScale:(float)ModelScale;
- (id) initWithX:(float)X y:(float)Y width:(unsigned int)Width;
- (id) initWithX:(float)X y:(float)Y width:(unsigned int)Width modelScale:(float)ModelScale;
- (id) initWithX:(float)X y:(float)Y width:(unsigned int)Width text:(NSString *)Text;
- (id) initWithX:(float)X y:(float)Y width:(unsigned int)Width text:(NSString *)Text modelScale:(float)ModelScale;
- (FlxText *) setFormat;
- (FlxText *) setFormat:(NSString *)Font;
- (FlxText *) setFormatWithParam1:(NSString *)Font param2:(float)Size;
- (FlxText *) setFormatWithParam1:(NSString *)Font param2:(float)Size param3:(unsigned int)Color;
- (FlxText *) setFormatWithParam1:(NSString *)Font param2:(float)Size param3:(unsigned int)Color param4:(NSString *)Alignment;
- (FlxText *) setFormatWithParam1:(NSString *)Font param2:(float)Size param3:(unsigned int)Color param4:(NSString *)Alignment param5:(unsigned int)ShadowColor;
- (void) sizeToFit;
@property(nonatomic,readonly) SemiSecretText * sstext;
@end
