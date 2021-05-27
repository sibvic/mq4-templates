// Max trades at day condition v1.1
#include <ACondition.mq4>
#include <../OrdersIterator.mq4>
#include <../ClosedOrdersIterator.mq4>

#ifndef DayTradesLimitCondition_IMP
#define DayTradesLimitCondition_IMP
class DayTradesLimitCondition : public ACondition
{
   int _magicNumber;
   int _maxNumber;
public:
   DayTradesLimitCondition(const string symbol, int magicMumber, int maxNumber)
      :ACondition(symbol, PERIOD_D1)
   {
      _magicNumber = magicMumber;
      _maxNumber = maxNumber;
   }

   bool IsPass(const int period, const datetime date)
   {
      MqlDateTime current_time;
      if (!TimeToStruct(iTime(_symbol, _timeframe, period), current_time))
      {
         return false;
      }
      OrdersIterator trades;
      trades.WhenSymbol(_symbol);
      trades.WhenTrade();
      trades.WhenMagicNumber(_magicNumber);
      int count = 0;
      while (trades.Next())
      {
         MqlDateTime trade_time;
         if (!TimeToStruct(trades.GetOpenTime(), trade_time))
         {
            return false;
         }
         if (trade_time.year == current_time.year && trade_time.mon == current_time.mon && trade_time.day == current_time.day)
         {
            count++;
         }
      }
      ClosedOrdersIterator closedTrades;
      closedTrades.WhenSymbol(_symbol);
      closedTrades.WhenMagicNumber(_magicNumber);
      while (closedTrades.Next())
      {
         MqlDateTime trade_time;
         if (!TimeToStruct(closedTrades.GetOpenTime(), trade_time))
         {
            return false;
         }
         if (trade_time.year == current_time.year && trade_time.mon == current_time.mon && trade_time.day == current_time.day)
         {
            count++;
         }
      }
      return count < _maxNumber;
   }
};
#endif