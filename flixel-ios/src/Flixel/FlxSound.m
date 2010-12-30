//
//  FlxSound.m
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

#import <AudioToolbox/AudioToolbox.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface FlxSound ()
- (void) stopped;
@end



// static NSMutableDictionary * sounds = nil;

@implementation FlxSound

// + (void) initialize
// {
//   if (self == [FlxSound class]) {
//     if (sounds == nil)
//       sounds = [[NSMutableDictionary alloc] init];
//   }
// }

// + (void) loadSound:(NSString *)filename
// {
//   NSValue * sound = [sounds objectForKey:filename];
//   if (sound)
//     return;

//   NSString * path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename];

//   ALuint source;
//   ALuint soundBuffer;
//   void * soundData;

//   alGenSources(1, &source);

//   AudioStreamBasicDescription dataFormat;
//   AudioFileID audioFileID;
//   UInt32 dataFormatSize = sizeof(dataFormat);
//   UInt64 byteCount;
//   UInt32 byteCountSize = sizeof(byteCount);
//   CFURLRef url = (CFURLRef)[NSURL URLWithString:path];
//   OSStatus result = noErr;
// #if TARGET_OS_IPHONE
//   result = AudioFileOpenURL(url, kAudioFileReadPermission, 0, &audioFileID);
// #else
//   result = AudioFileOpenURL(url, fsRdPerm, 0, &audioFileID);
// #endif
//   //assert no error
//   if (result != noErr)
//     NSLog(@"Error opening file (%@): %d", filename, (int)result);

//   result = AudioFileGetProperty(audioFileID, kAudioFilePropertyDataFormat, &dataFormatSize, &dataFormat);
//   //assert no error
//   if (result != noErr)
//     NSLog(@"Error getting file format (%@): %d", filename, (int)result);

//   result = AudioFileGetProperty(audioFileID, kAudioFilePropertyAudioDataByteCount, &byteCountSize, &byteCount);

//   if (result != noErr)
//     NSLog(@"Error getting file data size (%@): %d", filename, (int)result);

//   UInt32 byteCount32 = (UInt32)byteCount;

//   soundData = malloc(byteCount32);

//   result = AudioFileReadBytes(audioFileID, false, 0, &byteCount32, soundData);

//   if (result != noErr)
//     NSLog(@"Error reading file data (%@): %d", filename, (int)result);

//   alGenBuffers(1, &soundBuffer);

//   result = alGetError();
//   if (result != AL_NO_ERROR)
//     NSLog(@"Error generating buffer (%@): %x", filename, (int)result);

//   ALenum alDataFormat;
//   if (dataFormat.mFormatID != kAudioFormatLinearPCM)
//     alDataFormat = -1;
//   else if ((dataFormat.mChannelsPerFrame > 2) ||
//       (dataFormat.mChannelsPerFrame < 1))
//     alDataFormat = -1;
//   else if (dataFormat.mBitsPerChannel == 8)
//     alDataFormat = (dataFormat.mChannelsPerFrame == 1) ? AL_FORMAT_MONO8 : AL_FORMAT_STEREO8;
//   else if (dataFormat.mBitsPerChannel == 16)
//     alDataFormat = (dataFormat.mChannelsPerFrame == 1) ? AL_FORMAT_MONO16 : AL_FORMAT_STEREO16;
//   else
//     alDataFormat = -1;

//   alBufferDataStaticProc(soundBuffer,
// 			 alDataFormat,
// 			 soundData,
// 			 byteCount32,
// 			 dataFormat.mSampleRate);

//   result = alGetError();
//   if (result != AL_NO_ERROR)
//     NSLog(@"Error attaching data to buffer (%@): %x", filename, (int)result);

//   AudioFileClose(audioFileID);

//   alSourcei(source, AL_BUFFER, soundBuffer);

//   float volume = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SoundEffectsVolume"] floatValue];

//   alSourcef(source, AL_GAIN, volume);

//   result = alGetError();
//   if (result != AL_NO_ERROR)
//     NSLog(@"Error attaching file data to effect (%@): %x", filename, (int)result);

//   SoundParameters * sp = (SoundParameters *)malloc(sizeof(SoundParameters));
//   sp->source = source;
//   sp->buffer = soundBuffer;
//   sp->data = soundData;
//   sp->dataFormat = alDataFormat;
//   sp->byteCount = byteCount32;
//   sp->sampleRate = dataFormat.mSampleRate;
//   sp->volume = 1.0;
//   [sounds setObject:[NSValue valueWithPointer:sp] forKey:filename];

// }

// @synthesize survive;
@synthesize volume=_volume;

- (id) init;
{
  if ((self = [super init])) {
//       [_point2 autorelease];
// _point2 = [[[[FlxPoint alloc] init] autorelease] retain];
//       [_transform autorelease];
// _transform = [[[[SoundTransform alloc] init] autorelease] retain];
//       [self doInit];
//       fixed = YES;
    soundParameters = NULL;
  }
  return self;
}
- (void) dealloc
{
//   [_sound release];
//   [_point2 release];
//   [_transform release];
//   [_core release];
//   [_channel release];
  [super dealloc];
}
- (void) doInit;
{
//    _transform.pan = 0;
//    [_sound autorelease];
// _sound = [nil retain];
//    _position = 0;
//    _volume = 1;
//    _volumeAdjust = 1;
//    _looped = NO;
//    [_core autorelease];
// _core = [nil retain];
//    _radius = 0;
//    _pan = NO;
//    _fadeOutTimer = 0;
//    _fadeOutTotal = 0;
//    _pauseOnFadeOut = NO;
//    _fadeInTimer = 0;
//    _fadeInTotal = 0;
//    active = NO;
//    visible = NO;
//    solid = NO;
}
- (FlxSound *) loadEmbedded:(NSString *)EmbeddedSound;
{
   return [self loadEmbeddedWithParam1:EmbeddedSound param2:NO];
}
- (FlxSound *) loadEmbeddedWithParam1:(NSString *)EmbeddedSound param2:(BOOL)Looped;
{
//   [self loadSound:EmbeddedSound];

  
//   soundParameters = [FlxG getSoundParameters:EmbeddedSound];
  
//    [self stop];
//    [self doInit];
//    [_sound autorelease];
// _sound = [[[[EmbeddedSound alloc] init] autorelease] retain];
//    _looped = Looped;
//    [self updateTransform];
//    active = YES;
  return self;
}
- (FlxSound *) loadStream:(NSString *)SoundURL;
{
   return [self loadStreamWithParam1:SoundURL param2:NO];
}
- (FlxSound *) loadStreamWithParam1:(NSString *)SoundURL param2:(BOOL)Looped;
{
//    [self stop];
//    [self doInit];
//    [_sound autorelease];
// _sound = [[[[Sound alloc] initWithParam1:[[[URLRequest alloc] initWithParam1:SoundURL] autorelease]] autorelease] retain];
//    _looped = Looped;
//    [self updateTransform];
//    active = YES;
    return self;
}
- (FlxSound *) proximityWithParam1:(float)X param2:(float)Y param3:(FlxObject *)Core param4:(float)Radius;
{
   return [self proximityWithParam1:X param2:Y param3:Core param4:Radius param5:YES];
}
- (FlxSound *) proximityWithParam1:(float)X param2:(float)Y param3:(FlxObject *)Core param4:(float)Radius param5:(BOOL)Pan;
{
//   x = X;
//   y = Y;
//   [_core autorelease];
//   _core = [Core retain];
//   _radius = Radius;
//   _pan = Pan;
   return self;
}
- (void) play;
{
//   if (_position < 0)
//     return;
//    if (_looped)
//       {
//          if (_position == 0)
//             {
//                if (_channel == nil)
//                   [_channel autorelease];
// _channel = [[_sound playWithParam1:0 param2:9999 param3:_transform] retain];
//                if (_channel == nil)
//                   active = NO;
//             }
//          else
//             {
//                [_channel autorelease];
// _channel = [[_sound playWithParam1:_position param2:0 param3:_transform] retain];
//                if (_channel == nil)
//                   active = NO;
//                else
//                   [_channel addEventListenerWithParam1:Event.SOUND_COMPLETE param2:looped];
//             }
//       }
//    else
//       {
//          if (_position == 0)
//             {
//                if (_channel == nil)
//                   {
//                      [_channel autorelease];
// _channel = [[_sound playWithParam1:0 param2:0 param3:_transform] retain];
//                      if (_channel == nil)
//                         active = NO;
//                      else
//                         [_channel addEventListenerWithParam1:Event.SOUND_COMPLETE param2:stopped];
//                   }
//             }
//          else
//             {
//                [_channel autorelease];
// _channel = [[_sound playWithParam1:_position param2:0 param3:_transform] retain];
//                if (_channel == nil)
//                   active = NO;
//             }
//       }
//    _position = 0;
}
- (void) pause;
{
//    if (_channel == nil)
//       {
//          _position = -1;
//          return;
//       }
//    _position = _channel.position;
//    [_channel stop];
//    if (_looped)
//       {
//          while (_position >= _sound.length)
//             _position -= _sound.length;
//       }
//    [_channel autorelease];
// _channel = [nil retain];
}
- (void) stop;
{
//    _position = 0;
//    if (_channel != nil)
//       {
//          [_channel stop];
//          [self stopped];
//       }
}
- (void) fadeOut:(float)Seconds;
{
   return [self fadeOutWithParam1:Seconds param2:NO];
}
- (void) fadeOutWithParam1:(float)Seconds param2:(BOOL)PauseInstead;
{
//    _pauseOnFadeOut = PauseInstead;
//    _fadeInTimer = 0;
//    _fadeOutTimer = Seconds;
//    _fadeOutTotal = _fadeOutTimer;
}
- (void) fadeIn:(float)Seconds;
{
//    _fadeOutTimer = 0;
//    _fadeInTimer = Seconds;
//    _fadeInTotal = _fadeInTimer;
//    [self play];
}
- (float) volume;
{
   return _volume;
}
- (void) setVolume:(float)Volume;
{
//    _volume = Volume;
//    if (_volume < 0)
//       _volume = 0;
//    else
//       if (_volume > 1)
//          _volume = 1;
//    [self updateTransform];
}
- (void) updateSound;
{
//    if (_position != 0)
//       return;
//    float radial = 1;
//    float fade = 1;
//    if (_core != nil)
//       {
//          FlxPoint * _point = [[[FlxPoint alloc] init] autorelease];
//          FlxPoint * _point2 = [[[FlxPoint alloc] init] autorelease];
//          [_core getScreenXY:_point];
//          [self getScreenXY:_point2];
//          float dx = _point.x - _point2.x;
//          float dy = _point.y - _point2.y;
//          radial = (_radius - sqrt(dx * dx + dy * dy)) / _radius;
//          if (radial < 0)
//             radial = 0;
//          if (radial > 1)
//             radial = 1;
//          if (_pan)
//             {
//                float d = -dx / _radius;
//                if (d < -1)
//                   d = -1;
//                else
//                   if (d > 1)
//                      d = 1;
//                _transform.pan = d;
//             }
//       }
//    if (_fadeOutTimer > 0)
//       {
//          _fadeOutTimer -= FlxG.elapsed;
//          if (_fadeOutTimer <= 0)
//             {
//                if (_pauseOnFadeOut)
//                   [self pause];
//                else
//                   [self stop];
//             }
//          fade = _fadeOutTimer / _fadeOutTotal;
//          if (fade < 0)
//             fade = 0;
//       }
//    else
//       if (_fadeInTimer > 0)
//          {
//             _fadeInTimer -= FlxG.elapsed;
//             fade = _fadeInTimer / _fadeInTotal;
//             if (fade < 0)
//                fade = 0;
//             fade = 1 - fade;
//          }
//    _volumeAdjust = radial * fade;
//    [self updateTransform];
}
- (void) update;
{
//    [super update];
//    [self updateSound];
}
- (void) destroy;
{
//    if (active)
//       [self stop];
}
- (void) updateTransform;
{
//    _transform.volume = [FlxG getMuteValue] * FlxG.volume * _volume * _volumeAdjust;
//    if (_channel != nil)
//       _channel.soundTransform = _transform;
}
// - (void) looped;
// {
//     return [self looped:nil];
// }
// - (void) looped:(Event *)event;
// {
// //    if (_channel == nil)
// //       return;
// //    [_channel removeEventListenerWithParam1:Event.SOUND_COMPLETE param2:looped];
// //    [_channel autorelease];
// // _channel = [nil retain];
// //    [self play];
// }
- (void) stopped;
{
//    return [self stopped:nil];
// }
// - (void) stopped:(Event *)event;
// {
//    if (!_looped)
//       [_channel removeEventListenerWithParam1:Event.SOUND_COMPLETE param2:stopped];
//    else
//       [_channel removeEventListenerWithParam1:Event.SOUND_COMPLETE param2:looped];
//    [_channel autorelease];
// _channel = [nil retain];
//    active = NO;
}
@end
