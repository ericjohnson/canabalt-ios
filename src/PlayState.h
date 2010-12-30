//
//  PlayState.h
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


@class Player;
@class Sequence;
@class HUD;
@class BG;
@class DoveGroup;
@class ShardManager;

@interface PlayState : FlxState
{
  Player * player;
  FlxSprite * focus;
  HUD * dist;
  BG * midground;
  BG * background;
  FlxSprite * backgroundRect;
  ShardManager * shardManagerA;
  ShardManager * shardManagerB;
  FlxEmitter * shardsA;
  FlxEmitter * shardsB;
  Sequence * seqA;
  Sequence * seqB;
  NSMutableArray * smoke;
  CGFloat gameover;
  NSString * epitaph;
  int distance;
  CGFloat flash;
  FlxSprite * exitOn;
  FlxSprite * exitOff;
  FlxSprite * pauseButton;
  FlxSprite * pausedSprite;
  FlxSprite * fadedSprite;
  BOOL paused;
  BOOL justPaused;
  BOOL reallyJustPaused;
  BOOL touching;
  BOOL lastTouching;
  BOOL touchBegan;
  BOOL touchEnded;
  BOOL pressedExit;
  BOOL pauseVisibility;
  FlxPoint * tmpP;
  BOOL firstTimeThroughUpdateLoop;
  DoveGroup * doveGroup;
}

@end
