
class LongSARStream : public AStream
{
   double _step;
   double _max;
public:
   LongSARStream(const string symbol, const ENUM_TIMEFRAMES timeframe, const double step, const double max)
      :AStream(symbol, timeframe)
   {
      _step = step;
      _max = max;
   }

   bool GetValue(const int period, double &val)
   {
      double close = iClose(_symbol, _timeframe, period);
      val = iSAR(_symbol, _timeframe, _step, _max, period) + _shift * _instrument.GetPipSize();
      if (val > close)
         return false;
      return true;
   }
};

class ShortSARStream : public AStream
{
   double _step;
   double _max;
public:
   ShortSARStream(const string symbol, const ENUM_TIMEFRAMES timeframe, const double step, const double max)
      :AStream(symbol, timeframe)
   {
      _step = step;
      _max = max;
   }

   bool GetValue(const int period, double &val)
   {
      double close = iClose(_symbol, _timeframe, period);
      val = iSAR(_symbol, _timeframe, _step, _max, period) + _shift * _instrument.GetPipSize();
      if (val < close)
         return false;
      return true;
   }
};

class LongFractalStream : public AStream
{
public:
   LongFractalStream(const string symbol, const ENUM_TIMEFRAMES timeframe)
      :AStream(symbol, timeframe)
   {
   }

   bool GetValue(const int period, double &val)
   {
      val = iFractals(_symbol, _timeframe, MODE_LOWER, period + 1);
      if (val <= 0)
         return false;
      val += _shift * _instrument.GetPipSize();
      return true;
   }
};

class ShortFractalStream : public AStream
{
public:
   ShortFractalStream(const string symbol, const ENUM_TIMEFRAMES timeframe)
      :AStream(symbol, timeframe)
   {
   }

   bool GetValue(const int period, double &val)
   {
      val = iFractals(_symbol, _timeframe, MODE_UPPER, period + 1);
      if (val <= 0)
         return false;
      val += _shift * _instrument.GetPipSize();
      return true;
   }
};

class CustomIndicatorStream : public AStream
{
   int _streamIndex;
public:
   CustomIndicatorStream(const string symbol, const ENUM_TIMEFRAMES timeframe, const int streamIndex)
      :AStream(symbol, timeframe)
   {
      _streamIndex = streamIndex;
   }

   bool GetValue(const int period, double &val)
   {
      val = iCustom(_instrument.GetSymbol(), _timeframe, "2 bar supply and demand", true, _streamIndex, period);
      if (val <= 0)
         return false;
      val += _shift * _instrument.GetPipSize();
      return true;
   }
};

class MeanDevStream : public TIStream<double>
{
   TIStream<double>* _source;
   int _length;
   TIStream<double>* _avg;
public:
   MeanDevStream(TIStream<double>* source, const int length, const MATypes maType)
   {
      _source = source;
      _length = length;
      _avg = AveragesStreamFactory::Create(_source, _length, maType);
   }

   ~MeanDevStream()
   {
      delete _avg;
   }

   bool GetValue(const int period, double &val)
   {
      double avg;
      if (!_avg.GetValue(period, avg))
         return false;
      double summ = 0;
      for (int i = 0; i < _length; i++)
      {
         double price;
         if (!_source.GetValue(period + i, price))
            return false;
         summ += MathAbs(price - avg);
      }
      val = summ / _length;
      return true;
   }
};

class StochasticStream : public AStream
{
   int _kPeriods;
   int _dPeriods;
   int _slowing;
   int _stream;
public:
   StochasticStream(const string symbol, const ENUM_TIMEFRAMES timeframe, int kPeriods, int dPeriods, int slowing, int stream)
      :AStream(symbol, timeframe)
   {
      _kPeriods = kPeriods;
      _dPeriods = dPeriods;
      _slowing = slowing;
      _stream = stream;
   }

   bool GetValue(const int period, double &val)
   {
      val = iStochastic(_symbol, _timeframe, _kPeriods, _dPeriods, _slowing, MODE_SMA, 0, _stream, period);
      return true;
   }
};