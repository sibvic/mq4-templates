#include <Streams/ConditionStream.mqh>
#include <Conditions/StreamStreamCondition.mqh>
#include <enums/TwoStreamsConditionType.mqh>

//AOnStream v1.0

class CrossunderStream : public ConditionStream
{
public:
   CrossunderStream(IStream *left, IStream* right)
      :ConditionStream(new StreamStreamCondition(_Symbol, (ENUM_TIMEFRAMES)_Period, FirstCrossUnderSecond, left, right, "", ""))
   {
      _condition.Release();
   }
};