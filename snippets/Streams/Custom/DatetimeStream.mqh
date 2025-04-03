// Custom datetime stream v1.0

#ifndef DatetimeStream_IMPL
#define DatetimeStream_IMPL

#include <Streams/Custom/TStream.mqh>

class DatetimeStream : public TStream<datetime>
{
public:
   DatetimeStream(const string symbol, const ENUM_TIMEFRAMES timeframe)
      : TStream<datetime>(symbol, timeframe, INT_MIN)
   {
   }
};
#endif