//Move to breakeven action v1.1

#ifndef MoveToBreakevenAction_IMP
#define MoveToBreakevenAction_IMP

class MoveToBreakevenAction : public AAction
{
   Signaler* _signaler;
   double _trigger;
   double _target;
   InstrumentInfo *_instrument;
   IOrder* _order;
   string _name;
   double _refLots;
public:
   MoveToBreakevenAction(double trigger, double target, string name, IOrder* order, Signaler *signaler, double refLots = 0)
   {
      _signaler = signaler;
      _trigger = trigger;
      _target = target;
      _name = name;

      _order = order;
      _order.AddRef();
      _order.Select();
      string symbol = OrderSymbol();
      _instrument = new InstrumentInfo(symbol);
      _refLots = refLots;
   }

   ~MoveToBreakevenAction()
   {
      delete _instrument;
      _order.Release();
   }

   virtual bool DoAction()
   {
      if (!_order.Select() || OrderCloseTime() != 0 || (_refLots != 0 && _instrument.CompareLots(OrderLots(), _refLots) != 0))
      {
         return false;
      }
      int ticket = OrderTicket();
      string error;
      if (!TradingCommands::MoveSL(ticket, _target, error))
      {
         Print(error);
         return false;
      }
      if (_signaler != NULL)
      {
         _signaler.SendNotifications(GetNamePrefix() + "Trade " + IntegerToString(ticket) + " has reached " 
            + DoubleToString(_trigger, _instrument.GetDigits()) + ". Stop loss moved to " 
            + DoubleToString(_target, _instrument.GetDigits()));
      }
      return true;
   }
private:
   string GetNamePrefix()
   {
      if (_name == "")
         return "";
      return _name + ". ";
   }
};

#endif