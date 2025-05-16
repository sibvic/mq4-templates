// Rising condition v2.0

#ifndef RisingCondition_IMPL
#define RisingCondition_IMPL

class RisingCondition : public ICondition
{
   int refs;
   TIStream<double>* _source;
   int _length;
public:
   RisingCondition(TIStream<double>* source, int length)
   {
      refs = 1;
      _source = source;
      _source.AddRef();
      _length = length;
   }
   ~RisingCondition()
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
      return prev < current;
   }
   virtual string GetLogMessage(const int period, const datetime date)
   {
      return "";
   }
};
#endif