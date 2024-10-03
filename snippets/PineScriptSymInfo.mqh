// PineScript syminfo.* functions
// v1.0

class SymInfo
{
public:
   static string TickerId()
   {
      return _Symbol;
   }
   
   static string Currency()
   {
      return SymbolInfoString(_Symbol, SYMBOL_CURRENCY_PROFIT);
   }
};