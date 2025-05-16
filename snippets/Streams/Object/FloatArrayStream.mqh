// Float array stream v1.1

#ifndef FloatArrayStream_IMPL
#define FloatArrayStream_IMPL

#include <Streams/Custom/TStream.mqh>
#include <PineScript/Array/SimpleTypeArray.mqh>

class FloatArrayStream : public TStream<ISimpleTypeArray<double>*>
{
public:
   FloatArrayStream(const string symbol, const ENUM_TIMEFRAMES timeframe, ISimpleTypeArray<double>* emptyValue)
      : TStream<ISimpleTypeArray<double>*>(symbol, timeframe, emptyValue)
   {
   }
};
#endif