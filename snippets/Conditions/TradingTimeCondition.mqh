// Trading time condition v3.3

#include <Conditions/AConditionBase.mqh>
#include <Conditions/NoCondition.mqh>
#include <enums/DayOfWeek.mqh>
#include <PineScript/Time.mqh>

#ifndef TradingTimeCondition_IMP
#define TradingTimeCondition_IMP

ICondition* CreateTradingTimeCondition(const string startTime, const string endTime, bool useWeekly,
   const DayOfWeek startDay, const string weekStartTime, const DayOfWeek stopDay, 
   const string weekEndTime, string &error)
{
   int _startTime = PineScriptTime::ParseTime(startTime, error);
   if (_startTime == -1)
   {
      return NULL;
   }
   int _endTime = PineScriptTime::ParseTime(endTime, error);
   if (_endTime == -1)
   {
      return NULL;
   }
   if (!useWeekly)
   {
      if (_startTime == _endTime)
      {
         return new NoCondition();
      }
      return new TradingTimeCondition(_startTime, _endTime);
   }

   int _weekStartTime = PineScriptTime::ParseTime(weekStartTime, error);
   if (_weekStartTime == -1)
   {
      return NULL;
   }
   int _weekEndTime = PineScriptTime::ParseTime(weekEndTime, error);
   if (_weekEndTime == -1)
   {
      return NULL;
   }

   return new TradingTimeCondition(_startTime, _endTime, startDay, _weekStartTime, stopDay, _weekEndTime);
}

class TradingTimeCondition : public AConditionBase
{
   int _startTime;
   int _endTime;
   bool _useWeekTime;
   int _weekStartTime;
   int _weekStartDay;
   int _weekStopTime;
   int _weekStopDay;
public:
   TradingTimeCondition(int startTime, int endTime)
      :AConditionBase("Trading Time")
   {
      _startTime = startTime;
      _endTime = endTime;
      _useWeekTime = false;
   }

   TradingTimeCondition(int startTime, int endTime, const DayOfWeek startDay,
      int weekStartTime, const DayOfWeek stopDay, int weekEndTime)
      :AConditionBase("Trading Time")
   {
      _startTime = startTime;
      _endTime = endTime;
      _useWeekTime = true;
      _weekStartDay = (int)startDay;
      _weekStopDay = (int)stopDay;
      _weekStartTime = weekStartTime;
      _weekStopTime = weekEndTime;
   }

   virtual bool IsPass(const int period, const datetime date)
   {
      MqlDateTime current_time;
      if (!TimeToStruct(TimeCurrent(), current_time))
         return false;
      if (!PineScriptTime::IsIntradayTradingTime(current_time, _startTime, _endTime))
         return false;
      return IsWeeklyTradingTime(current_time);
   }

   void GetStartEndTime(const datetime date, datetime &start, datetime &end)
   {
      MqlDateTime current_time;
      if (!TimeToStruct(date, current_time))
         return;

      current_time.hour = 0;
      current_time.min = 0;
      current_time.sec = 0;
      datetime referece = StructToTime(current_time);

      start = referece + _startTime;
      end = referece + _endTime;
      if (_startTime > _endTime)
      {
         start += 86400;
      }
   }
private:
   bool IsWeeklyTradingTime(const MqlDateTime &current_time)
   {
      if (!_useWeekTime)
         return true;
      if (current_time.day_of_week < _weekStartDay || current_time.day_of_week > _weekStopDay)
         return false;

      if (current_time.day_of_week == _weekStartDay)
      {
         int current_t = TimeToInt(current_time);
         return current_t >= _weekStartTime;
      }
      if (current_time.day_of_week == _weekStopDay)
      {
         int current_t_ = TimeToInt(current_time);
         return current_t_ < _weekStopTime;
      }

      return true;
   }
};

class TokyoTimezoneCondition : public TradingTimeCondition
{
public:
   TokyoTimezoneCondition()
      : TradingTimeCondition((-5) * 3600, (-5 + 9) * 3600)
   {

   }
   
   virtual string GetLogMessage(const int period, const datetime date)
   {
      bool result = IsPass(period, date);
      return "Tokyo TZ: " + (result ? "true" : "false");
   }
};

class NewYorkTimezoneCondition : public TradingTimeCondition
{
public:
   NewYorkTimezoneCondition()
      : TradingTimeCondition(8 * 3600, (8 + 9) * 3600)
   {

   }
   
   virtual string GetLogMessage(const int period, const datetime date)
   {
      bool result = IsPass(period, date);
      return "NY TZ: " + (result ? "true" : "false");
   }
};

class LondonTimezoneCondition : public TradingTimeCondition
{
public:
   LondonTimezoneCondition()
      : TradingTimeCondition(3 * 3600, (3 + 9) * 3600)
   {

   }
   
   virtual string GetLogMessage(const int period, const datetime date)
   {
      bool result = IsPass(period, date);
      return "London TZ: " + (result ? "true" : "false");
   }
};

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