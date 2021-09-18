#include <Actions/PartialCloseOrderAction.mqh>
#include <Actions/AOrderAction.mqh>
#include <Logic/ActionOnConditionLogic.mqh>
#include <TradingCalculator.mqh>
#include <Signaler.mqh>
#include <Conditions/HitProfitCondition.mqh>
// v1.3

class PartialCloseOnProfitOrderAction : public AOrderAction
{
   StopLimitType _triggerType;
   double _trigger;
   double _toClose;
   TradingCalculator *_calculator;
   Signaler *_signaler;
   ActionOnConditionLogic* _actions;
   int _slippagePoints;
public:
   PartialCloseOnProfitOrderAction(const StopLimitType triggerType, const double trigger,
      const double toClose, Signaler *signaler, ActionOnConditionLogic* actions, int slippagePoints)
   {
      _slippagePoints = slippagePoints;
      _calculator = NULL;
      _signaler = signaler;
      _triggerType = triggerType;
      _trigger = trigger;
      _toClose = toClose;
      _actions = actions;
   }

   ~PartialCloseOnProfitOrderAction()
   {
      if (_calculator != NULL)
      {
         _calculator.Release();
      }
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
         if (_calculator != NULL)
         {
            _calculator.Release();
         }
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
      IAction* action = new PartialCloseOrderAction(order, _calculator.NormalizeLots(OrderLots() * _toClose / 100.0), _slippagePoints);
      order.Release();
      _actions.AddActionOnCondition(action, condition);
      condition.Release();
      action.Release();
      return true;
   }
};