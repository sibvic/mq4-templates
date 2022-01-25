#include <Conditions/ACondition.mqh>
#include <Order/IOrder.mqh>

// Returns true when given order older that given number of bars. v1.0

class OrderOlderThanCondition : public ACondition
{
   int _bars;
   IOrder* _order;
public:
   OrderOlderThanCondition(const string symbol, ENUM_TIMEFRAMES timeframe, IOrder* order, int bars)
      :ACondition(symbol, timeframe)
   {
      _bars = bars;
      _order = order;
      _order.AddRef();
   }

   ~OrderOlderThanCondition()
   {
      _order.Release();
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      return "Order older that " + IntegerToString(_bars) + " bars: " + (IsPass(period, date) ? "true" : "false");
   }

   bool IsPass(const int period, const datetime date)
   {
      if (!_order.Select())
      {
         return true;
      }
      datetime orderDate = OrderGetInteger(ORDER_TYPE_TIME);
      if (orderDate == 0)
      {
         return true;
      }
      int index = iBarShift(_symbol, _timeframe, orderDate);
      return _bars <= index;
   }
};
