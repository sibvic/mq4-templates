#include <Streams/Abstract/TAStream.mqh>
#include <PineScript/Timeframe.mqh>

// Date/time stream v1.0

#ifndef DateTimeStream_IMP
#define DateTimeStream_IMP

class DateTimeStream : public TAStream<datetime>
{
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
public:
   DateTimeStream(const string symbol, ENUM_TIMEFRAMES timeframe)
   {
      _symbol = symbol;
      _timeframe = timeframe;
   }
   DateTimeStream(const string symbol, string timeframe, string param1, string param2)
   {
      _symbol = symbol;
      _timeframe = Timeframe::GetTimeframe(timeframe);
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