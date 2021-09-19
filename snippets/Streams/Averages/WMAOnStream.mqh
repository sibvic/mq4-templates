#include <Streams/AOnStream.mqh>

// WMA on stream v1.1

#ifndef WMAOnStream_IMP
#define WMAOnStream_IMP

class WMAOnStream : public AOnStream
{
   int _length;
   double _k;
   double _buffer[];
public:
   WMAOnStream(IStream *source, const int length)
      :AOnStream(source)
   {
      _length = length;
      _k = 1.0 / (_length);
   }

   bool GetValue(const int period, double &val)
   {
      int totalBars = _source.Size();
      if (ArrayRange(_buffer, 0) != totalBars) 
      {
         ArrayResize(_buffer, totalBars);
      }
      
      if (period > totalBars - _length)
      {
         return false;
      }

      int bufferIndex = totalBars - 1 - period;
      double current;
      if (!_source.GetValue(period, current))
      {
         return false;
      }
      
      double last = _buffer[bufferIndex - 1] != EMPTY_VALUE ? _buffer[bufferIndex - 1] : current;

      _buffer[bufferIndex] = (current - last) * _k + last;
      val = _buffer[bufferIndex];
      return true;
   }
};
#endif