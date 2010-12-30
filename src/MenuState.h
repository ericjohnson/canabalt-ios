//
//  MenuState.h
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


@interface MenuState : FlxState
{
  FlxSprite * title;
  FlxSprite * title2;
  FlxButton * about;
  FlxButton * play;
  int state;
  int scoreState;
  
  FlxButton * back;
  FlxSprite * bar;
  FlxText * aboutTitle;

  FlxText * aboutText;

  FlxText * thanksText;
  NSArray * peopleTexts;
  NSArray * reasonTexts;

  FlxText * nowPlaying;
  FlxText * danny;

  NSMutableDictionary * moving;

  BOOL touchBeganInMusic;
  BOOL touchEndedInMusic;

}

@end

