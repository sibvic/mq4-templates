// Bars back value cell v1.0

#include <ICell.mq4>

#ifndef BarsBackValueCell_IMP
#define BarsBackValueCell_IMP

#define ENTER_BUY_SIGNAL 1
#define ENTER_SELL_SIGNAL -1
#define EXIT_BUY_SIGNAL 2
#define EXIT_SELL_SIGNAL -2
class BarsBackValueCell : public ICell
{
   string _id; int _x; int _y; string _symbol; ENUM_TIMEFRAMES _timeframe; datetime _lastDatetime;
   ICondition* _upCondition;
   ICondition* _downCondition;
public:
   BarsBackValueCell(const string id, const int x, const int y, const string symbol, const ENUM_TIMEFRAMES timeframe)
   { 
      _id = id; 
      _x = x; 
      _y = y; 
      _symbol = symbol; 
      _timeframe = timeframe; 
      _upCondition = CreateUpCondition(_symbol, _timeframe);
      _downCondition = CreateDownCondition(_symbol, _timeframe);
   }

   ~BarsBackValueCell()
   {
      delete _upCondition;
      delete _downCondition;
   }

   virtual void Draw()
   { 
      int barsBack;
      int direction = GetDirection(barsBack); 
      string label = direction != 0 ? IntegerToString(barsBack) : "-";
      ObjectMakeLabel(_id, _x, _y, label, GetDirectionColor(direction), 1, WindowNumber, "Arial", font_size);
   }

private:
   int GetDirection(int& barsBack)
   {
      for (barsBack = 0; barsBack < MathMin(MAX_LOOPBACK, iBars(_symbol, _timeframe) - 1); ++barsBack)
      {
         if (_upCondition.IsPass(barsBack))
            return ENTER_BUY_SIGNAL;
         if (_downCondition.IsPass(barsBack))
            return ENTER_SELL_SIGNAL;
      }
      barsBack = -1;
      return 0;
   }

   color GetDirectionColor(const int direction) { if (direction >= 1) { return Up_Color; } else if (direction <= -1) { return Dn_Color; } return Neutral_Color; }
};

#endif