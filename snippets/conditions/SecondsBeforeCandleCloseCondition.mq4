// Seconds before candle close v1.0

#ifndef SecondsBeforeCandleCloseCondition_IMP
#define SecondsBeforeCandleCloseCondition_IMP

#include <ACondition.mq4>

class SecondsBeforeCandleCloseCondition : public ACondition
{
   int _seconds;
public:
   SecondsBeforeCandleCloseCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int seconds)
      :ACondition(symbol, timeframe)
   {
      _seconds = seconds;
   }

   virtual bool IsPass(const int period)
   {
      int periodLength = GetPeriodLength();
      datetime currentTime = TimeCurrent();
      if (periodLength > 0)
      {
         long time1 = (long)MathFloor(currentTime / periodLength);
         long time2 = (long)MathFloor((currentTime + _seconds) / periodLength);
         return time1 != time2;
      }
      datetime dt1 = iTime(_symbol, _timeframe, 0);
      datetime dt2 = iTime(_symbol, _timeframe, 1);
      periodLength = (int)(dt1 - dt2);
      return currentTime + _seconds >= (dt1 + periodLength);
   }
private:
   int GetPeriodLength()
   {
      switch (_timeframe)
      {
         case PERIOD_M1:
            return 60;
         case PERIOD_M5:
            return 60 * 5;
         case PERIOD_M15:
            return 60 * 15;
         case PERIOD_M30:
            return 60 * 30;
         case PERIOD_H1:
            return 3600;
         case PERIOD_H4:
            return 3600 * 4;
         case PERIOD_D1:
            return 86400;
      }
      return 0;
   }
};
#endif