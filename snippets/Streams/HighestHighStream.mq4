// Highest high stream v1.0

class HighestHighStream : public IStream
{
   int _loopback;
   int _references;
   IStream* _source;
public:
   HighestHighStream(IStream* source, int loopback)
   {
      _references = 1;
      _source = source;
      _source.AddRef();
   }

   ~HighestHighStream()
   {
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

   bool GetValue(const int period, double &val)
   {
      if (!_source.GetValue(period, val))
         return false;

      for (int i = 1; i < _loopback; ++i)
      {
         double value;
         if (!_source.GetValue(period + i, value))
            return false;
         val = MathMax(val, value);
      }
      return true;
   }
};