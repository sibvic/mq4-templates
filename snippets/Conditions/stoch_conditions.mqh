// Stochastic conditions v2.0

#ifndef StochConditions_IMP
#define StochConditions_IMP
#include <ACondition.mqh>

class StochKAboveDCondition : public ACondition
{
   int _kPeriod;
   int _dPeriod;
   int _slowingPeriod;
public:
   StochKAboveDCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int kPeriod, int dPeriod, int slowingPeriod)
      :ACondition(symbol, timeframe)
   {
      _kPeriod = kPeriod;
      _dPeriod = dPeriod;
      _slowingPeriod = slowingPeriod;
   }

   bool IsPass(const int period, const datetime date)
   {
      double stochValue = iStochastic(_symbol, _timeframe, _kPeriod, _dPeriod, _slowingPeriod, MODE_SMA, 0, MODE_MAIN, period);
      double signalValue = iStochastic(_symbol, _timeframe, _kPeriod, _dPeriod, _slowingPeriod, MODE_SMA, 0, MODE_SIGNAL, period);
      return stochValue > signalValue;
   }
};

class StochKBelowDCondition : public ACondition
{
   int _kPeriod;
   int _dPeriod;
   int _slowingPeriod;
public:
   StochKBelowDCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int kPeriod, int dPeriod, int slowingPeriod)
      :ACondition(symbol, timeframe)
   {
      _kPeriod = kPeriod;
      _dPeriod = dPeriod;
      _slowingPeriod = slowingPeriod;
   }

   bool IsPass(const int period, const datetime date)
   {
      double stochValue = iStochastic(_symbol, _timeframe, _kPeriod, _dPeriod, _slowingPeriod, MODE_SMA, 0, MODE_MAIN, period);
      double signalValue = iStochastic(_symbol, _timeframe, _kPeriod, _dPeriod, _slowingPeriod, MODE_SMA, 0, MODE_SIGNAL, period);
      return stochValue < signalValue;
   }
};

class StochKOversoldCondition : public ACondition
{
   int _kPeriod;
   int _dPeriod;
   int _slowingPeriod;
   double _oversold;
public:
   StochKOversoldCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int kPeriod, int dPeriod, int slowingPeriod, double oversold)
      :ACondition(symbol, timeframe)
   {
      _kPeriod = kPeriod;
      _dPeriod = dPeriod;
      _slowingPeriod = slowingPeriod;
      _oversold = oversold;
   }

   bool IsPass(const int period, const datetime date)
   {
      double stochValue = iStochastic(_symbol, _timeframe, _kPeriod, _dPeriod, _slowingPeriod, MODE_SMA, 0, MODE_MAIN, period);
      return stochValue < _oversold;
   }
};

class StochKOverboughtCondition : public ACondition
{
   int _kPeriod;
   int _dPeriod;
   int _slowingPeriod;
   double _overbought;
public:
   StochKOverboughtCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int kPeriod, int dPeriod, int slowingPeriod, double overbought)
      :ACondition(symbol, timeframe)
   {
      _kPeriod = kPeriod;
      _dPeriod = dPeriod;
      _slowingPeriod = slowingPeriod;
      _overbought = overbought;
   }

   bool IsPass(const int period, const datetime date)
   {
      double stochValue = iStochastic(_symbol, _timeframe, _kPeriod, _dPeriod, _slowingPeriod, MODE_SMA, 0, MODE_MAIN, period);
      return stochValue > _overbought;
   }
};
#endif