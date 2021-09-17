// Range stream v1.0

#include <AStreamBase.mqh>

#ifndef RangeStream_IMP
#define RangeStream_IMP
class RangeStream : public AStreamBase
{
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
public:
   RangeStream(const string symbol, const ENUM_TIMEFRAMES timeframe)
   {
      _symbol = symbol;
      _timeframe = timeframe;
   }

   virtual bool GetValue(const int period, double &val)
   {
      val = iHigh(_symbol, _timeframe, period) - iLow(_symbol, _timeframe, period);
      return true;
   }
};
#endif