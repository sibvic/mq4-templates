// Order action (abstract) v2.0
// Used to execute action on orders

#ifndef AOrderAction_IMP
#include <AAction.mq4>
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
};

#define AOrderAction_IMP
#endif