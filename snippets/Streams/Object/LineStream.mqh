// Line stream v1.1

#ifndef LineStream_IMPL
#define LineStream_IMPL

#include <PineScript/Objects/Line.mqh>
#include <Streams/Custom/TStream.mqh>

class LineStream : public TStream<Line*>
{
public:
   LineStream(const string symbol, const ENUM_TIMEFRAMES timeframe, Line* emptyValue = NULL)
      : TStream(symbol, timeframe, emptyValue)
   {
   }
};
#endif