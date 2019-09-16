// Disabled condition v1.0
#ifndef DisabledCondition_IMP
#define DisabledCondition_IMP
#include <ICondition.mq4>
class DisabledCondition : public ICondition
{
public:
   bool IsPass(const int period) { return false; }
};
#endif