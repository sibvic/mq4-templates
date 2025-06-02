#ifndef ConditionStreamV2_IMPL
#define ConditionStreamV2_IMPL
#include <Streams/Abstract/TAStream.mqh>
#include <Conditions/ICondition.mqh>

//ConditionStreamV2 v2.0

class ConditionStreamV2 : public TAStream<int>
{
protected:
   ICondition* _condition;
public:
   ConditionStreamV2(ICondition* condition)
   {
      _condition = condition;
      _condition.AddRef();
   }

   ~ConditionStreamV2()
   {
      _condition.Release();
   }

   virtual int Size()
   {
      return iBars(_Symbol, (ENUM_TIMEFRAMES)_Period);
   }

   bool GetValue(const int period, int &val)
   {
      val = _condition.IsPass(period, 0);
      return true;
   }
};
#endif