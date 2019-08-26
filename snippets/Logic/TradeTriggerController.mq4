// Trade trigger controller v1.0

#ifndef TradeTriggerController_IMP
#define TradeTriggerController_IMP
class TradeTriggerController
{
   int _order;
   IAction *_action;
public:
   TradeTriggerController()
   {
      _order = 0;
      _action = NULL;
   }

   bool SetAction(const int order, IAction *action)
   {
      if (_order != 0)
         return false;

      _order = order;
      _action = action;
      return true;
   }

   void DoLogic()
   {
      if (_order == 0)
         return;
      if (!OrderSelect(_order, SELECT_BY_TICKET, MODE_TRADES))
      {
         _order = 0;
         return;
      }
      int orderType = OrderType();
      if (orderType != OP_BUY && orderType != OP_SELL)
         return;

      _action.DoAction();
      _order = 0;
   }
};

#endif