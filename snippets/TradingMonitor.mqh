// Trades monitor v3.0

#include <actions/IAction.mqh>
#ifndef TradingMonitor_IMP
#define TradingMonitor_IMP

class TradingMonitor
{
   int active_ticket[1000];
   double active_type[1000];
   double active_price[1000];
   double active_stoploss[1000];
   double active_takeprofit[1000];
   bool active_still_active[1000];
   int active_total;
   IAction* _closedTradeAction;
   IAction* _orderChangedAction;
   IAction* _newOrderAction;
public:
   TradingMonitor()
   {
      _closedTradeAction = NULL;
      _orderChangedAction = NULL;
      _newOrderAction = NULL;
   }

   ~TradingMonitor()
   {
      if (_closedTradeAction != NULL)
         _closedTradeAction.Release();
      if (_orderChangedAction != NULL)
         _orderChangedAction.Release();
      if (_newOrderAction != NULL)
         _newOrderAction.Release();
   }

   void SetClosedTradeAction(IAction* action)
   {
      if (_closedTradeAction != NULL)
         _closedTradeAction.Release();
      _closedTradeAction = action;
      if (_closedTradeAction != NULL)
         _closedTradeAction.AddRef();
   }

   void SetOnOrderChanged(IAction* action)
   {
      if (_orderChangedAction != NULL)
         _orderChangedAction.Release();
      _orderChangedAction = action;
      if (_orderChangedAction != NULL)
         _orderChangedAction.AddRef();
   }

   void SetOnNewOrder(IAction* action)
   {
      if (_newOrderAction != NULL)
         _newOrderAction.Release();
      _newOrderAction = action;
      if (_newOrderAction != NULL)
         _newOrderAction.AddRef();
   }

   void DoWork()
   {
      bool changed = false;
      int total = OrdersTotal();
      for (int i = 0; i < total; i++)
      {
         if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
            continue;
         int ticket = OrderTicket();
         int index = getOrderCacheIndex(ticket);
         if (index == -1)
         {
            changed = true;
            if (_newOrderAction != NULL)
               _newOrderAction.DoAction(0, 0);
         }
         else
         {
            active_still_active[index] = true; // order is still there
            if (OrderOpenPrice() != active_price[index] ||
                  OrderStopLoss() != active_stoploss[index] ||
                  OrderTakeProfit() != active_takeprofit[index] ||
                  OrderType() != active_type[index])
            {
               changed = true;
               if (_orderChangedAction != NULL)
                  _orderChangedAction.DoAction(0, 0);
            }
         }
      }

      for (int index = 0; index < active_total; index++)
      {
         if (active_still_active[index] == false)
         {
            changed = true;
            if (_closedTradeAction != NULL && OrderSelect(active_ticket[index], MODE_HISTORY))
               _closedTradeAction.DoAction(0, 0);
         }
         
         active_still_active[index] = false;
      }
      if (changed)
         updateActiveOrders();
   }
private:
   int getOrderCacheIndex(const int ticket)
   {
      for (int i = 0; i < active_total; i++)
      {
         if (active_ticket[i] == ticket)
            return i;
      }
      return -1;
   }

   /**
   * read in the current state of all open orders 
   * and trades so we can track any changes in the next tick
   */ 
   void updateActiveOrders()
   {
      active_total = OrdersTotal();
      for (int i = 0; i < active_total; i++)
      {
         if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
            continue;
         active_ticket[i] = OrderTicket();
         active_type[i] = OrderType();
         active_price[i] = OrderOpenPrice();
         active_stoploss[i] = OrderStopLoss();
         active_takeprofit[i] = OrderTakeProfit();
         active_still_active[i] = false; // filled in the next tick
      }
   }
};

#endif