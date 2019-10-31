// Disabled condition v2.0

#include <ACondition.mq4>

#ifndef DisabledCondition_IMP
#define DisabledCondition_IMP
class DisabledCondition : public ACondition
{
public:
   bool IsPass(const int period, const datetime date) { return false; }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      return "Disabled";
   }
};
#endif