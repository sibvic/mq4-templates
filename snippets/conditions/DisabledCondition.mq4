// Disabled condition v1.1

#include <ACondition.mq4>

#ifndef DisabledCondition_IMP
#define DisabledCondition_IMP
class DisabledCondition : public ACondition
{
public:
   bool IsPass(const int period) { return false; }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      return "Disabled";
   }
};
#endif