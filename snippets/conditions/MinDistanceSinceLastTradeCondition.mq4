// Min distance since last trade condition v1.0

#include <ACondition.mq4>
#include <../OrdersIterator.mq4>
#include <../ClosedOrdersIterator.mq4>

#ifndef MinDistanceSinceLastTradeCondition_IMP
#define MinDistanceSinceLastTradeCondition_IMP

class MinDistanceSinceLastTradeCondition : public ACondition
{
   int _minBars;
   int _magic_number;
public:
   MinDistanceSinceLastTradeCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int minBars, int magic_number)
      :ACondition(symbol, timeframe)
   {
      _minBars = minBars;
      _magic_number = magic_number;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      return "Min disatance since last trade: " + (IsPass(period, date) ? "true" : "false");
   }

   bool IsPass(const int period, const datetime date)
   {
      datetime orderDate = 0;

      OrdersIterator it;
      it.WhenTrade();
      it.WhenMagicNumber(_magic_number);
      while (it.Next())
      {
         if (orderDate < it.GetOpenTime())
         {
            orderDate = it.GetOpenTime();
         }
      }
      ClosedOrdersIterator it2;
      it2.WhenMagicNumber(_magic_number);
      while (it2.Next())
      {
         if (orderDate < it2.GetOpenTime())
         {
            orderDate = it2.GetOpenTime();
         }
      }
      if (orderDate == 0)
         return true;
      int index = iBarShift(_symbol, _timeframe, orderDate);
      Print(index);
      return _minBars <= index;
   }
};

#endif