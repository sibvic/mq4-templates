#include <AConditionBase.mqh>

// Hit equity level condition v1.0

#ifndef HitEquityLevelCondition_IMP
#define HitEquityLevelCondition_IMP

class HitEquityLevelCondition : public AConditionBase
{
   double _level;
public:
   HitEquityLevelCondition(double level)
   {
      _level = level;
   }

   virtual bool IsPass(const int period, const datetime date)
   {
      return AccountEquity() >= _level;
   }
};

#endif