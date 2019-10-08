// No condition v1.0

#include <ACondition.mq4>

#ifndef NoCondition_IMP
#define NoCondition_IMP

class NoCondition : public ACondition
{
public:
   bool IsPass(const int period) { return true; }
};

#endif