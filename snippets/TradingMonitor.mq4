// Trades monitor v.1.1

#include <actions/IAction.mq4>
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
public:
   TradingMonitor()
   {
      _closedTradeAction = NULL;
   }

   ~TradingMonitor()
   {
      _closedTradeAction.Release();
   }

   void SetClosedTradeAction(IAction* action)
   {
      if (_closedTradeAction != NULL)
         _closedTradeAction.Release();
      _closedTradeAction = action;
      if (_closedTradeAction != NULL)
         _closedTradeAction.AddRef();
   }

   /**
   * find newly opened, changed or closed orders
   * and send messages for every change. Additionally
   * the function will return true if any changes were
   * detected, false otherwise. 
   */
   void SendNotifications()
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
            // new order
            changed = true;
            OnNewOrder();
         }
         else
         {
            active_still_active[index] = true; // order is still there
            if (OrderOpenPrice() != active_price[index] ||
                  OrderStopLoss() != active_stoploss[index] ||
                  OrderTakeProfit() != active_takeprofit[index] ||
                  OrderType() != active_type[index])
            {
               // already active order was changed
               changed = true;
               //messageChangedOrder(index);
            }
         }
      }

      // find closed orders. Orders that are in our cached list 
      // from the last tick but were not seen in the previous step.
      for (int index = 0; index < active_total; index++)
      {
         if (active_still_active[index] == false)
         {
            // the order must have been closed.
            changed = true;
            if (_closedTradeAction != NULL && OrderSelect(active_ticket[index], MODE_HISTORY))
               _closedTradeAction.DoAction();
         }
         
         // reset all these temporary flags again for the next tick
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

   void OnNewOrder()
   {
      
   }
};

#endif