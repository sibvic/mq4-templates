// Move stream on stream v1.0
#include <AStreamBase.mqh>

#ifndef MoveStreamOnStream_IMP
#define MoveStreamOnStream_IMP
class MoveStreamOnStream : public AStreamBase
{
   IBarStream* _stream;
   string _symbol;
   ENUM_TIMEFRAMES _baseTimeframe;
public:
   MoveStreamOnStream(const string symbol, const ENUM_TIMEFRAMES baseTimeframe, IBarStream* stream)
   {
      _symbol = symbol;
      _baseTimeframe = baseTimeframe;
      _stream = stream;
      _stream.AddRef();
   }

   ~MoveStreamOnStream()
   {
      _stream.Release();
   }

   virtual bool GetValue(const int period, double &val)
   {
      int startIndex;
      if (!_stream.FindDatePeriod(iTime(_symbol, _baseTimeframe, period), startIndex))
         return false;
      int endIndex = 0;
      if (period != 0 && !_stream.FindDatePeriod(iTime(_symbol, _baseTimeframe, period - 1), endIndex))
         return false;
      val = 0;
      for (int i = startIndex; i >= endIndex; --i)
      {
         double open, close;
         if (!_stream.GetOpenClose(i, open, close))
            return false;
         val += MathAbs(close - open);
      }

      return true;
   }
};
#endif