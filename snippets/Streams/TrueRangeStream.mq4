// True range stream v1.0

#include <AStream.mq4>

#ifndef TrueRangeStream_IMP
#define TrueRangeStream_IMP

class TrueRangeStream : public AStream
{
public:
   TrueRangeStream(const string symbol, ENUM_TIMEFRAMES timeframe)
      :AStream(symbol, timeframe)
   {
   }

   bool GetValue(const int period, double &val)
   {
      int pos = Size() - period - 1;
      if (pos < 1)
      {
         return false;
      }
      double hl = MathAbs(iHigh(_symbol, _timeframe, pos) - iLow(_symbol, _timeframe, pos));
      double hc = MathAbs(iHigh(_symbol, _timeframe, pos) - iClose(_symbol, _timeframe, pos + 1));
      double lc = MathAbs(iLow(_symbol, _timeframe, pos) - iClose(_symbol, _timeframe, pos + 1));

      val = MathMax(lc, MathMax(hl, hc));
      return true;
   }
};
#endif