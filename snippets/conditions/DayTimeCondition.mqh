#include <TradingTimeCondition.mqh>

// Day/time condition v1.0

#ifndef DayTimeCondition_IMP
#define DayTimeCondition_IMP

class DayTimeCondition : public TradingTimeCondition
{
   int _dayOfMonth;
public:
   DayTimeCondition(int dayOfMonth, int startTime, int intervalSeconds)
      :TradingTimeCondition(startTime, startTime + intervalSeconds)
   {
      _dayOfMonth = dayOfMonth;
   }

   virtual bool IsPass(const int period, const datetime date)
   {
      MqlDateTime current_time;
      if (!TimeToStruct(TimeCurrent(), current_time) || current_time.day != _dayOfMonth)
      {
         return false;
      }
      
      return TradingTimeCondition::IsPass(period, date);
   }
};

#endif