// No condition v2.1

#include <ACondition.mq4>

#ifndef NoCondition_IMP
#define NoCondition_IMP

class NoCondition : public ACondition
{
public:
   bool IsPass(const int period, const datetime date) { return true; }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      return "No condition";
   }
};

#endif