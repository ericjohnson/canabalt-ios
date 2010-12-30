//
//  Sequence.h
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


@class Sequence;
@class Player;
//@class RenderTexture;

@class Crane;
@class Building;
@class Hall;
@class Billboard;
@class GibEmitter;
@class DoveGroup;

@interface Sequence : FlxObject
{
  //NSMutableArray * mBlocks;
  FlxGroup * blocks;
  BOOL roof;
  int type;
  BOOL passed; //helps with the epitaph type tracking
  FlxGroup * foregroundLayer;
  FlxGroup * layer;
  FlxGroup * renderLayer;
  FlxGroup * backgroundRenderLayer;
  FlxGroup * layerLeg;
  Sequence * seq;
  Player * player;
//   NSArray * shardsA;
//   NSArray * shardsB;
  FlxEmitter * shardsA;
  FlxEmitter * shardsB;
  
//   RenderTexture * backgroundRenderTexture;
//   RenderTexture * renderTexture;
  
  NSArray * walls;
  NSArray * roofs;
  NSArray * floors;
  NSArray * windows;
  NSArray * antennas;

  Building * building;
  
  FlxTileblock * escape;
  FlxTileblock * fence;

  DoveGroup * doveGroup;
}

+ (id) sequenceWithPlayer:(Player *)player shardsA:(FlxEmitter *)shardsA shardsB:(FlxEmitter *)shardsB;
- (id) initWithPlayer:(Player *)player shardsA:(FlxEmitter *)shardsA shardsB:(FlxEmitter *)shardsB;

+ (void) setNextIndex:(int)ni;
+ (void) setNextType:(int)nt;
+ (void) setCurIndex:(int)ci;
+ (int) nextIndex;
+ (int) nextType;
+ (int) curIndex;

//These are just for helping with the epitaphs
+ (void) setLastType:(int)lt;
+ (void) setThisType:(int)tt;
- (int) lastType;
- (int) thisType;

- (int) getType;
- (void) reset;
- (void) clear;
- (void) aftermath;
- (void) stomp;

- (void) initSequence:(Sequence *)sequence;

//@property (readonly) NSArray * blocks;
@property (readonly) FlxGroup * blocks;

@end

