#include <AOrderAction.mq4>
#include <TrailingStreamAction.mq4>
#include <../Streams/IStream.mq4>
// v1.0

#ifndef CreateTrailingStreamAction_IMP
#define CreateTrailingStreamAction_IMP

class CreateTrailingStreamAction : public AOrderAction
{
   double _start;
   IStream* _stream;
   bool _startInPercent;
   ActionOnConditionLogic* _actions;
public:
   CreateTrailingStreamAction(double start, bool startInPercent, IStream* stream, ActionOnConditionLogic* actions)
   {
      _stream = stream;
      _stream.AddRef();
      _startInPercent = startInPercent;
      _start = start;
      _actions = actions;
   }

   ~CreateTrailingStreamAction()
   {
      _stream.Release();
   }

   void RestoreActions(string symbol, int magicNumber)
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
      double start = _startInPercent ? distance * _start / 100.0 : _start;
      
      TrailingStreamAction* action = new TrailingStreamAction(order, _stream);
      ProfitInRangeCondition* condition = new ProfitInRangeCondition(order, start, 100000);
      _actions.AddActionOnCondition(action, condition);
      condition.Release();
      action.Release();

      order.Release();

      return true;
   }
};

#endif