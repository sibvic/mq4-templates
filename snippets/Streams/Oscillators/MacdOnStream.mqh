#include <Streams/Averages/EMAOnStream.mqh>
#include <Streams/CustomStreamOnStream.mqh>

// MACD on stream v1.0
// macd = ema(source, fastlen) - ema(source, slowlen)
// signal = ema(macd, siglen)
// histogram = macd - signal

#ifndef MacdOnStream_IMP
#define MacdOnStream_IMP

class MacdOnStream : public TIStream<double>
{
   TIStream<double>* _source;
   int _references;
   EMAOnStream* _fast;
   EMAOnStream* _slow;
   CustomStreamOnStream* _macdLine;
   EMAOnStream* _signal;
public:
   MacdOnStream(TIStream<double>* source, const int fastlen, const int slowlen, const int siglen)
   {
      _source = source;
      _source.AddRef();
      _references = 1;
      _fast = new EMAOnStream(_source, fastlen);
      _slow = new EMAOnStream(_source, slowlen);
      _macdLine = new CustomStreamOnStream(_source);
      _signal = new EMAOnStream(_macdLine, siglen);
   }

   ~MacdOnStream()
   {
      _signal.Release();
      _macdLine.Release();
      _fast.Release();
      _slow.Release();
      _source.Release();
   }

   void AddRef()
   {
      ++_references;
   }

   void Release()
   {
      --_references;
      if (_references == 0)
         delete &this;
   }

   virtual int Size()
   {
      return _source.Size();
   }

   virtual bool GetValue(const int period, double &val)
   {
      return false;
   }

   virtual bool GetValue(const int period, double &macd, double &signal, double &hist)
   {
      double fast;
      double slow;
      if (!_fast.GetValue(period, fast) || !_slow.GetValue(period, slow))
      {
         return false;
      }
      macd = fast - slow;
      _macdLine.SetValue(period, macd);
      if (!_signal.GetValue(period, signal))
      {
         signal = EMPTY_VALUE;
         hist = EMPTY_VALUE;
         return true;
      }
      hist = macd - signal;
      return true;
   }
};

#endif
