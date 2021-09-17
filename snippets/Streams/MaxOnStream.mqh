#include <AOnStream.mqh>
//v1.0

class MaxOnStream : public AOnStream
{
   int _length;
public:
   MaxOnStream(IStream *source, const int length)
      :AOnStream(source)
   {
      _length = length;
   }

   bool GetValue(const int period, double &val)
   {
      if (!_source.GetValue(period, val))
      {
         return false;
      }
      for (int i = 1; i < period; ++i)
      {
         double current;
         if (!_source.GetValue(period + i, current))
         {
            return false;
         }
         val = MathMax(val, current);
      }
      return true;
   }
};