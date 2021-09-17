// Linq v.1.0
class TakeIterator : public IBarStreamIterator
{
   IBarStreamIterator *_iter;
   int _take;
   int _taken;
public:
   TakeIterator(IBarStreamIterator *iter, const int take)
   {
      _iter = iter;
      _take = take;
      _taken = 0;
   }
   ~TakeIterator()
   {
      delete _iter;
   }

   virtual bool Next()
   {
      if (_taken == 0)
      {
         ++_taken;
         return _iter.Next();   
      }
      if (_taken == _take)
         return false;
      if (!_iter.Next())
         return false;
      ++_taken;
      return true;
   }
   virtual IBarStreamIterator *CreateForwardIterator() { return NULL; }
   virtual IBarStreamIterator *CreateReverseIterator() { return NULL; }
   virtual datetime GetDate() { return _iter.GetDate(); }
   virtual double GetOpen() { return _iter.GetOpen(); }
   virtual double GetHigh() { return _iter.GetHigh(); }
   virtual double GetLow() { return _iter.GetLow(); }
   virtual double GetClose() { return _iter.GetClose(); }
   virtual void GetData(CandleData &candle) { _iter.GetData(candle); }
};

class BarStreamIteratorWrapper : public IBarStreamIterator
{
   IBarStream *_stream;
   int _index;
public:
   BarStreamIteratorWrapper(IBarStream *stream, const int start)
   {
      _stream = stream;
      _index = start - 1;
   }
   virtual bool Next()
   {
      if (_stream.Size() - 1 <= _index)
         return false;
      ++_index;
      return true;
   }

   virtual IBarStreamIterator *CreateForwardIterator() { return NULL; }
   virtual IBarStreamIterator *CreateReverseIterator() { return NULL; }

   virtual datetime GetDate()
   {
      datetime dt;
      if (!_stream.GetDate(_index, dt))
         return 0;
      return dt;
   }

   virtual double GetOpen()
   {
      double val;
      if (!_stream.GetOpen(_index, val))
         return 0;
      return val;
   }

   virtual double GetHigh()
   {
      double val;
      if (!_stream.GetHigh(_index, val))
         return 0;
      return val;
   }

   virtual double GetLow()
   {
      double val;
      if (!_stream.GetLow(_index, val))
         return 0;
      return val;
   }

   virtual double GetClose()
   {
      double val;
      if (!_stream.GetClose(_index, val))
         return 0;
      return val;
   }

   virtual void GetData(CandleData &candle)
   {
      candle.Date = GetDate();
      candle.Open = GetOpen();
      candle.High = GetHigh();
      candle.Low = GetLow();
      candle.Close = GetClose();
   }
};

class Linq
{
   IBarStreamIterator *_iter;
public:
   Linq(IBarStreamIterator *iter)
   {
      _iter = iter.CreateForwardIterator();
   }

   Linq(IBarStream *stream, const int start = 0)
   {
      _iter = new BarStreamIteratorWrapper(stream, start);
   }

   ~Linq()
   {
      delete _iter;
   }

   Linq *Take(const int count)
   {
      _iter = new TakeIterator(_iter, count);
      return &this;
   }

   double Highest()
   {
      double highest = -DBL_MAX;
      while (_iter.Next())
      {
         double high = _iter.GetHigh();
         if (highest < high)
            highest = high;
      }
      return highest;
   }

   double Lowest()
   {
      double lowest = DBL_MAX;
      while (_iter.Next())
      {
         double low = _iter.GetLow();
         if (lowest > low)
            lowest = low;
      }
      return lowest;
   }
};