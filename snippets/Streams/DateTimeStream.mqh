#include <Streams/Abstract/ADateTimeStream.mqh>

// Date/time stream v1.0

#ifndef DateTimeStream_IMP
#define DateTimeStream_IMP

class DateTimeStream : public ADateTimeStream
{
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
public:
   DateTimeStream(const string symbol, ENUM_TIMEFRAMES timeframe)
   {
      _symbol = symbol;
      _timeframe = timeframe;
   }
   ~DateTimeStream()
   {
   }

   bool GetValue(const int period, datetime &val)
   {
      if (iBars(_symbol, _timeframe) <= period)
      {
         return false;
      }
      val = iTime(_symbol, _timeframe, period);
      return true;
   }
   
   int Size()
   {
      return iBars(_symbol, _timeframe);
   }
};
#endif