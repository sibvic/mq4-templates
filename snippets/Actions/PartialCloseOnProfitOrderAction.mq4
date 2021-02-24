#include <PartialCloseOrderAction.mq4>
#include <AOrderAction.mq4>
#include <../Logic/ActionOnConditionLogic.mq4>
#include <../TradingCalculator.mq4>
#include <../Signaler.mq4>
// v1.1

class PartialCloseOnProfitOrderAction : public AOrderAction
{
   StopLimitType _triggerType;
   double _trigger;
   double _toClose;
   TradingCalculator *_calculator;
   Signaler *_signaler;
   ActionOnConditionLogic* _actions;
public:
   PartialCloseOnProfitOrderAction(const StopLimitType triggerType, const double trigger,
      const double toClose, Signaler *signaler, ActionOnConditionLogic* actions)
   {
      _calculator = NULL;
      _signaler = signaler;
      _triggerType = triggerType;
      _trigger = trigger;
      _toClose = toClose;
      _actions = actions;
   }

   ~PartialCloseOnProfitOrderAction()
   {
      delete _calculator;
   }

   void RestoreActions(string symbol, int magicNumber)
   {
      
   }

   virtual bool DoAction(const int period, const datetime date)
   {
      if (!OrderSelect(_currentTicket, SELECT_BY_TICKET, MODE_TRADES) || OrderCloseTime() != 0.0)
         return false;

      string symbol = OrderSymbol();
      if (_calculator == NULL || symbol != _calculator.GetSymbol())
      {
         delete _calculator;
         _calculator = TradingCalculator::Create(symbol);
         if (_calculator == NULL)
            return false;
      }
      int isBuy = TradingCalculator::IsBuyOrder();
      double basePrice = OrderOpenPrice();
      double triggerValue = _calculator.CalculateTakeProfit(isBuy, _trigger, _triggerType, OrderLots(), basePrice);

      if (!OrderSelect(_currentTicket, SELECT_BY_TICKET, MODE_TRADES))
         return true;
      IOrder *order = new OrderByTicketId(_currentTicket);
      HitProfitCondition* condition = new HitProfitCondition();
      condition.Set(order, triggerValue);
      IAction* action = new PartialCloseOrderAction(order, _toClose, slippage_points);
      order.Release();
      _actions.AddActionOnCondition(action, condition);
      condition.Release();
      action.Release();
      return true;
   }
};