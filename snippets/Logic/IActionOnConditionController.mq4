// Action on condition controller interface v1.0

#ifndef IActionOnConditionController_IMP
#define IActionOnConditionController_IMP

class IActionOnConditionController
{
public:
   virtual bool Set(IAction* action, ICondition *condition) = 0;
   virtual void DoLogic(const int period, datetime date) = 0;
};

#endif