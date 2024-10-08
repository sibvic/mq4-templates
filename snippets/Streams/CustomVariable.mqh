// Custom variable v1.1

class CustomVariable
{
   double _buffer[];
   int _lastIndex;
   int _rates_total;
public:
   CustomVariable()
   {
      _lastIndex = -1;
   }

   void Init(int period, int rates_total, double defaultValue)
   {
      _rates_total = rates_total;
      int pos = rates_total - period - 1;

      int currentBufferSize = ArrayRange(_buffer, 0);
      if (currentBufferSize != rates_total) 
      {
         ArrayResize(_buffer, rates_total);
         for (int i = currentBufferSize; i < rates_total; ++i)
         {
            _buffer[i] = EMPTY_VALUE;
         }
      }
      if (_lastIndex == -1)
      {
         for (int i = 0; i <= pos; ++i)
         {
            _buffer[i] = defaultValue;
         }
         _lastIndex = pos;
         return;
      }
      for (int i = _lastIndex + 1; i <= pos; ++i)
      {
         _buffer[i] = _buffer[i - 1];
      }
      _lastIndex = pos;
   }

   void SetValue(int period, double value)
   {
      int pos = _rates_total - period - 1;
      _buffer[pos] = value;
      _lastIndex = pos;
   }

   double Get(int period)
   {
      int pos = _rates_total - period - 1;
      return _buffer[pos];
   }
};