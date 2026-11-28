#include <Streams/AOnStream.mqh>
#include <Streams/Custom/IntToFloatStreamWrapper.mqh>

// Sum on stream v2.1

class SumOnStream : public AOnStream
{
   double _buffer[];
   int _length;
public:
   SumOnStream(TIStream<double>* source, int length)
      :AOnStream(source)
   {
      _length = length;
   }

   bool GetValue(const int period, double &val)
   {
      //period is an index for time series (0 = latest)
      int totalBars = Bars;
      int range = ArrayRange(_buffer, 0);
      if (range != totalBars)
      {
         ArrayResize(_buffer, totalBars);
         for (int i = range; i < totalBars; ++i)
         {
            _buffer[i] = EMPTY_VALUE;
         }
      }
         
      int bufferIndex = totalBars - 1 - period;
      if (bufferIndex > 0 && _buffer[bufferIndex - 1] != EMPTY_VALUE)
      {
         if (GetValueBuffered(period, val, bufferIndex))
         {
            _buffer[bufferIndex] = val;
            return true;
         }
         return false;
      }

      double sum = 0;
      for (int i = 0; i < _length; ++i)
      {
         double current;
         if (!_source.GetValue(period + i, current))
         {
            return false;
         }
         sum += current;
      }
      _buffer[bufferIndex] = sum;
      val = _buffer[bufferIndex];
      return true;
   }
   
private:
   bool GetValueBuffered(const int period, double &val, int bufferIndex)
   {
      double toSubstruct;
      if (!_source.GetValue(period + _length, toSubstruct))
      {
         return false;
      }
      double toAdd;
      if (!_source.GetValue(period, toAdd))
      {
         return false;
      }
      
      val = _buffer[bufferIndex - 1] + toAdd - toSubstruct;
      return true;
   }
};

class DynamicSumOnStream
{
   SumOnStream* impl;
   TIStream<double>* _source;
   IntToFloatStreamWrapper* _intWrapper;
   int _length;
   int _references;
public:
   DynamicSumOnStream(TIStream<double>* source)
   {
      impl = NULL;
      _source = source;
      _intWrapper = NULL;
      _length = 0;
      _references = 1;
   }
   DynamicSumOnStream(TIStream<int>* source)
   {
      impl = NULL;
      _intWrapper = new IntToFloatStreamWrapper(source);
      _source = _intWrapper;
      _length = 0;
      _references = 1;
   }
   ~DynamicSumOnStream()
   {
      ReleaseImpl();
      if (_intWrapper != NULL)
      {
         _intWrapper.Release();
         _intWrapper = NULL;
      }
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
   bool GetValue(const int period, int length, double &val)
   {
      if (_length != length)
      {
         ReleaseImpl();
         _length = length;
         impl = new SumOnStream(_source, _length);
      }
      return impl.GetValue(period, val);
   }
private:
   void ReleaseImpl()
   {
      if (impl != NULL)
      {
         impl.Release();
         impl = NULL;
      }
   }
};