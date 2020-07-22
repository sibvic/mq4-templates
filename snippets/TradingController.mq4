#include <actions/AOrderAction.mq4>
#include <enums/OrderSide.mq4>
#include <EntryPositionController.mq4>

// Trading controller v7.7

#ifndef TradingController_IMP
#define TradingController_IMP

class TradingController
{
   ENUM_TIMEFRAMES _entryTimeframe;
   ENUM_TIMEFRAMES _exitTimeframe;
   datetime _lastActionTime;
   Signaler *_signaler;
   datetime _lastEntryTime;
   datetime _lastExitTime;
   TradingCalculator *_calculator;
   ICondition* _exitLongCondition;
   ICondition* _exitShortCondition;
   IEntryStrategy *_entryStrategy;
   ActionOnConditionLogic* _actions;
   TradingMode _entryLogic;
   TradingMode _exitLogic;
   int _logFile;
   EntryPositionController* _longPosition;
   EntryPositionController* _shortPosition;
public:
   TradingController(TradingCalculator *calculator, 
                     ENUM_TIMEFRAMES entryTimeframe, 
                     ENUM_TIMEFRAMES exitTimeframe, 
                     EntryPositionController* longPosition,
                     EntryPositionController* shortPosition,
                     ActionOnConditionLogic* actions,
                     Signaler *signaler, 
                     const string algorithmId = "")
   {
      _longPosition = longPosition;
      _shortPosition = shortPosition;
      _entryLogic = TradingModeOnBarClose;
      _exitLogic = TradingModeLive;
      _actions = actions;
      _calculator = calculator;
      _signaler = signaler;
      _entryTimeframe = entryTimeframe;
      _exitTimeframe = exitTimeframe;
      _exitLongCondition = NULL;
      _exitShortCondition = NULL;
      _logFile = -1;
   }

   ~TradingController()
   {
      if (_logFile != -1)
      {
         FileClose(_logFile);
      }
      delete _longPosition;
      delete _shortPosition;
      delete _actions;
      delete _entryStrategy;
      if (_exitLongCondition != NULL)
         _exitLongCondition.Release();
      if (_exitShortCondition != NULL)
         _exitShortCondition.Release();
      delete _calculator;
      delete _signaler;
   }

   void SetPrintLog(string logFile)
   {
      _logFile = FileOpen(logFile, FILE_WRITE | FILE_CSV, ",");
      _longPosition.IncludeLog();
      _shortPosition.IncludeLog();
   }
   void SetEntryLogic(TradingMode logicType) { _entryLogic = logicType; }
   void SetExitLogic(TradingMode logicType) { _exitLogic = logicType; }
   void SetExitLongCondition(ICondition *condition) { _exitLongCondition = condition; }
   void SetExitShortCondition(ICondition *condition) { _exitShortCondition = condition; }
   void SetEntryStrategy(IEntryStrategy *entryStrategy) { _entryStrategy = entryStrategy; }

   void DoTrading()
   {
      int entryTradePeriod = _entryLogic == TradingModeLive ? 0 : 1;
      datetime entryTime = iTime(_calculator.GetSymbol(), _entryTimeframe, entryTradePeriod);
      _actions.DoLogic(entryTradePeriod, entryTime);
      string entryLongLog = "";
      string entryShortLog = "";
      string exitLongLog = "";
      string exitShortLog = "";
      if (_lastEntryTime != 0 && EntryAllowed(entryTime))
      {
         if (DoEntryLogic(entryTradePeriod, entryTime, entryLongLog, entryShortLog))
         {
            _lastActionTime = entryTime;
         }
         _lastEntryTime = entryTime;
      }
      else if (_lastEntryTime == 0)
      {
         _lastEntryTime = entryTime;
      }

      int exitTradePeriod = _exitLogic == TradingModeLive ? 0 : 1;
      datetime exitTime = iTime(_calculator.GetSymbol(), _exitTimeframe, exitTradePeriod);
      if (ExitAllowed(exitTime))
      {
         DoExitLogic(exitTradePeriod, exitTime, exitLongLog, exitShortLog);
         _lastExitTime = exitTime;
      }
      if (_logFile != -1 && (entryLongLog != "" || entryShortLog != "" || exitLongLog != "" || exitShortLog != ""))
      {
         FileWrite(_logFile, TimeToString(TimeCurrent()), 
            "Entry long: " + entryLongLog, 
            "Entry short: " + entryShortLog, 
            "Exit long: " + exitLongLog, 
            "Exit short: " + exitShortLog);
      }
   }
private:
   bool ExitAllowed(datetime exitTime)
   {
      return _exitLogic != TradingModeOnBarClose || _lastExitTime != exitTime;
   }

   void DoExitLogic(int exitTradePeriod, datetime date, string& longLog, string& shortLog)
   {
      bool exitLongPassed = _exitLongCondition.IsPass(exitTradePeriod, date);
      bool exitShortPassed = _exitShortCondition.IsPass(exitTradePeriod, date);
      if (_logFile != -1)
      {
         longLog = _exitLongCondition.GetLogMessage(exitTradePeriod, date) + "; Exit long executed: " + (exitLongPassed ? "true" : "false");
         shortLog = _exitShortCondition.GetLogMessage(exitTradePeriod, date) + "; Exit short executed: " + (exitShortPassed ? "true" : "false");
      }
      if (exitLongPassed)
      {
         if (_entryStrategy.Exit(BuySide) > 0)
         {
            _signaler.SendNotifications("Exit Buy");
         }
      }
      if (exitShortPassed)
      {
         if (_entryStrategy.Exit(SellSide) > 0)
         {
            _signaler.SendNotifications("Exit Sell");
         }
      }
   }

   bool EntryAllowed(datetime entryTime)
   {
      if (_entryLogic == TradingModeOnBarClose)
      {
         return _lastEntryTime != entryTime;
      }
      return _lastActionTime != entryTime;
   }
   bool DoEntryLogic(int entryTradePeriod, datetime date, string& longLog, string& shortLog)
   {
      bool longOpened = _longPosition.DoEntry(entryTradePeriod, date, longLog);
      bool shortOpened = _shortPosition.DoEntry(entryTradePeriod, date, shortLog);
      return longOpened || shortOpened;
   }
};
#endif