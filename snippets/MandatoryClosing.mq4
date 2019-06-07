// Mandatory closing v.2.0
interface IMandatoryClosingLogic
{
public:
   virtual void DoLogic() = 0;
};

class NoMandatoryClosing : public IMandatoryClosingLogic
{
public:
   void DoLogic()
   {

   }
};

class DoMandatoryClosing : public IMandatoryClosingLogic
{
   int _magicNumber;
   int _slippagePoints;
   Signaler *_signaler;
public:
   DoMandatoryClosing(const int magicNumber, int slippagePoints)
   {
      _slippagePoints = slippagePoints;
      _magicNumber = magicNumber;
      _signaler = NULL;
   }

   void SetSignaler(Signaler *signaler)
   {
      _signaler = signaler;
   }

   void DoLogic()
   {
      OrdersIterator toClose();
      toClose.WhenMagicNumber(_magicNumber).WhenTrade();
      int positionsClosed = TradingCommands::CloseTrades(toClose, _slippagePoints);
      TradingCommands::DeleteOrders(_magicNumber);
      if (positionsClosed > 0 && _signaler != NULL)
         _signaler.SendNotifications("Mandatory closing");
   }
};