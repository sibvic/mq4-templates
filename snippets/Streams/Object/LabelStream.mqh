// Label stream v1.1

#ifndef LabelStream_IMPL
#define LabelStream_IMPL

#include <Streams/Custom/TStream.mqh>
#include <PineScript/Objects/Label.mqh>

class LabelStream : public TStream<Label*>
{
public:
   LabelStream(const string symbol, const ENUM_TIMEFRAMES timeframe, Label* emptyValue = NULL)
      : TStream<Label*>(symbol, timeframe, emptyValue)
   {
   }
};
#endif