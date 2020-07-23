#include <AConditionBase.mq4>

// Trade by day of week condition v1.0

#ifndef DayOfWeekCondition_IMP
#define DayOfWeekCondition_IMP

class DayOfWeekCondition : public AConditionBase
{
   bool _flags[7];
public:
   DayOfWeekCondition()
      :AConditionBase("Trade by day of week")
   {

   }

   void SetDayOfweekFlag(int dayOfWeek, bool flag)
   {
      _flags[dayOfWeek] = flag;
   }

   virtual bool IsPass(const int period, const datetime date)
   {
      MqlDateTime current_time;
      if (!TimeToStruct(TimeCurrent(), current_time))
         return false;
      return _flags[current_time.day_of_week];
   }
};

#endif