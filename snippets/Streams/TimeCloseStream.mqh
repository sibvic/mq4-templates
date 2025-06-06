#include <Streams/Abstract/TAStream.mqh>
#include <PineScript/Time.mqh>

// Time close stream v1.0

#ifndef TimeCloseMSStream_IMP
#define TimeCloseMSStream_IMP

class TimeCloseStream : public TAStream<int>
{
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
public:
   TimeCloseStream(const string symbol, ENUM_TIMEFRAMES timeframe)
      :TAStream()
   {
      _symbol = symbol;
      _timeframe = timeframe;
   }

   bool GetValue(const int period, int &val)
   {
      datetime time = iTime(_symbol, _timeframe, period);

      val = PineScriptTime::ToMS(time) + _timeframe * 60000;
      return true;
   }
   
   int Size()
   {
      return iBars(_symbol, _timeframe);
   }
};
#endif