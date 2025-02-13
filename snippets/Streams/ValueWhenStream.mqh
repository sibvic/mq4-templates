// Value when stream v2.1

#ifndef ValueWhenStream_IMP
#define ValueWhenStream_IMP

#include <Streams/AStreamBase.mqh>
#include <Conditions/ICondition.mqh>

class ValueWhenStream : public AStreamBase
{
   ICondition* _condition;
   IStream* _source;
   int _periods[];
   double _values[];
   int _shift;
public:
   double _stream[];

   ValueWhenStream(ICondition* condition, IStream* source, int shift)
   {
      _shift = shift;
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

   void Update(const int period, datetime date)
   {
      double val;
      if (_condition.IsPass(period, 0) && _source.GetValue(period, val))
      {
         int size = ArraySize(_periods);
         if (size == 0 || _periods[size - 1] != date)
         {
            ArrayResize(_periods, size + 1);
            ArrayResize(_values, size + 1);
            _values[size] = val;
            _periods[size] = date;
            ++size;
         }
         else
         {
            _values[size - 1] = val;
         }
         if (size > _shift)
         {
            _stream[period] = _values[size - 1 - _shift];
         }
      }
      else if (_source.Size() - 1 > period)
      {
         _stream[period] = _stream[period + 1];
      }
   }

   bool GetValue(const int period, double &val)
   {
      val = _stream[period];
      return _stream[period] != EMPTY_VALUE;
   }
};

#endif