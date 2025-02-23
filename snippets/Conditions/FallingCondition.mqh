// Falling condition v1.0

#ifndef FallingCondition_IMPL
#define FallingCondition_IMPL

class FallingCondition : public ICondition
{
   int refs;
   IStream* _source;
   int _length;
public:
   FallingCondition(IStream* source, int length)
   {
      refs = 1;
      _source = source;
      _source.AddRef();
      _length = length;
   }
   ~FallingCondition()
   {
      _source.Release();
   }
   virtual void AddRef()
   {
      refs++;
   }
   virtual void Release()
   {
      if (--refs == 0)
      {
         delete &this;
      }
   }
   virtual bool IsPass(const int period, const datetime date)
   {
      double current;
      if (!_source.GetValue(period, current))
      {
         return false;
      }
      double prev;
      if (!_source.GetValue(period + _length, prev))
      {
         return false;
      }
      return prev > current;
   }
   virtual string GetLogMessage(const int period, const datetime date)
   {
      return "";
   }
};
#endif