#include <AOrderAction.mq4>
#include <MoveToBreakevenAction.mq4>

// Move stop loss on profit order action v3.1

#ifndef MoveStopLossOnProfitOrderAction_IMP
#define MoveStopLossOnProfitOrderAction_IMP

// Automatically saves data about breakeven levels as globals.
// You need to call RestoreActions() after creation of this object to restore tracking of old trades.
class MoveStopLossOnProfitOrderAction : public AOrderAction
{
   StopLimitType _triggerType;
   double _trigger;
   double _target;
   TradingCalculator *_calculator;
   Signaler *_signaler;
   ActionOnConditionLogic* _actions;
public:
   MoveStopLossOnProfitOrderAction(const StopLimitType triggerType, const double trigger,
      const double target, Signaler *signaler, ActionOnConditionLogic* actions)
   {
      _calculator = NULL;
      _signaler = signaler;
      _triggerType = triggerType;
      _trigger = trigger;
      _target = target;
      _actions = actions;
   }

   ~MoveStopLossOnProfitOrderAction()
   {
      if (_calculator != NULL)
      {
         _calculator.Release();
      }
   }

   void RestoreActions(string symbol, int magicNumber)
   {
      OrdersIterator trades;
      trades.WhenSymbol(symbol).WhenTrade().WhenMagicNumber(magicNumber);
      while (trades.Next())
      {
         int ticketId = trades.GetTicket();
         string ticketIdStr = IntegerToString(ticketId);
         double trigger = GlobalVariableGet("be_" + ticketIdStr + "_tr");
         if (trigger == 0)
         {
            continue;
         }
         double target = GlobalVariableGet("be_" + ticketIdStr + "_ta");
         if (target == 0)
         {
            continue;
         }
         CreateBreakeven(ticketId, trigger, target, "");
      }
   }

   virtual bool DoAction(const int period, const datetime date)
   {
      if (!OrderSelect(_currentTicket, SELECT_BY_TICKET, MODE_TRADES) || OrderCloseTime() != 0.0)
      {
         return false;
      }

      string symbol = OrderSymbol();
      if (_calculator == NULL || symbol != _calculator.GetSymbol())
      {
         if (_calculator != NULL)
         {
            _calculator.Release();
         }
         _calculator = TradingCalculator::Create(symbol);
         if (_calculator == NULL)
         {
            return false;
         }
      }
      int isBuy = TradingCalculator::IsBuyOrder();
      double basePrice = OrderOpenPrice();
      double targetValue = _calculator.CalculateTakeProfit(isBuy, _target, StopLimitPips, OrderLots(), basePrice);
      double triggerValue = _calculator.CalculateTakeProfit(isBuy, _trigger, _triggerType, OrderLots(), basePrice);
      CreateBreakeven(_currentTicket, triggerValue, targetValue, "");
      return true;
   }
private:
   void CreateBreakeven(const int ticketId, const double trigger, const double target, const string name)
   {
      if (!OrderSelect(ticketId, SELECT_BY_TICKET, MODE_TRADES))
      {
         return;
      }
      string ticketIdStr = IntegerToString(ticketId);
      GlobalVariableSet("be_" + ticketIdStr + "_tr", trigger);
      GlobalVariableSet("be_" + ticketIdStr + "_ta", target);
      IOrder *order = new OrderByTicketId(ticketId);
      HitProfitCondition* condition = new HitProfitCondition();
      condition.Set(order, trigger);
      IAction* action = new MoveToBreakevenAction(target, name, order);
      order.Release();
      if (!_actions.AddActionOnCondition(action, condition))
      {
      }
      condition.Release();
      action.Release();
   }
};

#endif