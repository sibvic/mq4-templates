#include <../conditions/ProfitInRangeCondition.mqh>
#include <TrailingPipsAction.mqh>
#include <../Logic/ActionOnConditionLogic.mqh>
#include <AOrderAction.mqh>

// Create ATR Trailing action v1.0

class CreateATRTrailingAction : public AOrderAction
{
   double _step;
   ActionOnConditionLogic* _actions;
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
   int _period;
public:
   CreateATRTrailingAction(string symbol, ENUM_TIMEFRAMES timeframe, int period, double step, ActionOnConditionLogic* actions)
   {
      _step = step;
      _actions = actions;
      _symbol = symbol;
      _timeframe = timeframe;
      _period = period;
   }

   virtual void RestoreActions(string symbol, int magicNumber)
   {
      
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

      double distance = (OrderOpenPrice() - OrderStopLoss()) / pipSize;

      double atrValue = iATR(_symbol, _timeframe, _period, period) / pipSize;
      TrailingPipsAction* action = new TrailingPipsAction(order, distance, _step);
      ProfitInRangeCondition* condition = new ProfitInRangeCondition(order, atrValue, 100000);
      _actions.AddActionOnCondition(action, condition);
      condition.Release();
      action.Release();

      order.Release();

      return true;
   }
};