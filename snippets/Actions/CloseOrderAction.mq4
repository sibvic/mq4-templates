// Close order action v1.0

#ifndef CloseOrderAction_IMP
#define CloseOrderAction_IMP

#include <AAction.mq4>

class CloseOrderAction : public AAction
{
   int _ticket;
   int _slippagePoints;
public:
   CloseOrderAction(int ticket, int slippagePoints)
   {
      _slippagePoints = slippagePoints;
      _ticket = ticket;
   }

   virtual bool DoAction(const int period, const datetime date)
   {
      if (!OrderSelect(_ticket, SELECT_BY_TICKET, MODE_TRADES) || OrderCloseTime() != 0.0)
      {
         return true;
      }

      string error;
      if (!TradingCommands::CloseCurrentOrder(_slippagePoints, error))
      {
         Print("Position close error: " + error);
         return false;
      }
      return true;
   }
};

#endif