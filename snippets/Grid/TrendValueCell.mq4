// Trend value cell v2.1

#ifndef TrendValueCell_IMP
#define TrendValueCell_IMP

#include <../conditions/ICondition.mq4>
#include <../Signaler.mq4>

#ifndef ENTER_BUY_SIGNAL
#define ENTER_BUY_SIGNAL 1
#define CONFIRMED_ENTER_BUY_SIGNAL 2
#endif
#ifndef ENTER_SELL_SIGNAL
#define ENTER_SELL_SIGNAL -1
#define CONFIRMED_ENTER_SELL_SIGNAL -2
#endif

class TrendValueCell : public ICell
{
   string _id; int _x; int _y; string _symbol; ENUM_TIMEFRAMES _timeframe; datetime _lastDatetime;
   ICondition* _upCondition;
   ICondition* _downCondition;
   Signaler* _signaler;
   datetime _lastSignalDate;
   int _lastSignal;
   bool _alertUnconfermed;
public:
   TrendValueCell(const string id, const int x, const int y, const string symbol, const ENUM_TIMEFRAMES timeframe, bool alertUnconfermed)
   { 
      _lastSignal = 0;
      _alertUnconfermed = alertUnconfermed;
      _signaler = new Signaler(symbol, timeframe);
      _signaler.SetMessagePrefix(symbol + "/" + _signaler.GetTimeframeStr() + ": ");
      _id = id; 
      _x = x; 
      _y = y; 
      _symbol = symbol; 
      _timeframe = timeframe; 
      _upCondition = CreateUpCondition(_symbol, _timeframe);
      _downCondition = CreateDownCondition(_symbol, _timeframe);
   }

   ~TrendValueCell()
   {
      delete _signaler;
      delete _upCondition;
      delete _downCondition;
   }

   virtual void HandleButtonClicks()
   {
      if (ObjectGetInteger(0, _id + "B", OBJPROP_STATE))
      {
         ObjectSetInteger(0, _id + "B", OBJPROP_STATE, false);
         ChartSetSymbolPeriod(0, _symbol, _timeframe);
      }
   }

   virtual void Draw()
   { 
      int direction = GetDirection(); 
      string text = GetDirectionSymbol(direction);
      if (direction == 0)
      {
         ObjectDelete(_id + "B");
         ObjectMakeLabel(_id, _x, _y, GetDirectionSymbol(direction), GetDirectionColor(direction), 1, WindowNumber, "Arial", font_size); 
      }
      else
      {
         ObjectDelete(_id);
         if (ObjectFind(_id + "B") < 0)
         {
            ObjectCreate(_id + "B", OBJ_BUTTON, WindowNumber, 0, 0);
         }
         ObjectSet(_id + "B", OBJPROP_XDISTANCE, _x);
         ObjectSet(_id + "B", OBJPROP_YDISTANCE, _y);
         ObjectSet(_id + "B", OBJPROP_CORNER, 1); 
         ObjectSetString(0, _id + "B", OBJPROP_FONT, "Arial");
         ObjectSetString(0, _id + "B", OBJPROP_TEXT, text);
         ObjectSetInteger(0, _id + "B", OBJPROP_COLOR, GetDirectionColor(direction));
         ObjectSetInteger(0, _id + "B", OBJPROP_FONTSIZE, font_size);
         TextSetFont("Arial", -font_size * 10);
         int width, height;
         TextGetSize(text, width, height);
         ObjectSetInteger(0, _id + "B", OBJPROP_XSIZE, width + 5);
         ObjectSetInteger(0, _id + "B", OBJPROP_YSIZE, height + 5);
      }
      if (Time[0] != _lastSignalDate && _lastSignal != direction)
      {
         switch (direction)
         {
            case ENTER_BUY_SIGNAL:
               if (_alertUnconfermed)
               {
                  _signaler.SendNotifications("Buy");
                  _lastSignalDate = Time[0];
               }
               break;
            case ENTER_SELL_SIGNAL:
               if (_alertUnconfermed)
               {
                  _signaler.SendNotifications("Sell");
                  _lastSignalDate = Time[0];
               }
               break;
            case CONFIRMED_ENTER_BUY_SIGNAL:
               if (!_alertUnconfermed)
               {
                  _signaler.SendNotifications("Buy");
                  _lastSignalDate = Time[0];
               }
               break;
            case CONFIRMED_ENTER_SELL_SIGNAL:
               if (!_alertUnconfermed)
               {
                  _signaler.SendNotifications("Sell");
                  _lastSignalDate = Time[0];
               }
               break;
         }
         _lastSignal = direction;
      }
   }

private:
   int GetDirection()
   {
      datetime date = iTime(_symbol, _timeframe, 0);
      if (_upCondition.IsPass(0, date))
      {
         return ENTER_BUY_SIGNAL;
      }
      if (_downCondition.IsPass(0, date))
      {
         return ENTER_SELL_SIGNAL;
      }
      date = iTime(_symbol, _timeframe, 1);
      if (_upCondition.IsPass(1, date))
      {
         return CONFIRMED_ENTER_BUY_SIGNAL;
      }
      if (_downCondition.IsPass(1, date))
      {
         return CONFIRMED_ENTER_SELL_SIGNAL;
      }
      return 0;
   }

   color GetDirectionColor(const int direction)
   { 
      switch (direction)
      {
         case CONFIRMED_ENTER_BUY_SIGNAL:
            return Confirmed_Up_Color;
         case CONFIRMED_ENTER_SELL_SIGNAL:
            return Confirmed_Dn_Color;
         case ENTER_BUY_SIGNAL:
            return Unconfirmed_Up_Color;
         case ENTER_SELL_SIGNAL:
            return Unconfirmed_Dn_Color;
      }
      return Neutral_Color;
   }
   string GetDirectionSymbol(const int direction)
   {
      if (direction == ENTER_BUY_SIGNAL)
      {
         return "BUY*";
      }
      else if (direction == ENTER_SELL_SIGNAL)
      {
         return "SELL*";
      }
      if (direction == CONFIRMED_ENTER_BUY_SIGNAL)
      {
         return "BUY";
      }
      else if (direction == CONFIRMED_ENTER_SELL_SIGNAL)
      {
         return "SELL";
      }
      return "-";
   }
};
#endif