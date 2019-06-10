// Stream v.2.0
interface IStream
{
public:
   virtual void AddRef() = 0;
   virtual void Release() = 0;

   virtual bool GetValue(const int period, double &val) = 0;
};

struct CandleData
{
   double Open;
   double High;
   double Low;
   double Close;
   datetime Date;
};

interface IBarStreamIterator
{
public:
   virtual bool Next() = 0;
   virtual IBarStreamIterator *CreateForwardIterator() = 0;
   virtual IBarStreamIterator *CreateReverseIterator() = 0;

   virtual datetime GetDate() = 0;

   virtual double GetOpen() = 0;
   virtual double GetHigh() = 0;
   virtual double GetLow() = 0;
   virtual double GetClose() = 0;
   virtual void GetData(CandleData &candle) = 0;
};

interface IBarStream : public IStream
{
public:
   virtual bool GetValues(const int period, double &open, double &high, double &low, double &close) = 0;

   virtual double GetOpen(const int period, double &open) = 0;
   virtual double GetHigh(const int period, double &high) = 0;
   virtual double GetLow(const int period, double &low) = 0;
   virtual double GetClose(const int period, double &close) = 0;
   
   virtual bool GetHighLow(const int period, double &high, double &low) = 0;

   virtual bool GetIsAscending(const int period, bool &res) = 0;

   virtual bool GetIsDescending(const int period, bool &res) = 0;

   virtual bool GetDate(const int period, datetime &dt) = 0;

   virtual int Size() = 0;

   virtual void Refresh() = 0;

   virtual IBarStreamIterator *CreateForwardIterator() = 0;
   virtual IBarStreamIterator *CreateReverseIterator() = 0;
};

class BarStreamIterator : public IBarStreamIterator 
{
protected:
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
   int _index;
   bool _forward;
public:
   BarStreamIterator(const string symbol, const ENUM_TIMEFRAMES timeframe, const bool forward)
   {
      _symbol = symbol;
      _timeframe = timeframe;
      _index = -1;
      _forward = forward;
   }

   virtual datetime GetDate()
   {
      return iTime(_symbol, _timeframe, _index);
   }

   virtual double GetOpen()
   {
      return iOpen(_symbol, _timeframe, _index);
   }

   virtual double GetHigh()
   {
      return iHigh(_symbol, _timeframe, _index);
   }

   virtual double GetLow()
   {
      return iLow(_symbol, _timeframe, _index);
   }

   virtual double GetClose()
   {
      return iClose(_symbol, _timeframe, _index);
   }

   virtual void GetData(CandleData &candle)
   {
      candle.Date = iTime(_symbol, _timeframe, _index);
      candle.Open = iOpen(_symbol, _timeframe, _index);
      candle.High = iHigh(_symbol, _timeframe, _index);
      candle.Low = iLow(_symbol, _timeframe, _index);
      candle.Close = iClose(_symbol, _timeframe, _index);
   }

   virtual IBarStreamIterator *CreateForwardIterator()
   {
      BarStreamIterator *copy = new BarStreamIterator(_symbol, _timeframe, true);
      copy._index = _index;
      if (!copy.MoveBackward())
         copy._index = -1;
      return copy;
   }
   virtual IBarStreamIterator *CreateReverseIterator()
   {
      BarStreamIterator *copy = new BarStreamIterator(_symbol, _timeframe, false);
      copy._index = _index;
      if (!copy.MoveForward())
         copy._index = -1;
      return copy;
   }
   
   virtual bool Next()
   {
      if (_forward)
         return MoveForward();
      return MoveBackward();
   }
private:
   bool MoveForward()
   {
      if (_index == 0)
         return false;
      if (_index == -1)
         _index = iBars(_symbol, _timeframe) - 1;
      else
         --_index;
      return true;
   }

   bool MoveBackward()
   {
      if (iBars(_symbol, _timeframe) - 1 <= _index)
         return false;
      ++_index;
      return true;
   }
};

class BarStream : public IBarStream
{
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
public:
   BarStream(const string symbol, const ENUM_TIMEFRAMES timeframe)
   {
      _symbol = symbol;
      _timeframe = timeframe;
   }

   virtual IBarStreamIterator *CreateForwardIterator()
   {
      return new BarStreamIterator(_symbol, _timeframe, true);
   }

   virtual IBarStreamIterator *CreateReverseIterator()
   {
      return new BarStreamIterator(_symbol, _timeframe, false);
   }

   virtual bool GetValue(const int period, double &val)
   {
      if (iBars(_symbol, _timeframe) <= period)
         return false;
      val = iClose(_symbol, _timeframe, period);
      return true;
   }

   virtual bool GetDate(const int period, datetime &dt)
   {
      if (iBars(_symbol, _timeframe) <= period)
         return false;
      dt = iTime(_symbol, _timeframe, period);
      return true;
   }

   virtual double GetOpen(const int period, double &open)
   {
      if (iBars(_symbol, _timeframe) <= period)
         return false;
      open = iOpen(_symbol, _timeframe, period);
      return true;
   }

   virtual double GetHigh(const int period, double &high)
   {
      if (iBars(_symbol, _timeframe) <= period)
         return false;
      high = iHigh(_symbol, _timeframe, period);
      return true;
   }

   virtual double GetLow(const int period, double &low)
   {
      if (iBars(_symbol, _timeframe) <= period)
         return false;
      low = iLow(_symbol, _timeframe, period);
      return true;
   }

   virtual double GetClose(const int period, double &close)
   {
      if (iBars(_symbol, _timeframe) <= period)
         return false;
      close = iClose(_symbol, _timeframe, period);
      return true;
   }

   virtual bool GetValues(const int period, double &open, double &high, double &low, double &close)
   {
      if (iBars(_symbol, _timeframe) <= period)
         return false;
      open = iOpen(_symbol, _timeframe, period);
      high = iHigh(_symbol, _timeframe, period);
      low = iLow(_symbol, _timeframe, period);
      close = iClose(_symbol, _timeframe, period);
      return true;
   }

   virtual bool GetHighLow(const int period, double &high, double &low)
   {
      if (iBars(_symbol, _timeframe) <= period)
         return false;
      high = iHigh(_symbol, _timeframe, period);
      low = iLow(_symbol, _timeframe, period);
      return true;
   }

   virtual bool GetIsAscending(const int period, bool &res)
   {
      if (iBars(_symbol, _timeframe) <= period)
         return false;
      res = iOpen(_symbol, _timeframe, period) < iClose(_symbol, _timeframe, period);
      return true;
   }

   virtual bool GetIsDescending(const int period, bool &res)
   {
      if (iBars(_symbol, _timeframe) <= period)
         return false;
      res = iOpen(_symbol, _timeframe, period) > iClose(_symbol, _timeframe, period);
      return true;
   }

   virtual int Size()
   {
      return iBars(_symbol, _timeframe);
   }

   virtual void Refresh() { }
};

class CandleBodyBarStream : public IBarStream
{
   IBarStream *_source;
public:
   CandleBodyBarStream(IBarStream *source)
   {
      _source = source;
   }

   virtual bool GetValue(const int period, double &val)
   {
      return _source.GetValue(period, val);
   }

   virtual bool GetValues(const int period, double &open, double &high, double &low, double &close)
   {
      if (!_source.GetValues(period, open, high, low, close))
         return false;

      high = MathMax(open, close);
      low = MathMin(open, close);
      return true;
   }

   virtual bool GetHighLow(const int period, double &high, double &low)
   {
      double open, close;
      if (!_source.GetValues(period, open, high, low, close))
         return false;
      
      high = MathMax(open, close);
      low = MathMin(open, close);
      return true;
   }

   virtual bool GetIsAscending(const int period, bool &res)
   {
      return _source.GetIsAscending(period, res);
   }

   virtual bool GetIsDescending(const int period, bool &res)
   {
      return _source.GetIsDescending(period, res);
   }
};

class CustomTimeframeBarStreamIterator : public IBarStreamIterator
{
private:
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
   int _timeframeMult;
   int _startIndex;
   int _endIndex;
   bool _forward;
public:
   CustomTimeframeBarStreamIterator(const string symbol, const ENUM_TIMEFRAMES timeframe, const int timeframeMult, const bool forward)
   {
      _forward = forward;
      _symbol = symbol;
      _timeframe = timeframe;
      _timeframeMult = timeframeMult;
      _startIndex = -1;
      _endIndex = -1;
   }

   virtual datetime GetDate()
   {
      return iTime(_symbol, _timeframe, _startIndex);
   }

   virtual double GetOpen()
   {
      return iOpen(_symbol, _timeframe, _startIndex);
   }

   virtual double GetHigh()
   {
      return iHigh(_symbol, _timeframe, iHighest(_symbol, _timeframe, MODE_HIGH, _endIndex - _startIndex, _endIndex));
   }

   virtual double GetLow()
   {
      return iLow(_symbol, _timeframe, iLowest(_symbol, _timeframe, MODE_LOW, _endIndex - _startIndex, _endIndex));
   }

   virtual double GetClose()
   {
      return iClose(_symbol, _timeframe, _endIndex);
   }

   virtual void GetData(CandleData &candle)
   {
      candle.Date = GetDate();
      candle.Open = GetOpen();
      candle.High = GetHigh();
      candle.Low = GetLow();
      candle.Close = GetClose();
   }

   virtual IBarStreamIterator *CreateForwardIterator()
   {
      CustomTimeframeBarStreamIterator *copy = new CustomTimeframeBarStreamIterator(_symbol, _timeframe, _timeframeMult, true);
      copy._startIndex = _startIndex;
      copy._endIndex = _endIndex;
      if (!copy.MoveBackward())
      {
         copy._startIndex = -1;
         copy._endIndex = -1;
      }
      return copy;
   }
   virtual IBarStreamIterator *CreateReverseIterator()
   {
      CustomTimeframeBarStreamIterator *copy = new CustomTimeframeBarStreamIterator(_symbol, _timeframe, _timeframeMult, false);
      copy._startIndex = _startIndex;
      copy._endIndex = _endIndex;
      if (!copy.MoveBackward())
      {
         copy._startIndex = -1;
         copy._endIndex = -1;
      }
      return copy;
   }

   virtual bool Next()
   {
      if (_forward)
         return MoveForward();
      return MoveBackward();
   }
private:
   bool MoveForward()
   {
      if (_endIndex == 0)
         return false;
      int periodLength = ((int)_timeframe * _timeframeMult * 60);
      if (_startIndex == -1)
      {
         datetime barStart = (Time[iBars(_symbol, _timeframe)] / periodLength) * periodLength;
         _startIndex = iBarShift(_symbol, _timeframe, barStart);
         if (_startIndex == -1)
         {
            barStart += periodLength;
            _startIndex = iBarShift(_symbol, _timeframe, barStart);
            if (_startIndex == -1)
               return false;
         }
         _endIndex = iBarShift(_symbol, _timeframe, barStart + periodLength) + 1;
         return true;
      }
      --_endIndex;
      
      datetime barStart = (Time[_endIndex] / periodLength) * periodLength;
      _startIndex = iBarShift(_symbol, _timeframe, barStart);
      _endIndex = iBarShift(_symbol, _timeframe, barStart + periodLength) + 1;
      return true;
   }

   bool MoveBackward()
   {
      int maxIndex = iBars(_symbol, _timeframe) - 1;
      if (maxIndex <= _startIndex)
         return false;
      ++_startIndex;

      int periodLength = ((int)_timeframe * _timeframeMult * 60);
      datetime barStart = (Time[_startIndex] / periodLength) * periodLength;
      _startIndex = iBarShift(_symbol, _timeframe, barStart);
      if (_startIndex == -1)
      {
         _startIndex = maxIndex;
         return false;
      }
      _endIndex = iBarShift(_symbol, _timeframe, barStart + periodLength) + 1;
      return true;
   }
};

class CustomTimeframeBarStream : public IBarStream
{
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
   int _timeframeMult;
   
   datetime _dates[];
   double _open[];
   double _close[];
   double _high[];
   double _low[];
   int _size;
public:
   CustomTimeframeBarStream(const string symbol, const ENUM_TIMEFRAMES timeframe, int timeframeMult)
   {
      _size = 0;
      _symbol = symbol;
      _timeframe = timeframe;
      _timeframeMult = timeframeMult;
   }

   virtual IBarStreamIterator *CreateForwardIterator()
   {
      return new CustomTimeframeBarStreamIterator(_symbol, _timeframe, _timeframeMult, true);
   }

   virtual IBarStreamIterator *CreateReverseIterator()
   {
      return new CustomTimeframeBarStreamIterator(_symbol, _timeframe, _timeframeMult, false);
   }

   virtual bool GetValue(const int period, double &val)
   {
      if (period >= _size)
         return false;
      val = _close[_size - 1 - period];
      return true;
   }

   virtual bool GetDate(const int period, datetime &dt)
   {
      if (period >= _size)
         return false;
      dt = _dates[_size - 1 - period];
      return true;
   }

   virtual double GetOpen(const int period, double &open)
   {
      if (_size <= period)
         return false;
      open = _open[_size - 1 - period];
      return true;
   }

   virtual double GetHigh(const int period, double &high)
   {
      if (_size <= period)
         return false;
      high = _high[_size - 1 - period];
      return true;
   }

   virtual double GetLow(const int period, double &low)
   {
      if (_size <= period)
         return false;
      low = _low[_size - 1 - period];
      return true;
   }

   virtual double GetClose(const int period, double &close)
   {
      if (_size <= period)
         return false;
      close = _close[_size - 1 - period];
      return true;
   }

   virtual bool GetValues(const int period, double &open, double &high, double &low, double &close)
   {
      if (period >= _size)
         return false;
      high = _high[_size - 1 - period];
      low = _low[_size - 1 - period];
      open = _open[_size - 1 - period];
      close = _close[_size - 1 - period];
      return true;
   }

   virtual bool GetHighLow(const int period, double &high, double &low)
   {
      if (period >= _size)
         return false;
      high = _high[_size - 1 - period];
      low = _low[_size - 1 - period];
      return true;
   }

   virtual bool GetIsAscending(const int period, bool &res)
   {
      if (period >= _size)
         return false;
      res = _open[_size - 1 - period] < _close[_size - 1 - period];
      return true;
   }

   virtual bool GetIsDescending(const int period, bool &res)
   {
      if (period >= _size)
         return false;
      res = _open[_size - 1 - period] > _close[_size - 1 - period];
      return true;
   }

   virtual int Size()
   {
      return _size;
   }

   virtual void Refresh()
   {
      int start = iBars(_symbol, _timeframe) - 1;
      if (_size > 0)
      {
         start = iBarShift(_symbol, _timeframe, _dates[_size - 1]);
      }
      int periodLength = ((int)_timeframe * _timeframeMult * 60);
      for (int i = start; i >= 0; --i)
      {
         datetime barStart = (iTime(_symbol, _timeframe, i) / periodLength) * periodLength;
         if (_size == 0 || barStart != _dates[_size - 1])
         {
            ++_size;
            ArrayResize(_dates, _size);
            ArrayResize(_open, _size);
            ArrayResize(_high, _size);
            ArrayResize(_low, _size);
            ArrayResize(_close, _size);
            _dates[_size - 1] = barStart;
            _open[_size - 1] = iOpen(_symbol, _timeframe, i);
            _high[_size - 1] = iHigh(_symbol, _timeframe, i);
            _low[_size - 1] = iLow(_symbol, _timeframe, i);
         }
         else
         {
            _high[_size - 1] = MathMax(iHigh(_symbol, _timeframe, i), _high[_size - 1]);
            _low[_size - 1] = MathMin(iLow(_symbol, _timeframe, i), _low[_size - 1]);
         }
         _close[_size - 1] = iClose(_symbol, _timeframe, i);
         while (barStart == _dates[_size - 1] && i >= 0)
         {
            barStart = (iTime(_symbol, _timeframe, --i) / periodLength) * periodLength;
         }
      }
   }
};

interface IStreamFactory
{
public:
   virtual IStream *Create(const int order) = 0;
};

class StreamFactory : public IStreamFactory
{
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
public:
   StreamFactory(const string symbol, const ENUM_TIMEFRAMES timeframe)
   {
      _symbol = symbol;
      _timeframe = timeframe;
   }

   virtual IStream *Create(const int order)
   {
      return NULL;
   }
};