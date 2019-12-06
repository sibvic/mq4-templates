// Forex currency template v1.1

#property copyright ""
#property link      ""
#property version   "1.0"
#property strict

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Green

#property indicator_level1 0
      
#property indicator_levelcolor Red
#property indicator_levelwidth 2
#property indicator_levelstyle STYLE_DOT
 
extern int Length = 20;

enum CurrencyPairs
{ 
   USD = 1,
   EUR = 2,
   GBP = 3,
   JPY = 4,
   CHF = 5,
   AUD = 6,
   NZD = 7,
   CAD = 8,
   ANY = 9
};
string Default[] = { "USD", "EUR", "GBP","JPY", "CHF",  "AUD", "NZD", "CAD", "Any" };
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
 
input  CurrencyPairs Selected = USD; // Currency
input bool UseMajorsOnly = true; // Use majors only
 
double Line[];
class SymbolData
{
public:
   string Symbol;
   int Side;
};
SymbolData* Symbols[];
 
string IndicatorName;
string IndicatorObjPrefix;

string GenerateIndicatorName(const string target)
{
   string name = target;
   int try = 2;
   while (WindowFind(name) != -1)
   {
      name = target + " #" + IntegerToString(try++);
   }
   return name;
}

int init()
{
   IndicatorName = GenerateIndicatorName("...");
   IndicatorObjPrefix = "__" + IndicatorName + "__";
   IndicatorShortName(IndicatorName);
   
   IndicatorBuffers(1);
   
   IndicatorDigits(Digits);
   
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, Line);
   
   CreateSymbolList();
    
   return(0);
}

int deinit()
{
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
      double value = 0;
      for (int index = 0; index < ArraySize(Symbols); index++)
      {
         SymbolData* symbolData = Symbols[index];
      }
      Line[pos] = value;
      pos--;
   } 
 
   return(0);
}

void CreateSymbolList()
{
   int currencyCount = UseMajorsOnly ? majorsCount : ArrayRange(currencies, 0);
   int symbolCount = 0;
   for (int i = 0; i < currencyCount; i++)
   {
      for (int ii = 0; ii < currencyCount; ii++)
      {
         if (currencies[i] == Default[Selected - 1] 
            || currencies[ii] == Default[Selected - 1] 
            || Default[Selected - 1] == "Any")
         {
            string symbol = currencies[i] + currencies[ii];
            if(MarketInfo(symbol, MODE_BID) > 0)
            {
               ArrayResize(Symbols, symbolCount + 1);
               Symbols[symbolCount] = new SymbolData();
               Symbols[symbolCount].Symbol = symbol;
               Symbols[symbolCount].Side = currencies[i] == Default[Selected - 1] ? 1 : -1;
               symbolCount++;
            }
			}
      }
   }
 
   return;
}
