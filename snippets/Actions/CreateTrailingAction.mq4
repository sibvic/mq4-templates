// Create trailing action v1.0

#include <../conditions/ProfitInRangeCondition.mq4>
#include <TrailingPipsAction.mq4>
#include <../Logic/ActionOnConditionLogic.mq4>
#include <AOrderAction.mq4>

#ifndef CreateTrailingAction_IMP
#define CreateTrailingAction_IMP

class CreateTrailingAction : public AOrderAction
{
   double _start;
   double _step;
   ActionOnConditionLogic* _actions;
public:
   CreateTrailingAction(double start, double step, ActionOnConditionLogic* actions)
   {
      _start = start;
      _step = step;
      _actions = actions;
   }

   virtual bool DoAction()
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

      TrailingPipsAction* action = new TrailingPipsAction(order, distance, _step);
      ProfitInRangeCondition* condition = new ProfitInRangeCondition(order, 0, _start);
      _actions.AddActionOnCondition(action, condition);
      condition.Release();
      action.Release();

      order.Release();

      return true;
   }
};

#endif