# EA Base template

## Order actions/handlers

**orderHandlers** allows you to add an action (**IAction**) to be executed on each new order. You can create a new class inherited from **AOrderAction**, implement **DoAction**, and add it to **orderHandlers** in **CreateController** function. **AOrderAction** has a **_currentTicket** field. It'll be already set to the newly opened order ticket id when EA will call **DoAction**.

You can use it to add some action on condition for the order.

    TradingController *CreateController(const string symbol, const ENUM_TIMEFRAMES timeframe, string algoId, string &error)
    {
       //...
       MyOrderAction* orderAction = new MyOrderAction();
       orderHandlers.AddOrderAction(orderAction);
       orderAction.Release();

    class MyOrderAction : public AOrderAction
    {
    public:
       virtual bool DoAction(const int period, const datetime date)
       {
          //New order has been opened. You can find ticket id in _currentTicket field
          if (!OrderSelect(_currentTicket, SELECT_BY_TICKET, MODE_TRADES))
          {
             return false;
          }
          //Do something usefull with that order
          return true;
       }
    };

## Actions on conditions

You can use **actions** to check some condition you need on every tick and execute an action when this condition passes.

    TradingController *CreateController(const string symbol, const ENUM_TIMEFRAMES timeframe, string algoId, string &error)
    {
       //What we need to check
       IsItLuchtimeCondition* onLunchTime = new IsItLuchtimeCondition();
       //What we need to do when our condition is met
       IAction* closeEveything = new CloseAllAction(magic_number, slippage_points);

       actions.AddActionOnCondition(closeEveything, onLunchTime);
       
       action.Release();
       onLunchTime.Release();
