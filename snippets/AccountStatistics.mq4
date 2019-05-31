extern color equity_color = White; // Equity & profit color
extern color color_text = Lime; // General text color
extern color header_color = Yellow; // Headers color

// Account statistics v.1.3
class AccountStatistics
{
   InstrumentInfo *_symbol;
   int _textCorner;
   string _eaName;
   int _fontSize;
   string _fontName;
   string _headersFontName;
public:
   AccountStatistics(string eaName)
   {
      _fontSize = 10;
      _eaName = eaName;
      _textCorner = 1;
      _symbol = new InstrumentInfo(_Symbol);
      _headersFontName = "Impact";
      _fontName = "Cambria";

      string_window("EA_NAME", 5, 5, 0); 
      ObjectSet("EA_NAME", OBJPROP_CORNER, 3); 
      ObjectSetText("EA_NAME", _eaName, _fontSize + 3, _headersFontName, header_color);
   }

   ~AccountStatistics()
   {
      delete _symbol;
   }

   void Update()
   {
      OrdersIterator it();
      it.WhenTrade().WhenMagicNumber(magic_number);
      double profit = 0.0;
      double profitWithCommissions = 0.0;
      while (it.Next())
      {
         profit += it.GetProfit();
         profitWithCommissions += it.GetProfit() + OrderCommission() + OrderSwap();
      }
      string currentDate;
      MqlDateTime current_time;
      TimeToStruct(TimeCurrent(), current_time);
      switch (current_time.day_of_week)
      {
         case MONDAY:
            currentDate = "MONDAY";
            break;
         case TUESDAY:
            currentDate = "TUESDAY";
            break;
         case WEDNESDAY:
            currentDate = "WEDNESDAY";
            break;
         case THURSDAY:
            currentDate = "THURSDAY";
            break;
         case FRIDAY:
            currentDate = "FRIDAY";
            break;
         case SATURDAY:
            currentDate = "SATURDAY";
            break;
         case SUNDAY:
            currentDate = "SUNDAY";
            break;
      }
      string_window("currentDate", 5, 18, 0);
      ObjectSetText("currentDate", currentDate + ", " + DoubleToStr(Day(), 0) + " - " + DoubleToStr(Month(), 0) + " - " + DoubleToStr(Year(), 0), _fontSize+ 1 , _headersFontName, header_color);
      ObjectSet("currentDate", OBJPROP_CORNER, _textCorner);

      string_window("Balance", 5, 15 + 20, 0);
      ObjectSetText("Balance"," Balance: " + DoubleToStr(AccountBalance(), 2), _fontSize, _fontName, color_text);
      ObjectSet("Balance", OBJPROP_CORNER,_textCorner);  

      string_window("Equity", 5, 30 + 20, 0);
      ObjectSetText("Equity", "Equity: " + DoubleToStr(AccountEquity(),2), _fontSize, _fontName, equity_color); 
      ObjectSet("Equity", OBJPROP_CORNER, _textCorner);  
      
      string_window("Profit", 5, 45 + 20, 0); 
      ObjectSetText("Profit", "Profit: " + DoubleToStr(profitWithCommissions, 2) , _fontSize, _fontName, equity_color); 
      ObjectSet("Profit", OBJPROP_CORNER, _textCorner);
      
      string_window("Leverage", 5, 60 + 20, 0);
      ObjectSetText("Leverage", "Leverage: " + DoubleToStr(AccountLeverage(), 0), _fontSize, _fontName, color_text);
      ObjectSet("Leverage", OBJPROP_CORNER, _textCorner);

      string_window("Spread", 5,75 + 20, 0);
      ObjectSetText("Spread", "Spread: " + DoubleToStr(_symbol.GetSpread(), 1), _fontSize, _fontName, color_text);
      ObjectSet("Spread", OBJPROP_CORNER, _textCorner);
      
      double Range = (iHigh(_symbol.GetSymbol(), 1440, 0) - iLow(_symbol.GetSymbol(), 1440, 0)) / _symbol.GetPipSize();
      string_window("Range", 5, 90 + 20, 0);
      ObjectSetText("Range","Range: " + DoubleToStr(Range, 1) , _fontSize, _fontName, color_text); 
      ObjectSet("Range", OBJPROP_CORNER, _textCorner); 
      
      string_window("Price", 5, 125, 0);
      ObjectSetText("Price", "Bid Price: " + DoubleToStr(_symbol.GetBid(), _symbol.GetDigits()), _fontSize, _fontName, GetPriceColor());
      ObjectSet("Price", OBJPROP_CORNER, _textCorner); 
   }
private:
   color GetPriceColor()
   {
      return Volume[0] %2 == 0 ? color_text : equity_color;
   }

   int string_window(string n, int xoff, int yoff, int WindowToUse)
   {
      ObjectCreate(n, OBJ_LABEL, WindowToUse, 0, 0);
      ObjectSet(n, OBJPROP_CORNER, 1);
      ObjectSet(n, OBJPROP_XDISTANCE, xoff);
      ObjectSet(n, OBJPROP_YDISTANCE, yoff);
      ObjectSet(n, OBJPROP_BACK, true);
      return 0;
   }
};