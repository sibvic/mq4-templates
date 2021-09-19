#include <Streams/AOnStream.mqh>

// LWMA on stream v1.0

#ifndef LwmaOnStream_IMP
#define LwmaOnStream_IMP

class LwmaOnStream : public AOnStream
{
   int _length;
public:
   LwmaOnStream(IStream *source, const int length)
      :AOnStream(source)
   {
      _length = length;
   }

   bool GetValue(const int period, double &val)
   {
      int totalBars = Bars;
      double price;
      if (!_source.GetValue(period, price))
         return false;

      double sumw = _length;
      double sum = _length * price;
      for(int i = 1; i < _length; i++)
      {
         double weight = _length - i;
         sumw += weight;
         if (!_source.GetValue(period + i, price))
            return false;
         sum += weight * price;
      }
      val = sum / sumw;
      return true;
   }
};

#endif