// Lowest low stream v1.1

#include <AOnStream.mqh>

class LowestLowStream : public AOnStream
{
   int _loopback;
public:
   LowestLowStream(IStream* source, int loopback)
      :AOnStream(source)
   {
   }

   bool GetValue(const int period, double &val)
   {
      if (!_source.GetValue(period, val))
         return false;

      for (int i = 1; i < _loopback; ++i)
      {
         double value;
         if (!_source.GetValue(period + i, value))
            return false;
         val = MathMin(val, value);
      }
      return true;
   }
};