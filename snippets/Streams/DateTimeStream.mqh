#include <Streams/Abstract/TAStream.mqh>
#include <PineScript/Timeframe.mqh>

// Date/time stream v1.1

#ifndef DateTimeStream_IMP
#define DateTimeStream_IMP

class DateTimeStream : public TAStream<datetime>
{
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
   ENUM_TIMEFRAMES _targetTimeframe;
public:
   DateTimeStream(const string symbol, ENUM_TIMEFRAMES timeframe)
   {
      _symbol = symbol;
      _timeframe = timeframe;
      _targetTimeframe = timeframe;
   }
   DateTimeStream(const string symbol, ENUM_TIMEFRAMES timeframe, string targetTimeframe, string session, string timezone)
   {
      _symbol = symbol;
      _timeframe = timeframe;
      _targetTimeframe = Timeframe::GetTimeframe(targetTimeframe);
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
      int shift = iBarShift(_symbol, _targetTimeframe, iTime(_symbol, _timeframe, period));
      if (shift < 0)
      {
         return false;
      }
      val = iTime(_symbol, _targetTimeframe, shift);
      return true;
   }
   
   int Size()
   {
      return iBars(_symbol, _timeframe);
   }
};
#endif