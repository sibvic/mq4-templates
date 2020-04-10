// Move take profit action v1.0

#ifndef MoveTakeProfitAction_IMP
#define MoveTakeProfitAction_IMP

class MoveTakeProfitAction : public AAction
{
   double _takeProfit;
   IOrder* _order;
public:
   MoveTakeProfitAction(double takeProfit, IOrder* order)
   {
      _takeProfit = takeProfit;
      _order = order;
      _order.AddRef();
   }

   ~MoveTakeProfitAction()
   {
      _order.Release();
   }

   virtual bool DoAction(const int period, const datetime date)
   {
      if (!_order.Select() || OrderCloseTime() != 0)
         return true;

      int ticket = OrderTicket();
      string errorMessage;
      bool success = TradingCommands::MoveTP(ticket, _takeProfit, errorMessage);
      return success && (errorMessage == NULL || errorMessage == "");
   }
};

#endif