#include <../conditions/ProfitInRangeCondition.mq4>
#include <TrailingPipsAction.mq4>
#include <../Logic/ActionOnConditionLogic.mq4>
#include <AOrderAction.mq4>

// Create trailing action v3.0

#ifndef CreateTrailingAction_IMP
#define CreateTrailingAction_IMP

// Automatically saves data about trailing as globals.
// You need to call RestoreActions() after creation of this object to restore tracking of old trades.
class CreateTrailingAction : public AOrderAction
{
   double _start;
   double _step;
   bool _startInPercent;
   ActionOnConditionLogic* _actions;
public:
   CreateTrailingAction(double start, bool startInPercent, double step, ActionOnConditionLogic* actions)
   {
      _startInPercent = startInPercent;
      _start = start;
      _step = step;
      _actions = actions;
   }

   void RestoreActions(string symbol, int magicNumber)
   {
      OrdersIterator trades;
      trades.WhenSymbol(symbol).WhenTrade().WhenMagicNumber(magicNumber);
      while (trades.Next())
      {
         int ticketId = trades.GetTicket();
         string ticketIdStr = IntegerToString(ticketId);
         double step = GlobalVariableGet("tr_" + ticketIdStr + "_stp");
         if (step == 0)
         {
            continue;
         }
         double start = GlobalVariableGet("tr_" + ticketIdStr + "_strt");
         if (start == 0)
         {
            continue;
         }
         double distance = GlobalVariableGet("tr_" + ticketIdStr + "_d");
         if (distance == 0)
         {
            continue;
         }
         OrderByTicketId* order = new OrderByTicketId(ticketId);
         TrailingPipsAction* action = new TrailingPipsAction(order, distance, step);
         ProfitInRangeCondition* condition = new ProfitInRangeCondition(order, start, 100000);
         _actions.AddActionOnCondition(action, condition);
         condition.Release();
         action.Release();
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

      double distance = (OrderOpenPrice() - OrderStopLoss()) / pipSize;
      double start = _startInPercent ? distance * _start / 100.0 : _start;

      string ticketIdStr = IntegerToString(_currentTicket);
      GlobalVariableSet("tr_" + ticketIdStr + "_stp", _step);
      GlobalVariableSet("tr_" + ticketIdStr + "_strt", start);
      GlobalVariableSet("tr_" + ticketIdStr + "_d", distance);
      
      TrailingPipsAction* action = new TrailingPipsAction(order, distance, _step);
      ProfitInRangeCondition* condition = new ProfitInRangeCondition(order, start, 100000);
      _actions.AddActionOnCondition(action, condition);
      condition.Release();
      action.Release();

      order.Release();

      return true;
   }
};

#endif