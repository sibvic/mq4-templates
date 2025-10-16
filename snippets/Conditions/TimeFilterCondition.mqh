// Time filter condition v1.0

#include <Conditions/AConditionBase.mqh>
#include <PineScript/Time.mqh>

#ifndef TimeFilterCondition_IMP
#define TimeFilterCondition_IMP

class TimeFilterCondition : public AConditionBase
{
   int _startTime;
   int _endTime;
public:
   TimeFilterCondition(int startTime, int endTime)
      :AConditionBase("Trading Time")
   {
      _startTime = startTime;
      _endTime = endTime;
   }

   virtual bool IsPass(const int period, const datetime date)
   {
      MqlDateTime current_time;
      if (!TimeToStruct(date, current_time))
      {
         return false;
      }
      return PineScriptTime::IsIntradayTradingTime(current_time, _startTime, _endTime);
   }
};

#endif