// Act on switch condition v1.0
#ifndef ActOnSwitchCondition_IMP
// And condition v1.0
class ActOnSwitchCondition : public ICondition
{
   ICondition* _condition;
public:
   ActOnSwitchCondition(ICondition* condition)
   {
      _condition = condition;
   }

   ~ActOnSwitchCondition()
   {
      delete _condition;
   }

   virtual bool IsPass(const int period)
   {
      return _condition.IsPass(period) && !_condition.IsPass(period + 1);
   }
};
#define ActOnSwitchCondition_IMP
#endif