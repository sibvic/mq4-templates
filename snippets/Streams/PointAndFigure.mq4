#include <ACustomBarStream.mq4>
// v1.0

#ifndef PointAndFigure_IMP
#define PointAndFigure_IMP
class PointAndFigure : public ACustomBarStream
{
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
   int _boxSize;
   int _sensitivity;
   int _lastDirection;
public:
   PointAndFigure(const string symbol, const ENUM_TIMEFRAMES timeframe, int boxSizePips, int sensitivity)
   {
      double point = MarketInfo(symbol, MODE_POINT);
      int digits = (int)MarketInfo(symbol, MODE_DIGITS);
      int mult = digits == 3 || digits == 5 ? 10 : 1;
      double pipSize = point * mult;

      _lastDirection = 0;
      _boxSize = boxSizePips * pipSize;
      _sensitivity = sensitivity * _boxSize;
      _symbol = symbol;
      _timeframe = timeframe;
   }

   virtual void Refresh()
   {
      int start = iBars(_symbol, _timeframe) - 1;
      if (_size > 0)
      {
         start = iBarShift(_symbol, _timeframe, _dates[_size - 1]);
      }

      for (int i = start; i >= 0; --i)
      {
         if (_size == 0)
         {
            calcFirstValueValue(i);
            continue;
         }
         double box = tobox(iClose(_symbol, _timeframe, i));
         if (_lastDirection > 0)
         {
            if (box < _high[_size - 1] - RC - BS)
            {
               AddBar(iTime(_symbol, _timeframe, i));
               _high[_size - 1] = _high[_size - 2] - BS;
               _low[_size - 1] = box;
               _lastDirection = -1;
               _open[_size - 1] = _high[_size - 1];
               _close[_size - 1] = _low[_size - 1];
            }
            else
            {
               _high[_size - 1] = MathMax(_high[_size - 1], box + BS);
               _low[_size - 1] = MathMin(_low[_size - 1], box);
               _open[_size - 1] = _low[_size - 1];
               _close[_size - 1] = _high[_size - 1];
            }
         }
         else
         {
            if (box > _low[_size - 1] + RC)
            {
               AddBar(iTime(_symbol, _timeframe, i));
               _low[_size - 1] = _low[_size - 2] + BS;
               _high[_size - 1] = box + BS;
               _lastDirection = 1;
               _close[_size - 1] = _high[_size - 1];
               _open[_size - 1] = _low[_size - 1];
            }
            else
            {
               _high[_size - 1] = MathMax(_high[_size - 1], box + BS);
               _low[_size - 1] = MathMin(_low[_size - 1], box);
               _open[_size - 1] = _high[_size - 1];
               _close[_size - 1] = _low[_size - 1];
            }
         }
      }
   }
private:
   void calcFirstValueValue(int period)
   {
      AddBar(iTime(_symbol, _timeframe, period));
      if (iOpen(_symbol, _timeframe, period) < iClose(_symbol, _timeframe, period))
      {
         _lastDirection = 1;
      }
      else
      {
         _lastDirection = -1;
      }
      double box = tobox(iClose(_symbol, _timeframe, period));
      _high[0] = box + BS;
      _low[0] = box;
      if (_lastDirection > 0)
      {
         _open[0] = _low[0];
         _close[0] = _high[0];
      }
      else
      {
         _open[0] = _high[0];
         _close[0] = _low[0];
      }
   }

   double tobox(double price)
   {
      return MathFloor(price / BS) * BS;
   }
   void AddBar(datetime date)
   {
      ++_size;
      ArrayResize(_dates, _size);
      ArrayResize(_open, _size);
      ArrayResize(_high, _size);
      ArrayResize(_low, _size);
      ArrayResize(_close, _size);
      if (_size == 1)
         _dates[_size - 1] = date;
      else if (_dates[_size - 2] >= date)
         _dates[_size - 1] = _dates[_size - 2] + 1;
      else
         _dates[_size - 1] = date;
   }
};
#endif