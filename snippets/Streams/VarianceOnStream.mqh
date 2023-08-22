// Variance on stream v1.0

#include <Streams/AOnStream.mqh>

class VarianceOnStream : public AOnStream
{
   int _length;
   bool _biased;
public:
   VarianceOnStream(IStream *source, int length, bool biased)
      :AOnStream(source)
   {
      _length = length;
      _biased = biased;
   }

   bool GetValue(const int period, double &val)
   {
      if (_length == 1)
      {
         return false;
      }
      if (!_biased)
      {
         return false; // not supported yet
      }
      //period is an index for time series (0 = latest)
      int totalBars = Bars;

      double values[];
      ArrayResize(values, _length);

      double sum = 0;
      for (int i = 0; i < _length; ++i)
      {
         double current;
         if (!_source.GetValue(period + i, current))
         {
            return false;
         }
         values[i] = current;
         sum += current;
      }
      double diffSumm = 0;
      for (int i = 0; i < _length; ++i)
      {
         diffSumm += MathSqrt(values[i] - sum);
      }
      val = diffSumm / (_length - 1);
      return true;
   }
};