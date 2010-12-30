//
//  CanabaltAppDelegate.m
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

#import "CanabaltAppDelegate.h"
#import "Canabalt.h"

#import <SemiSecret/SemiSecretTexture.h>

void preloadTextureAtlases()
{
  NSDictionary * infoDictionary = nil;
  if (FlxG.iPad)
    infoDictionary = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"iPadTextureAtlas.atlas"]];
  else
    infoDictionary = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"textureAtlas.atlas"]];

  //can only contain NSData, NSDate, NSNumber, NSString, NSArray, and NSDictionary

  NSDictionary * images = [infoDictionary objectForKey:@"images"];

  for (NSString * image in images) {
    NSDictionary * imageInfo = [images objectForKey:image];
    CGRect placement;
    placement.origin.x = [[imageInfo objectForKey:@"placement.origin.x"] floatValue];
    placement.origin.y = [[imageInfo objectForKey:@"placement.origin.y"] floatValue];
    placement.size.width = [[imageInfo objectForKey:@"placement.size.width"] floatValue];
    placement.size.height = [[imageInfo objectForKey:@"placement.size.height"] floatValue];
    NSString * atlas = [imageInfo objectForKey:@"atlas"];
    SemiSecretTexture * textureAtlas = [FlxG addTextureWithParam1:atlas param2:NO];
    SemiSecretTexture * texture = [SemiSecretTexture textureWithAtlasTexture:textureAtlas
						     offset:placement.origin
						     size:placement.size];
    [FlxG setTexture:texture forKey:image];
  }

}

@implementation CanabaltAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
  //in canabalt, we never want linear filtering (not even on ipad)
  [SemiSecretTexture setTextureFilteringMode:SSTextureFilteringNearest];
  
  [application setStatusBarOrientation:UIInterfaceOrientationLandscapeRight
	       animated:NO];

  game = [[Canabalt alloc] init];

  //preload textures here, now that opengl stuff should be created
  preloadTextureAtlases();
  
  return YES;
}

- (void) applicationDidEnterBackground:(UIApplication *)application
{
  [FlxG didEnterBackground];
}

- (void) applicationWillEnterForeground:(UIApplication *)application
{
  [FlxG willEnterForeground];
}

- (void) applicationWillResignActive:(UIApplication *)application
{
  [FlxG willResignActive];
}

- (void) applicationDidBecomeActive:(UIApplication *)application
{
  [FlxG didBecomeActive];
}

- (void) applicationWillTerminate:(UIApplication *)application
{
}

- (void) dealloc
{
  [game release];
  [super dealloc];
}

@end
