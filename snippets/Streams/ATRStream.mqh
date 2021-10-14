#include <Streams/TrueRangeStream.mqh>
#include <Streams/Averages/SmaOnStream.mqh>

// Average true range stream v2.0

#ifndef ATRStream_IMP
#define ATRStream_IMP

class ATRStream : public AStream
{
   IStream* _avg;
public:
   ATRStream(const string symbol, ENUM_TIMEFRAMES timeframe, int length)
      :AStream(symbol, timeframe)
   {
      IStream* tr = new TrueRangeStream(symbol, timeframe, true);
      _avg = new SmaOnStream(tr, length);
      tr.Release();
   }
   ~ATRStream()
   {
      _avg.Release();
   }

   bool GetValue(const int period, double &val)
   {
      return _avg.GetValue(period, val);
   }
};
#endif