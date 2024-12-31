#include <ACondition.mqh>
#include <../enums/TwoStreamsConditionType.mqh>
// Bands conditions v1.0

#ifndef BB_Conditions_IMP
#define BB_Conditions_IMP

string GetPriceName(ENUM_APPLIED_PRICE price)
{
   switch (price)
   {
      case PRICE_CLOSE:
         return "Close";
      case PRICE_OPEN:
         return "Open";
      case PRICE_HIGH:
         return "High";
      case PRICE_LOW:
         return "Low";
      case PRICE_MEDIAN:
         return "Median";
      case PRICE_TYPICAL:
         return "Typical";
      case PRICE_WEIGHTED:
         return "Weighted";
   }
   return "";
}

class PriceBandsStreamCondition : public ACondition
{
   int _period;
   double _deviation;
   int _shift;
   ENUM_APPLIED_PRICE _price;
   TwoStreamsConditionType _condition;
   int _streamIndex;
public:
   PriceBandsStreamCondition(const string symbol, 
      ENUM_TIMEFRAMES timeframe, 
      TwoStreamsConditionType condition,
      int period,
      double deviation,
      int shift,
      ENUM_APPLIED_PRICE price,
      int streamIndex)
      :ACondition(symbol, timeframe)
   {
      _streamIndex = streamIndex;
      _condition = condition;
      _period = period;
      _deviation = deviation;
      _shift = shift;
      _price = price;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      bool result = IsPass(period, date);
      string sign = "";
      switch (_condition)
      {
         case FirstAboveSecond:
            sign = ">";
            break;
         case FirstBelowSecond:
            sign = "<";
            break;
         case FirstCrossOverSecond:
            sign = "co";
            break;
         case FirstCrossUnderSecond:
            sign = "cu";
            break;
      }
      return GetPriceName(_price) + " " + sign + " " + GetBBStreamName() + ": " + (IsPass(period, date) ? "true" : "false");
   }
   
   bool IsPass(const int period, const datetime date)
   {
      double price0 = GetPrice(period);
      double price1 = GetPrice(period + 1);
      double value0 = iBands(_symbol, _timeframe, _period, _deviation, _shift, _price, _streamIndex, period);
      double value1 = iBands(_symbol, _timeframe, _period, _deviation, _shift, _price, _streamIndex, period + 1);
      switch (_condition)
      {
         case FirstAboveSecond:
            return price0 > value0;
         case FirstBelowSecond:
            return price0 < value0;
         case FirstCrossOverSecond:
            return price0 >= value0 && price1 < value1;
         case FirstCrossUnderSecond:
            return price0 <= value0 && price1 > value1;
      }
      return false;
   }
private:
   string GetBBStreamName()
   {
      switch (_streamIndex)
      {
         case MODE_MAIN:
            return "Average";
         case MODE_UPPER:
            return "Upper";
         case MODE_LOWER:
            return "Lower";
      }
      return "";
   }
   double GetPrice(int period)
   {
      switch (_price)
      {
         case PRICE_CLOSE:
            return iClose(_symbol, _timeframe, period);
         case PRICE_OPEN:
            return iOpen(_symbol, _timeframe, period);
         case PRICE_HIGH:
            return iHigh(_symbol, _timeframe, period);
         case PRICE_LOW:
            return iLow(_symbol, _timeframe, period);
         case PRICE_MEDIAN:
            return (iHigh(_symbol, _timeframe, period) + iLow(_symbol, _timeframe, period)) / 2.0;
         case PRICE_TYPICAL:
            return (iHigh(_symbol, _timeframe, period) + iLow(_symbol, _timeframe, period) + iClose(_symbol, _timeframe, period)) / 3.0;
         case PRICE_WEIGHTED:
            return (iHigh(_symbol, _timeframe, period) + iLow(_symbol, _timeframe, period) + iClose(_symbol, _timeframe, period) * 2) / 4.0;
      }
      return 0;
   }
};

#endif