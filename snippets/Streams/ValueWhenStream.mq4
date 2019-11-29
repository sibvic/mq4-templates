// Value when stream v1.0

#ifndef ValueWhenStream_IMP
#define ValueWhenStream_IMP

#include <AStreamBase.mq4>
#include <../conditions/ICondition.mq4>

class ValueWhenStream : public AStreamBase
{
    ICondition* _condition;
    IStream* _source;
public:
   double _stream[];

   ValueWhenStream(ICondition* condition, IStream* source)
   {
      _condition = condition;
      _condition.AddRef();
      _source = source;
      _source.AddRef();
   }

   ~ValueWhenStream()
   {
      _source.Release();
      _condition.Release();
   }

   int RegisterStream(int id, color clr, int width, ENUM_LINE_STYLE style, string name)
   {
      SetIndexBuffer(id, _stream);
      SetIndexStyle(id, DRAW_LINE, style, width, clr);
      SetIndexLabel(id, name);
      return id + 1;
   }

   int RegisterInternalStream(int id)
   {
      SetIndexBuffer(id, _stream);
      SetIndexStyle(id, DRAW_NONE);
      return id + 1;
   }

   void Update(const int period)
   {
      double val;
      if (_condition.IsPass(period, 0) && _source.GetValue(period, val))
      {
         _stream[period] = val;
      }
      else
      {
         //TODO: chceck size and assign when possible _stream[period] = _stream[period + 1];
      }
   }

   bool GetValue(const int period, double &val)
   {
      val = _stream[period];
      return _stream[period] != EMPTY_VALUE;
   }
};

#endif