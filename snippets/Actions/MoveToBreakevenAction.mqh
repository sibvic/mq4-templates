#include <AAction.mqh>

//Move to breakeven action v3.0

#ifndef MoveToBreakevenAction_IMP
#define MoveToBreakevenAction_IMP

class MoveToBreakevenAction : public AAction
{
   double _target;
   InstrumentInfo *_instrument;
   IOrder* _order;
   string _name;
public:
   MoveToBreakevenAction(double target, string name, IOrder* order)
   {
      _target = target;
      _name = name;

      _order = order;
      _order.AddRef();
      _order.Select();
      string symbol = OrderSymbol();
      if (_instrument == NULL || symbol != _instrument.GetSymbol())
      {
         delete _instrument;
         _instrument = new InstrumentInfo(symbol);
      }
   }

   ~MoveToBreakevenAction()
   {
      delete _instrument;
      _order.Release();
   }

   virtual bool DoAction(const int period, const datetime date)
   {
      if (!_order.Select() || OrderCloseTime() != 0)
      {
         return false;
      }
      int ticketId = OrderTicket();
      string error;
      if (!TradingCommands::MoveSL(ticketId, _target, error))
      {
         Print(error);
         return false;
      }
      string ticketIdStr = IntegerToString(ticketId);
      GlobalVariableDel("be_" + ticketIdStr + "_ta");
      GlobalVariableDel("be_" + ticketIdStr + "_tr");
      return true;
   }
};

#endif