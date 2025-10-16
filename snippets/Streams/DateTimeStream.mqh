#include <Streams/Abstract/TAStream.mqh>
#include <PineScript/Timeframe.mqh>
#include <PineScript/Time.mqh>
#include <Conditions/TimeFilterCondition.mqh>

// Date/time stream v1.2

#ifndef DateTimeStream_IMP
#define DateTimeStream_IMP

TimeFilterCondition* CreateTimeFilter(string session)
{
   string items[];
   StringSplit(session, '-', items);
   if (ArraySize(items) != 2)
   {
      return NULL;
   }
   string error;
   int startTime = PineScriptTime::ParseTime(items[0], error);
   if (startTime == -1)
   {
      Print(error);
      return NULL;
   }
   int endTime = PineScriptTime::ParseTime(items[1], error);
   if (endTime == -1)
   {
      Print(error);
      return NULL;
   }
   return new TimeFilterCondition(startTime, endTime);
}

class DateTimeStream : public TAStream<datetime>
{
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
   ENUM_TIMEFRAMES _targetTimeframe;
   ICondition* _timeFilter;
public:
   DateTimeStream(const string symbol, ENUM_TIMEFRAMES timeframe)
   {
      _timeFilter = NULL;
      _symbol = symbol;
      _timeframe = timeframe;
      _targetTimeframe = timeframe;
   }
   DateTimeStream(const string symbol, ENUM_TIMEFRAMES timeframe, string targetTimeframe, string session, string timezone)
   {
      _timeFilter = CreateTimeFilter(session);
      _symbol = symbol;
      _timeframe = timeframe;
      _targetTimeframe = Timeframe::GetTimeframe(targetTimeframe);
   }
   ~DateTimeStream()
   {
      if (_timeFilter != NULL)
      {
         delete _timeFilter;
      }
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
      if (!_timeFilter.IsPass(period, val))
      {
         return false;
      }
      return true;
   }
   
   int Size()
   {
      return iBars(_symbol, _timeframe);
   }
};
#endif