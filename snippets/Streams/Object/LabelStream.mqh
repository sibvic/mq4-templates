// Label stream v1.0

#ifndef LabelStream_IMPL
#define LabelStream_IMPL

#include <Streams/Custom/TStream.mqh>
#include <Objects/Label.mqh>

class LabelStream : public TStream<Label*>
{
public:
   LabelStream(const string symbol, const ENUM_TIMEFRAMES timeframe)
      : (symbol, timeframe, NULL)
   {
   }
};
#endif