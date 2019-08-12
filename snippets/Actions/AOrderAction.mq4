// Order action (abstract) v1.0
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
      return DoAction();
   }
};

#define AOrderAction_IMP
#endif