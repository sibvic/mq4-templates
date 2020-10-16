#include <../AOnStream.mq4>

// Zero lag MA on stream v1.0

#ifndef ZeroLagMAOnStream_IMP
#define ZeroLagMAOnStream_IMP

class ZeroLagMAOnStream : public AOnStream
{
   int _length;
   double _buffer[];
   double _alpha;
public:
   ZeroLagMAOnStream(IStream *source, const int length)
      :AOnStream(source)
   {
      _length = length;
      _alpha = 2.0 / (1.0 + _length);
   }

   bool GetValue(const int period, double &val)
   {
      int totalBars = Bars;
      if (ArrayRange(_buffer, 0) != totalBars) 
         ArrayResize(_buffer, totalBars);
      
      if (period > totalBars - 1)
         return false;

      double price;
      if (!_source.GetValue(period, price))
         return false;

      int bufferIndex = totalBars - 1 - period;
      int shift = (int)((_length - 1.0) / 2.0);
      double prevPrice;
      if (period < shift || !_source.GetValue(period - shift, prevPrice))
      {
         _buffer[bufferIndex] = price;
         return true;
      }

      _buffer[bufferIndex] = _buffer[bufferIndex - 1] + _alpha * (2.0 * price - prevPrice - _buffer[bufferIndex - 1]);
      val = _buffer[bufferIndex];
      return true;
   }
};

#endif