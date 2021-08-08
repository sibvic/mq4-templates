// Fix NAN stream v1.0

#include <AOnStream.mq4>

class FixnanStream : public AOnStream
{
   int _maxLookback;
public:
   FixnanStream(IStream *source)
      :AOnStream(source)
   {
      _maxLookback = 1000;
   }

   bool GetValue(const int period, double &val)
   {
      for (int i = 0; i < _maxLookback; ++i)
      {
         if (_source.GetValue(period + i, val))
         {
            return true;
         }
      }

      return false;
   }
};