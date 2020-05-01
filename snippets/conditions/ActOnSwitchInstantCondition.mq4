// Act on switch instant condition v1.0

#include <ACondition.mq4>

#ifndef ActOnSwitchInstantCondition_IMP
#define ActOnSwitchInstantCondition_IMP

class ActOnSwitchInstantCondition : public AConditionBase
{
   ICondition* _condition;
   bool _current;
   bool _last;
public:
   ActOnSwitchInstantCondition(ICondition* condition)
   {
      _last = false;
      _current = false;
      _condition = condition;
      _condition.AddRef();
   }

   ~ActOnSwitchInstantCondition()
   {
      _condition.Release();
   }

   virtual bool IsPass(const int period, const datetime date)
   {
      _last = _current;
      _current = _condition.IsPass(period, date);
      return _current && !_last;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      return _condition.GetLogMessage(period, date);
   }
};

#endif