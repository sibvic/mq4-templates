#include <../MoneyManagement/IMoneyManagementStrategy.mq4>
#include <../EntryStrategy.mq4>
#include <../OrderHandlers.mq4>

// Entry action v1.0

#ifndef EntryAction_IMP
#define EntryAction_IMP

class EntryAction : public AAction
{
   IEntryStrategy* _entryStrategy;
   OrderSide _side;
   IMoneyManagementStrategy* _moneyManagement;
   string _algorithmId;
   OrderHandlers* _orderHandlers;
public:
   EntryAction(IEntryStrategy* entryStrategy, OrderSide side, IMoneyManagementStrategy* moneyManagement, string algorithmId, OrderHandlers* orderHandlers)
   {
      _orderHandlers = orderHandlers;
      _orderHandlers.AddRef();
      _algorithmId = algorithmId;
      _moneyManagement = moneyManagement;
      _side = side;
      _entryStrategy = entryStrategy;
      _entryStrategy.AddRef();
   }

   ~EntryAction()
   {
      _orderHandlers.Release();
      _entryStrategy.Release();
      delete _moneyManagement;
   }

   virtual bool DoAction(const int period, const datetime date)
   {
      int order = _entryStrategy.OpenPosition(period, _side, _moneyManagement, _algorithmId);
      if (order >= 0)
      {
         _orderHandlers.DoAction(order);
      }
      return false;
   }
};

#endif