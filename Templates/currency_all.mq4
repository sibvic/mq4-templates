#property version   "1.0"

#property strict

#property indicator_separate_window
#property indicator_buffers 8
#property indicator_color1 Green
#property indicator_color2 Green
#property indicator_color3 Green
#property indicator_color4 Green
#property indicator_color5 Green
#property indicator_color6 Green
#property indicator_color7 Green
#property indicator_color8 Green

#property indicator_level1 0
      
#property indicator_levelcolor Red
#property indicator_levelwidth 2
#property indicator_levelstyle STYLE_DOT
 
extern int period = 20;

enum CurrencyPairs
{ 
   USD = 1,
   EUR = 2,
   GBP = 3,
   JPY = 4,
   CHF = 5,
   AUD = 6,
   NZD = 7,
   CAD = 8
};
string Default[] = { "USD", "EUR", "GBP","JPY", "CHF",  "AUD", "NZD", "CAD" };
string currencies[] = 
{
   //majors
   "AUD", "CAD", "CHF", "EUR", "GBP", "JPY", "NZD", "USD", 
   // minors
   "AED", "BHD", "BRL", "CNY", "CYP", "CZK", "DKK", "DZD", "EEK", "EGP", "HKD", "HRK", "HUF", "IDR", "ILS", "INR", "IQD", "IRR", "ISK", "JOD", 
   "KRW", "KWD", "LBP", "LTL", "LVL", "LYD", "MAD", "MXN", "MYR", "NOK", "OMR", "PHP", "PLN", "QAR", "RON", "RUB", "SAR", "SEK", "SGD", "SKK", 
   "SYP", "THB", "TND", "TRY", "TWD", "VEB", "XAG", "XAU", "YER", "ZAR"
};
#define majorsCount 8
 
input bool UseMajorsOnly = true; // Use majors only

class SymbolData
{
public:
   string Symbol;
   int Side;
};
class OutputData
{
public:
   SymbolData* Symbols[];
   double Line[];
   string Currency;

   void CreateSymbolList()
   {
      int currencyCount = UseMajorsOnly ? majorsCount : ArrayRange(currencies, 0);
      int symbolCount = 0;
      for (int i = 0; i < currencyCount; i++)
      {
         for (int ii = 0; ii < currencyCount; ii++)
         {
            if (currencies[i] == Currency || currencies[ii] == Currency)
            {
               string symbol = currencies[i] + currencies[ii];
               if (MarketInfo(symbol, MODE_BID) > 0)
               {
                  ArrayResize(Symbols, symbolCount + 1);
                  Symbols[symbolCount] = new SymbolData();
                  Symbols[symbolCount].Symbol = symbol;
                  Symbols[symbolCount].Side = currencies[i] == Currency ? 1 : -1;
                  symbolCount++;
               }
            }
         }
      }
   }
};
 
OutputData* lines[];
 
string IndicatorObjPrefix;

bool NamesCollision(const string name)
{
   for (int k = ObjectsTotal(); k >= 0; k--)
   {
      if (StringFind(ObjectName(0, k), name) == 0)
      {
         return true;
      }
   }
   return false;
}

string GenerateIndicatorPrefix(const string target)
{
   for (int i = 0; i < 1000; ++i)
   {
      string prefix = target + "_" + IntegerToString(i);
      if (!NamesCollision(prefix))
      {
         return prefix;
      }
   }
   return target;
}

int init()
{
   IndicatorObjPrefix = GenerateIndicatorPrefix("..");
   IndicatorShortName("..");
   
   IndicatorBuffers(8);
   
   IndicatorDigits(Digits);
   
   int id = 0;
   ArrayResize(lines, 8);
   for (int i = 0; i < 8; ++i)
   {
      lines[i] = new OutputData();
      SetIndexStyle(id, DRAW_LINE);
      SetIndexLabel(id, Default[i]);
      SetIndexBuffer(id++, lines[i].Line);
      lines[i].Currency = Default[i];
      lines[i].CreateSymbolList();
   }
    
   return(0);
}

int deinit()
{
   for (int i = 0; i < ArraySize(lines); ++i)
   {
      delete lines[i];
   }
   ArrayResize(lines, 0);
   ObjectsDeleteAll(ChartID(), IndicatorObjPrefix);
   return(0);
}

int start()
{
   if (Bars <= 1) 
      return 0;
   int ExtCountedBars = IndicatorCounted();
   if (ExtCountedBars < 0) 
      return -1;
   int limit = Bars - 2;
   if (ExtCountedBars > 1) 
      limit = Bars - ExtCountedBars;
   int pos = limit;
   while (pos >= 0)
   {
      for (int i = 0; i < ArraySize(lines); ++i)
      {
         double value = 0;
         for (int index = 0; index < ArraySize(lines[i].Symbols); index++)
         {
            SymbolData* symbolData = lines[i].Symbols[index];
            int index = iBarShift(symbolData.Symbol, _Period, Time[pos]);
            double val = 0;
            if (symbolData.Side == -1)
            {
               value += 100 - val;
            }
            else
            {
               value += val;
            }
         }
         lines[i].Line[pos] = value / ArraySize(lines[i].Symbols) * 100;
      }
      pos--;
   } 
 
   return(0);
}

