// No condition v1.0

#ifndef NoCondition_IMP

class NoCondition : public ICondition
{
public:
   bool IsPass(const int period) { return true; }
};

#define NoCondition_IMP

#endif