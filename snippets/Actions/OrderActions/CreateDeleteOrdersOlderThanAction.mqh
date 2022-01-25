// Closes order when it's older than given number of bars. v1.0

#include <Actions/AOrderAction.mqh>
#include <Actions/CloseOrderAction.mqh>
#include <Logic/ActionOnConditionLogic.mqh>
#include <OrdersIterator.mqh>
#include <Order/OrderByTicketId.mqh>
#include <Actions/TrailingPipsAction.mqh>
#include <Conditions/OrderOlderThanCondition.mqh>

class CreateDeleteOrdersOlderThanAction : public AOrderAction
{
   int _bars;
   ActionOnConditionLogic* _actions;
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
   int _slippagePoints;
public:
   CreateDeleteOrdersOlderThanAction(string symbol, ENUM_TIMEFRAMES timeframe, int bars, ActionOnConditionLogic* actions, int slippagePoints)
   {
      _slippagePoints = slippagePoints;
      _bars = bars;
      _symbol = symbol;
      _timeframe = timeframe;
   }

   void RestoreActions(string symbol, int magicNumber)
   {
      OrdersIterator trades;
      trades.WhenSymbol(symbol).WhenTrade().WhenMagicNumber(magicNumber);
      while (trades.Next())
      {
         int ticketId = trades.GetTicket();
         string ticketIdStr = IntegerToString(ticketId);
         int bars = GlobalVariableGet("ll_" + ticketIdStr + "_bars");
         if (bars == 0)
         {
            continue;
         }
         OrderByTicketId* order = new OrderByTicketId(ticketId);
         AddAction(order, bars, ticketId);
         order.Release();
      }
   }

   virtual bool DoAction(const int period, const datetime date)
   {
      OrderByTicketId* order = new OrderByTicketId(_currentTicket);
      if (!order.Select() || OrderStopLoss() == 0)
      {
         order.Release();
         return false;
      }

      double point = MarketInfo(OrderSymbol(), MODE_POINT);
      int digits = (int)MarketInfo(OrderSymbol(), MODE_DIGITS);
      int mult = digits == 3 || digits == 5 ? 10 : 1;
      double pipSize = point * mult;

      string ticketIdStr = IntegerToString(_currentTicket);
      GlobalVariableSet("ll_" + ticketIdStr + "_bars", _bars);
      AddAction(order, _bars, _currentTicket);
      order.Release();

      return true;
   }
private:
   void AddAction(IOrder* order, int bars, int ticketId)
   {
      CloseOrderAction* action = new CloseOrderAction(ticketId, _slippagePoints);
      OrderOlderThanCondition* condition = new OrderOlderThanCondition(_symbol, _timeframe, order, bars);
      _actions.AddActionOnCondition(action, condition);
      condition.Release();
      action.Release();
   }
};