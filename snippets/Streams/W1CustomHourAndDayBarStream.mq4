class W1CustomHourAndDayBarStream : public ACustomBarStream
{
   string _symbol;
   int _hour;
   int _day;
public:
   W1CustomHourAndDayBarStream(const string symbol, int hour, int day)
   {
      _symbol = symbol;
      _hour = hour;
      _day = day;
   }

   virtual void Refresh()
   {
      int start = iBars(_symbol, PERIOD_H1) - 1;
      if (_size > 0)
         start = iBarShift(_symbol, PERIOD_H1, _dates[_size - 1]);

      for (int i = start; i >= 0; --i)
      {
         datetime barStart = iTime(_symbol, PERIOD_H1, i);
         if (!RoundDate(barStart))
            continue;
         
         if (_size == 0 || barStart != _dates[_size - 1])
         {
            ++_size;
            ArrayResize(_dates, _size);
            ArrayResize(_open, _size);
            ArrayResize(_high, _size);
            ArrayResize(_low, _size);
            ArrayResize(_close, _size);
            _dates[_size - 1] = barStart;
            _open[_size - 1] = iOpen(_symbol, PERIOD_H1, i);
            _high[_size - 1] = iHigh(_symbol, PERIOD_H1, i);
            _low[_size - 1] = iLow(_symbol, PERIOD_H1, i);
         }
         else
         {
            _high[_size - 1] = MathMax(iHigh(_symbol, PERIOD_H1, i), _high[_size - 1]);
            _low[_size - 1] = MathMin(iLow(_symbol, PERIOD_H1, i), _low[_size - 1]);
         }
         _close[_size - 1] = iClose(_symbol, PERIOD_H1, i);
      }
   }
private:
   bool RoundDate(datetime& date)
   {
      int periodLength = (int)PERIOD_H1 * 24 * 60;
      date = (date / periodLength) * periodLength + _hour * 3600;
      MqlDateTime current_time;
      if (!TimeToStruct(date, current_time))
         return false;

      int daysPass = current_time.day_of_week - _day;
      if (daysPass < 0)
         daysPass += 7;
      date -= periodLength * daysPass;
      return true;
   }
};