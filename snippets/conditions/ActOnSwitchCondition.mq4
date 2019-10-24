// Act on switch condition v2.1

#include <ACondition.mq4>

#ifndef ActOnSwitchCondition_IMP
#define ActOnSwitchCondition_IMP

class ActOnSwitchCondition : public ACondition
{
   ICondition* _condition;
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
   bool _current;
   datetime _currentDate;
   bool _last;
public:
   ActOnSwitchCondition(string symbol, ENUM_TIMEFRAMES timeframe, ICondition* condition)
   {
      _last = false;
      _current = false;
      _currentDate = 0;
      _symbol = symbol;
      _timeframe = timeframe;
      _condition = condition;
   }

   ~ActOnSwitchCondition()
   {
      delete _condition;
   }

   virtual bool IsPass(const int period)
   {
      datetime time = iTime(_symbol, _timeframe, period);
      if (time != _currentDate)
      {
         _last = _current;
         _currentDate = time;
      }
      _current = _condition.IsPass(period);
      return _current && _last;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      return _condition.GetLogMessage(period, date);
   }
};
#endif