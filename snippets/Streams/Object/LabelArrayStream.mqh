// Label array stream v2.0

#ifndef LabelArrayStream_IMPL
#define LabelArrayStream_IMPL

#include <Streams/Custom/TStream.mqh>
#include <PineScript/Array/CustomTypeArray.mqh>
#include <PineScript/Objects/Label.mqh>

class LabelArrayStream : public TStream<ICustomTypeArray<Label*>*>
{
public:
   LabelArrayStream(const string symbol, const ENUM_TIMEFRAMES timeframe, ICustomTypeArray<Label*>* defaultValue = NULL)
      : TStream<ICustomTypeArray<Label*>*>(symbol, timeframe, defaultValue)
   {
   }
};
#endif