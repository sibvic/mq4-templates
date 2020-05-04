// Trend value cell v2.3

#ifndef TrendValueCell_IMP
#define TrendValueCell_IMP

#include <../conditions/ICondition.mq4>
#include <../Signaler.mq4>
#include <IValueFormatter.mq4>
#include <ICell.mq4>

class TrendValueCell : public ICell
{
   string _id;
   int _x;
   int _y;
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
   datetime _lastDatetime;
   ICondition* _conditions[];
   IValueFormatter* _valueFormatters[];
   Signaler* _signaler;
   datetime _lastSignalDate;
   int _lastSignal;
   int _alertShift;
   IValueFormatter* _defaultValue;
public:
   TrendValueCell(const string id, const int x, const int y, const string symbol, 
      const ENUM_TIMEFRAMES timeframe, int alertShift, 
      IValueFormatter* defaultValue)
   { 
      _lastSignal = 0;
      _alertShift = alertShift;
      _signaler = new Signaler(symbol, timeframe);
      _signaler.SetMessagePrefix(symbol + "/" + _signaler.GetTimeframeStr() + ": ");
      _id = id; 
      _x = x; 
      _y = y; 
      _symbol = symbol;
      _timeframe = timeframe;
      _defaultValue = defaultValue;
      _defaultValue.AddRef();
   }

   ~TrendValueCell()
   {
      delete _signaler;
      _defaultValue.Release();
      for (int i = 0; i < ArraySize(_conditions); ++i)
      {
         _conditions[i].Release();
         _valueFormatters[i].Release();
      }
      ArrayResize(_conditions, 0);
      ArrayResize(_valueFormatters, 0);
   }

   void AddCondition(ICondition* condition, IValueFormatter* value)
   {
      int size = ArraySize(_conditions);
      ArrayResize(_conditions, size + 1);
      ArrayResize(_valueFormatters, size + 1);
      _conditions[size] = condition;
      condition.AddRef();
      _valueFormatters[size] = value;
      value.AddRef();
   }

   virtual void HandleButtonClicks()
   {
      for (int i = 0; i < ArraySize(_conditions); ++i)
      {
         string id = _id + "B";
         if (ObjectGetInteger(0, id, OBJPROP_STATE))
         {
            ObjectSetInteger(0, id, OBJPROP_STATE, false);
            ChartOpen(_symbol, _timeframe);
         }
      }
   }

   virtual void Draw()
   {
      datetime date = iTime(_symbol, _timeframe, _alertShift);
      for (int i = 0; i < ArraySize(_conditions); ++i)
      {
         if (_conditions[i].IsPass(_alertShift, date))
         {
            color clr;
            string text = _valueFormatters[i].FormatItem(_alertShift, date, clr);
            DrawItem(text, clr, true);
            SendAlert(text, i);
            return;
         }
      }
      color clr;
      string text = _defaultValue.FormatItem(_alertShift, date, clr);
      DrawItem(text, clr, true);
   }

private:
   void DrawItem(string text, color clr, bool simpleLabel)
   {
      string id = _id + "B";
      if (simpleLabel)
      {
         ObjectDelete(id);
         ObjectMakeLabel(id, _x, _y, text, clr, 1, WindowNumber, "Arial", font_size); 
      }
      else
      {
         ObjectDelete(id);
         if (ObjectFind(id) < 0)
         {
            ObjectCreate(id, OBJ_BUTTON, WindowNumber, 0, 0);
         }
         ObjectSet(id, OBJPROP_XDISTANCE, _x);
         ObjectSet(id, OBJPROP_YDISTANCE, _y);
         ObjectSet(id, OBJPROP_CORNER, 1); 
         ObjectSetString(0, id, OBJPROP_FONT, "Arial");
         ObjectSetString(0, id, OBJPROP_TEXT, text);
         ObjectSetInteger(0, id, OBJPROP_COLOR, clr);
         ObjectSetInteger(0, id, OBJPROP_FONTSIZE, font_size);
         TextSetFont("Arial", -font_size * 10);
         int width, height;
         TextGetSize(text, width, height);
         ObjectSetInteger(0, id, OBJPROP_XSIZE, width + 5);
         ObjectSetInteger(0, id, OBJPROP_YSIZE, height + 5);
      }
   }

   void SendAlert(string text, int direction)
   {
      if (iTime(_symbol, _timeframe, 0) != _lastSignalDate && _lastSignal != direction)
      {
         _signaler.SendNotifications(text);
         _lastSignalDate = iTime(_symbol, _timeframe, 0);
         _lastSignal = direction;
      }
   }
};
#endif