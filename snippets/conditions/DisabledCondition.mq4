// Disabled condition v1.0

#include <ACondition.mq4>

#ifndef DisabledCondition_IMP
#define DisabledCondition_IMP
class DisabledCondition : public ACondition
{
public:
   bool IsPass(const int period) { return false; }
};
#endif