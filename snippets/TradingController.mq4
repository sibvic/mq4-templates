// Trading controller v2.15
class TradingController
{
   ENUM_TIMEFRAMES _timeframe;
   datetime _lastbartime;
   double _lastLot;
   IBreakevenLogic *_breakeven;
   ActionOnConditionLogic* actions;
   ITrailingLogic *_trailing;
   Signaler *_signaler;
   datetime _lastBarDate;
   TradeCalculator *_calculator;
#ifdef NET_STOP_LOSS_FEATURE
   INetStopLossStrategy *_netStopLoss;
#endif
#ifdef NET_TAKE_PROFIT_FEATURE
   INetTakeProfitStrategy *_netTakeProfit;
#endif
   TradingTime *_tradingTime;
   ICondition *_longCondition;
   ICondition *_shortCondition;
   ICondition *_exitAllCondition;
   ICondition *_exitLongCondition;
   ICondition *_exitShortCondition;
#ifdef MARTINGALE_FEATURE
   IMartingaleStrategy *_shortMartingale;
   IMartingaleStrategy *_longMartingale;
#endif
   IMoneyManagementStrategy *_longMoneyManagement[];
   IMoneyManagementStrategy *_shortMoneyManagement[];
   ICloseOnOppositeStrategy *_closeOnOpposite;
#ifdef POSITION_CAP_FEATURE
   IPositionCapStrategy *_longPositionCap;
   IPositionCapStrategy *_shortPositionCap;
#endif
   IEntryStrategy *_entryStrategy;
   IMandatoryClosingLogic *_mandatoryClosing;
#ifdef CUSTOM_EXIT_FEATURE
   ICustomExitLogic *_customExit;
#endif
   string _algorithmId;
   ActionOnConditionLogic* _actions;
public:
   TradingController(TradeCalculator *calculator, ENUM_TIMEFRAMES timeframe, Signaler *signaler, const string algorithmId = "")
   {
      _actions = NULL;
      _algorithmId = algorithmId;
#ifdef CUSTOM_EXIT_FEATURE
      _customExit = NULL;
#endif
#ifdef POSITION_CAP_FEATURE
      _longPositionCap = NULL;
      _shortPositionCap = NULL;
#endif
      _closeOnOpposite = NULL;
#ifdef MARTINGALE_FEATURE
      _shortMartingale = NULL;
      _longMartingale = NULL;
#endif
      _longCondition = NULL;
      _shortCondition = NULL;
#ifdef NET_STOP_LOSS_FEATURE
      _netStopLoss = NULL;
#endif
#ifdef NET_TAKE_PROFIT_FEATURE
      _netTakeProfit = NULL;
#endif
      _calculator = calculator;
      _signaler = signaler;
      _timeframe = timeframe;
      _lastLot = lots_value;
      _exitAllCondition = NULL;
      _exitLongCondition = NULL;
      _exitShortCondition = NULL;
      _tradingTime = NULL;
      _mandatoryClosing = NULL;
   }

   ~TradingController()
   {
      delete _actions;
#ifdef CUSTOM_EXIT_FEATURE
      delete _customExit;
#endif
      delete _mandatoryClosing;
      delete _entryStrategy;
#ifdef POSITION_CAP_FEATURE
      delete _longPositionCap;
      delete _shortPositionCap;
#endif
      delete _closeOnOpposite;
      for (int i = 0; i < ArraySize(_longMoneyManagement); ++i)
      {
         delete _longMoneyManagement[i];
      }
      for (int i = 0; i < ArraySize(_shortMoneyManagement); ++i)
      {
         delete _shortMoneyManagement[i];
      }
#ifdef MARTINGALE_FEATURE
      delete _shortMartingale;
      delete _longMartingale;
#endif
      delete _exitAllCondition;
      delete _exitLongCondition;
      delete _exitShortCondition;
      delete _calculator;
      delete _signaler;
      delete _breakeven;
      delete _trailing;
      delete _longCondition;
      delete _shortCondition;
#ifdef NET_STOP_LOSS_FEATURE
      delete _netStopLoss;
#endif
#ifdef NET_TAKE_PROFIT_FEATURE
      delete _netTakeProfit;
#endif
      delete _tradingTime;
   }

#ifdef CUSTOM_EXIT_FEATURE
   void SetCustomExit(ICustomExitLogic *customExit) { _customExit = customExit; }
#endif
   void SetActions(ActionOnConditionLogic* actions) { _actions = actions; }
   void SetTradingTime(TradingTime *tradingTime) { _tradingTime = tradingTime; }
   void SetBreakeven(IBreakevenLogic *breakeven) { _breakeven = breakeven; }
   void SetTrailing(ITrailingLogic *trailing) { _trailing = trailing; }
#ifdef NET_STOP_LOSS_FEATURE
   void SetNetStopLossStrategy(INetStopLossStrategy *strategy) { _netStopLoss = strategy; }
#endif
#ifdef NET_TAKE_PROFIT_FEATURE
   void SetNetTakeProfitStrategy(INetTakeProfitStrategy *strategy) { _netTakeProfit = strategy; }
#endif
   void SetLongCondition(ICondition *condition) { _longCondition = condition; }
   void SetShortCondition(ICondition *condition) { _shortCondition = condition; }
   void SetExitAllCondition(ICondition *condition) { _exitAllCondition = condition; }
   void SetExitLongCondition(ICondition *condition) { _exitLongCondition = condition; }
   void SetExitShortCondition(ICondition *condition) { _exitShortCondition = condition; }
#ifdef MARTINGALE_FEATURE
   void SetShortMartingaleStrategy(IMartingaleStrategy *martingale) { _shortMartingale = martingale; }
   void SetLongMartingaleStrategy(IMartingaleStrategy *martingale) { _longMartingale = martingale; }
#endif
   void AddLongMoneyManagement(IMoneyManagementStrategy *moneyManagement)
   {
      int count = ArraySize(_longMoneyManagement);
      ArrayResize(_longMoneyManagement, count + 1);
      _longMoneyManagement[count] = moneyManagement;
   }
   void AddShortMoneyManagement(IMoneyManagementStrategy *moneyManagement)
   {
      int count = ArraySize(_shortMoneyManagement);
      ArrayResize(_shortMoneyManagement, count + 1);
      _shortMoneyManagement[count] = moneyManagement;
   }
   void SetCloseOnOpposite(ICloseOnOppositeStrategy *closeOnOpposite) { _closeOnOpposite = closeOnOpposite; }
#ifdef POSITION_CAP_FEATURE
   void SetLongPositionCap(IPositionCapStrategy *positionCap) { _longPositionCap = positionCap; }
   void SetShortPositionCap(IPositionCapStrategy *positionCap) { _shortPositionCap = positionCap; }
#endif
   void SetEntryStrategy(IEntryStrategy *entryStrategy) { _entryStrategy = entryStrategy; }
   void SetMandatoryClosing(IMandatoryClosingLogic *mandatoryClosing) { _mandatoryClosing = mandatoryClosing; }

   void DoTrading()
   {
      int tradePeriod = trade_live == TradingModeLive ? 0 : 1;
      datetime current_time = iTime(_calculator.GetSymbol(), _timeframe, tradePeriod);
      _actions.DoLogic(tradePeriod);
      _trailing.DoLogic();
#ifdef NET_STOP_LOSS_FEATURE
      _netStopLoss.DoLogic();
#endif
#ifdef NET_TAKE_PROFIT_FEATURE
      _netTakeProfit.DoLogic();
#endif
      if (trade_live == TradingModeOnBarClose)
      {
         if (_lastBarDate != current_time)
            _lastBarDate = current_time;
         else
            return;
      }
#ifdef MARTINGALE_FEATURE
      DoMartingale(_shortMartingale);
      DoMartingale(_longMartingale);
#endif

#ifdef CUSTOM_EXIT_FEATURE
      _customExit.DoLogic();
#endif
      bool exitAll = _exitAllCondition.IsPass(tradePeriod);
      if (exitAll || (_exitLongCondition.IsPass(tradePeriod) && !_exitLongCondition.IsPass(tradePeriod + 1)))
      {
         if (_entryStrategy.Exit(BuySide) > 0)
            _signaler.SendNotifications("Exit Buy");
      }
      if (exitAll || (_exitShortCondition.IsPass(tradePeriod) && !_exitShortCondition.IsPass(tradePeriod + 1)))
      {
         if (_entryStrategy.Exit(SellSide) > 0)
            _signaler.SendNotifications("Exit Sell");
      }

      if (_tradingTime != NULL && !_tradingTime.IsTradingTime(TimeCurrent()))
      {
         _mandatoryClosing.DoLogic();
         return;
      }
      if (current_time == _lastbartime)
         return;

      if (_longCondition.IsPass(tradePeriod) && !_longCondition.IsPass(tradePeriod + 1))
      {
#ifdef POSITION_CAP_FEATURE
         if (_longPositionCap.IsLimitHit())
         {
            _signaler.SendNotifications("Positions limit has been reached");
            return;
         }
#endif
         _closeOnOpposite.DoClose(SellSide);
         for (int i = 0; i < ArraySize(_longMoneyManagement); ++i)
         {
            double stopLoss = 0.0;
            int order = _entryStrategy.OpenPosition(tradePeriod, BuySide, _longMoneyManagement[i], _algorithmId, stopLoss);
            if (order >= 0)
            {
               _lastbartime = current_time;
#ifdef MARTINGALE_FEATURE
               _longMartingale.OnOrder(order);
#endif
               _breakeven.CreateBreakeven(order, tradePeriod);
               _trailing.Create(order, (_calculator.GetAsk() - stopLoss) / _calculator.GetPipSize());
            }
         }
         _signaler.SendNotifications("Buy");
      }
      if (_shortCondition.IsPass(tradePeriod) && !_shortCondition.IsPass(tradePeriod + 1))
      {
#ifdef POSITION_CAP_FEATURE
         if (_shortPositionCap.IsLimitHit())
         {
            _signaler.SendNotifications("Positions limit has been reached");
            return;
         }
#endif
         _closeOnOpposite.DoClose(BuySide);

         for (int i = 0; i < ArraySize(_shortMoneyManagement); ++i)
         {
            double stopLoss = 0.0;
            int order = _entryStrategy.OpenPosition(tradePeriod, SellSide, _shortMoneyManagement[i], _algorithmId, stopLoss);
            if (order >= 0)
            {
               _lastbartime = current_time;
#ifdef MARTINGALE_FEATURE
               _shortMartingale.OnOrder(order);
#endif
               _breakeven.CreateBreakeven(order, tradePeriod);
               _trailing.Create(order, (stopLoss - _calculator.GetBid()) / _calculator.GetPipSize());
            }
         }
         _signaler.SendNotifications("Sell");
      }
   }
private:
#ifdef MARTINGALE_FEATURE
   void DoMartingale(IMartingaleStrategy *martingale)
   {
      OrderSide anotherSide;
      if (martingale.NeedAnotherPosition(anotherSide))
      {
         double stopLoss;
         int order = _entryStrategy.OpenPosition(0, anotherSide, martingale.GetMoneyManagement(), "Martingale position", stopLoss);
         if (order >= 0)
            martingale.OnOrder(order);
         if (anotherSide == BuySide)
            _signaler.SendNotifications("Opening martingale long position");
         else
            _signaler.SendNotifications("Opening martingale short position");
      }
   }
#endif
};