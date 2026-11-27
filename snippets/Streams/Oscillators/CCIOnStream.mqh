#include <Streams/AOnStream.mqh>

// CCI on stream v3.0
// cci = (source - sma) / (0.015 * meanDeviation)
// meanDeviation is the average of abs(source - sma) over the same window.
// A flat window (mean deviation 0) returns 0.

#ifndef CCIOnStream_IMP
#define CCIOnStream_IMP

class CCIOnStream : public AOnStream
{
   int _length;
public:
   CCIOnStream(TIStream<double> *source, const int length)
      :AOnStream(source)
   {
      _length = length;
   }

   bool GetValue(const int period, double &val)
   {
      if (_length < 1)
      {
         return false;
      }
      double sum = 0;
      for (int i = 0; i < _length; ++i)
      {
         double price;
         if (!_source.GetValue(period + i, price))
         {
            return false;
         }
         sum += price;
      }
      double mean = sum / _length;
      double devSum = 0;
      for (int i = 0; i < _length; ++i)
      {
         double price;
         if (!_source.GetValue(period + i, price))
         {
            return false;
         }
         devSum += MathAbs(price - mean);
      }
      double meanDev = devSum / _length;
      if (meanDev == 0.0)
      {
         val = 0.0;
         return true;
      }
      double src;
      if (!_source.GetValue(period, src))
      {
         return false;
      }
      val = (src - mean) / (0.015 * meanDev);
      return true;
   }
};

#endif
