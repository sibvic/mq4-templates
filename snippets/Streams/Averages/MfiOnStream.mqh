// MFI on stream v1.0

#ifndef MfiOnStream_IMP
#define MfiOnStream_IMP
#include <Streams/AOnStream.mqh>

class MfiOnStream : public AOnStream
{
   int _length;
public:
   MfiOnStream(IStream *source, const int length)
      :AOnStream(source)
   {
      _length = length;
   }

   bool GetValue(const int period, double &val)
   {
      double current;
      if (!_source.GetValue(period, current))
      {
         return false;
      }
      double upper = 0;
      double lower = 0;
      for (int i = 0; i < _length; i++)
      {
         double prev;
         if (!_source.GetValue(period + i + 1, prev))
         {
            continue;
         }
         if (prev - current >= 0)
         {
            upper += current * iVolume(_Symbol, (ENUM_TIMEFRAMES)_Period, period + i);
         }
         else
         {
            lower += current * iVolume(_Symbol, (ENUM_TIMEFRAMES)_Period, period + i);
         }
         current = prev;
      }
      if (lower == 0)
      {
         val = 100.0;
         return true;
      }
      val = 100.0 - (100.0 / (1.0 + upper / lower));
      return true;
   }
};

#endif