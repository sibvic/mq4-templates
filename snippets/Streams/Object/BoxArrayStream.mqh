// Box array stream v1.0

#ifndef BoxArrayStream_IMPL
#define BoxArrayStream_IMPL

#include <Streams/Custom/TStream.mqh>

class BoxArrayStream : public TStream<IBoxArray*>
{
public:
   BoxArrayStream(const string symbol, const ENUM_TIMEFRAMES timeframe)
      : (symbol, timeframe, NULL)
   {
   }
};
#endif