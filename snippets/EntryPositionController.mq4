#include <conditions/ICondition.mq4>
#include <enums/OrderSide.mq4>
#include <ICloseOnOppositeStrategy.mq4>
#include <Signaler.mq4>
#include <IMoneyManagementStrategy.mq4>
#include <IEntryStrategy.mq4>
#include <OrderHandlers.mq4>

// Entry position controller v1.0

#ifndef EntryPositionController_IMP
#define EntryPositionController_IMP

class EntryPositionController
{
   bool _includeLog;
   ICondition* _condition;
   ICondition* _filterCondition;
   OrderSide _side;
   ICloseOnOppositeStrategy *_closeOnOpposite;
   Signaler* _signaler;
   IMoneyManagementStrategy *_moneyManagement[];
   IEntryStrategy *_entryStrategy;
   string _algorithmId;
   string _alertMessage;
   OrderHandlers* _orderHandlers;
public:
   EntryPositionController(OrderSide side, ICondition* condition, ICondition* filterCondition, IEntryStrategy *entryStrategy,
      ICloseOnOppositeStrategy *closeOnOpposite, OrderHandlers* orderHandlers, Signaler* signaler, 
      string algorithmId, string alertMessage)
   {
      _orderHandlers = orderHandlers;
      _orderHandlers.AddRef();
      _algorithmId = algorithmId;
      _filterCondition = filterCondition;
      _filterCondition.AddRef();
      _entryStrategy = entryStrategy;
      _entryStrategy.AddRef();
      _signaler = signaler;
      _side = side;
      _includeLog = false;
      _condition = NULL;
      _condition = condition;
      _condition.AddRef();
      _closeOnOpposite = closeOnOpposite;
      _closeOnOpposite.AddRef();
   }

   ~EntryPositionController()
   {
      _orderHandlers.Release();
      _entryStrategy.Release();
      _closeOnOpposite.Release();
      _condition.Release();
      _filterCondition.Release();
      
      for (int i = 0; i < ArraySize(_moneyManagement); ++i)
      {
         delete _moneyManagement[i];
      }
   }

   void IncludeLog()
   {
      _includeLog = true;
   }

   void AddMoneyManagement(IMoneyManagementStrategy *moneyManagement)
   {
      int count = ArraySize(_moneyManagement);
      ArrayResize(_moneyManagement, count + 1);
      _moneyManagement[count] = moneyManagement;
   }

   bool DoEntry(int period, datetime date, string& logMessage)
   {
      if (_includeLog)
      {
         logMessage = _condition.GetLogMessage(period, date);
      }
      if (!_condition.IsPass(period, date))
      {
         return false;
      }
      if (_filterCondition != NULL && !_filterCondition.IsPass(period, date))
      {
         return false;
      }
      _closeOnOpposite.DoClose(GetOppositeSide(_side));
      
      for (int i = 0; i < ArraySize(_moneyManagement); ++i)
      {
         int order = _entryStrategy.OpenPosition(period, _side, _moneyManagement[i], _algorithmId);
         if (order >= 0)
         {
            _orderHandlers.DoAction(order);
         }
      }
      _signaler.SendNotifications(_alertMessage);
      return true;
   }
};

#endif