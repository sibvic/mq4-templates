#include <AConditionBase.mq4>

// New bar condition v1.0

#ifndef NewBarCondition_IMP
#define NewBarCondition_IMP

class NewBarCondition : public AConditionBase
{
   datetime _lastDate;
public:
   NewBarCondition()
      :AConditionBase("New bar")
   {
      _lastDate = 0;
   }

   virtual bool IsPass(const int period, const datetime date)
   {
      if (_lastDate == 0)
      {
         _lastDate = date;
         return false;
      }
      if (_lastDate == date)
      {
         return false;
      }
      _lastDate = date;
      return true;
   }
};

#endif