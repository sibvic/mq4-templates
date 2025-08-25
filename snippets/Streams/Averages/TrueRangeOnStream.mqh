#include <Streams/Abstract/TAStream.mqh>
#include <Streams/IBarStream.mqh>

// True range on stream v1.0

#ifndef TrueRangeOnStream_IMP
#define TrueRangeOnStream_IMP

class TrueRangeOnStream : public TAStream<double>
{
   IBarStream* _source;
public:
   TrueRangeOnStream(IBarStream* source)
   {
      _source = source;
      _source.AddRef();
   }
   ~TrueRangeOnStream()
   {
      _source.Release();
   }

   bool GetValue(const int period, double &val)
   {
      double h, l, c1;
      if (!_source.GetHigh(period, h) || !_source.GetLow(period, l) || !_source.GetClose(period + 1, c1))
      {
         return false;
      }
      double hl = MathAbs(h - l);
      double hc = MathAbs(h - c1);
      double lc = MathAbs(l - c1);

      val = MathMax(lc, MathMax(hl, hc));
      return true;
   }
   
   int Size()
   {
      return _source.Size();
   }
};
#endif