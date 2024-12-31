// Not condition v2.0

#include <Conditions/AConditionBase.mqh>

#ifndef NotCondition_IMP
#define NotCondition_IMP

class NotCondition : public AConditionBase
{
   ICondition* _condition;
public:
   NotCondition(ICondition* condition)
   {
      _condition = condition;
      _condition.AddRef();
   }

   ~NotCondition()
   {
      _condition.Release();
   }

   bool IsPass(const int period, const datetime date)
   {
      return !_condition.IsPass(period, date); 
   }
};

#endif