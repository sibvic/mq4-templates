// Label array stream v1.0

#ifndef LabelArrayStream_IMPL
#define LabelArrayStream_IMPL

#include <Streams/Custom/TStream.mqh>
#include <PineScript/Array/ITArray.mqh>
#include <PineScript/Objects/Label.mqh>

class LabelArrayStream : public TStream<ITArray<Label*>*>
{
public:
   LabelArrayStream(const string symbol, const ENUM_TIMEFRAMES timeframe)
      : TStream<ITArray<Label*>*>(symbol, timeframe, NULL)
   {
   }
};
#endif