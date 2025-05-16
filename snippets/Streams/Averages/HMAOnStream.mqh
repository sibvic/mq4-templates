// HMA on stream v2.0

#ifndef HMAOnStream_IMP
#define HMAOnStream_IMP
#include <Streams/Averages/WMAOnStream.mqh>
#include <Streams/AOnStream.mqh>
#include <Streams/Custom/FloatStream.mqh>

class HMAOnStream : public AOnStream
{
   int _length;
   WMAOnStream* wmaHalf;
   WMAOnStream* wma;
   WMAOnStream* wmaOnDiff;
   FloatStream* diff;
public:
   HMAOnStream(TIStream<double>* source, const int length)
      : AOnStream(source)
   {
      _length = length;
      wmaHalf = new WMAOnStream(source, MathFloor(length / 2 + 0.5));
      wma = new WMAOnStream(source, length);
      diff = new FloatStream(_Symbol, (ENUM_TIMEFRAMES)_Period);
      wmaOnDiff = new WMAOnStream(diff, MathFloor(MathSqrt(length) + 0.5));
   }

   ~HMAOnStream()
   {
      wmaHalf.Release();
      wma.Release();
      diff.Release();
      wmaOnDiff.Release();
   }

   bool GetValue(const int period, double &val)
   {
      double n2ma;
      if (!wmaHalf.GetValue(period, n2ma))
      {
         return false;
      }
      n2ma *= 2;
      double nma;
      if (!wma.GetValue(period, nma))
      {
         return false;
      }
      diff.SetValue(period, n2ma - nma);

      return wmaOnDiff.GetValue(period, val);
   }
};
#endif