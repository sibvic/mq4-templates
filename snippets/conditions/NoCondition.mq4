// No condition v2.0

#include <ACondition.mq4>

#ifndef NoCondition_IMP
#define NoCondition_IMP

class NoCondition : public ACondition
{
public:
   bool IsPass(const int period, const datetime date) { return true; }
};

#endif