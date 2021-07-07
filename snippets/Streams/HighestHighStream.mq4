#include <AOnStream.mq4>
// Highest high stream v1.1

class HighestHighStream : public AOnStream
{
   int _loopback;
public:
   HighestHighStream(IStream* source, int loopback)
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
         val = MathMax(val, value);
      }
      return true;
   }
};