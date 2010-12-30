//
//  Trapezoid.m
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

#import "Trapezoid.h"

@implementation Trapezoid

- (void) setupVertices
{
  _verticesUVs[0] = (GLshort)0+self.frameHeight;
  _verticesUVs[1] = 0;
  _verticesUVs[4] = (GLshort)self.frameWidth-self.frameHeight;
  _verticesUVs[5] = 0;
  _verticesUVs[8] = 0;
  _verticesUVs[9] = (GLshort)self.frameHeight;
  _verticesUVs[12] = (GLshort)self.frameWidth;
  _verticesUVs[13] = (GLshort)self.frameHeight;
}

@end
