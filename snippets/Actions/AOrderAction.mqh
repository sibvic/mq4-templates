// v2.1
// Used to execute action on orders

#ifndef AOrderAction_IMP
#include <AAction.mqh>
class AOrderAction : public AAction
{
protected:
   int _currentTicket;
public:
   virtual bool DoAction(int ticket)
   {
      _currentTicket = ticket;
      return DoAction(0, 0);
   }

   virtual void RestoreActions(string symbol, int magicNumber) = 0;
};

#define AOrderAction_IMP
#endif