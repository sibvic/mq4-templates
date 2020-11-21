// EA with actions on other trades v1.0

#property strict

input bool direction = true; // Buy/long?
input double amount = 0.01; // Lots
input double stop = 60; // Stop in Pips
input double limit = 30; // Limit in Pips
input double distance = 30; // Hedging Distance
input int magic_number = 42; // Magic number
input int slippage = 3; // Slippage, points
input bool ecn_broker = false; // ECN Broker?

#include <TradingMonitor.mq4>
#include <Logic/ActionOnConditionLogic.mq4>

TradingMonitor tradingMonitor;
ActionOnConditionLogic* actions;

class OnTradeCloseAction : public AAction
{
public:
   virtual bool DoAction(const int period, const datetime date)
   {
      return true;
   }
};

class OnTradeOpenActionAction : public AAction
{
public:
   virtual bool DoAction(const int period, const datetime date)
   {
      return true;
   }
};

int OnInit()
{
   actions = new ActionOnConditionLogic();
   
   OnTradeOpenActionAction* onNewTradeAction = new OnTradeOpenActionAction();
   tradingMonitor.SetOnNewTrade(onNewTradeAction);
   onNewTradeAction.Release();

   OnTradeCloseAction* onTradeClosedAction = new OnTradeCloseAction();
   tradingMonitor.SetClosedTradeAction(onTradeClosedAction);
   onTradeClosedAction.Release();

   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
   delete actions;
}

bool first = true;
void OnTick()
{
   tradingMonitor.DoWork();
   actions.DoLogic(0, 0);
   if (first)
   {
      first = false;
   }
}

