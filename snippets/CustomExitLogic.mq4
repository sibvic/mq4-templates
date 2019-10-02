// Custom exit logic v. 1.0
// More templates and snippets on https://github.com/sibvic/mq4-templates

interface ICustomExitLogic
{
public:
   virtual void DoLogic() = 0;
   virtual void Create(const int order) = 0;
};

class DisabledCustomExitLogic : public ICustomExitLogic
{
public:
   void DoLogic() {}
   void Create(const int order) {}
};

#include <actions/IAction.mq4>

class CustomExitAction : public IAction
{
   int _order;
   bool _finished;
public:
   CustomExitAction()
   {
      _finished = true;
   }

   virtual bool DoAction()
   {
      if (_finished || !OrderSelect(_order, SELECT_BY_TICKET, MODE_TRADES))
      {
         _finished = true;
         return true;
      }
      return false;
   }

   virtual bool SetOrder(const int order)
   {
      if (!_finished)
         return false;
      if (!OrderSelect(order, SELECT_BY_TICKET, MODE_TRADES))
         return false;

      _order = order;
      return true;
   }
};

class CustomExitLogic : public ICustomExitLogic
{
   IAction *_actions[];
public:
   CustomExitLogic()
   {
   }

   ~CustomExitLogic()
   {
      int i_count = ArraySize(_actions);
      for (int i = 0; i < i_count; ++i)
      {
         delete _actions[i];
      }
   }

   void DoLogic()
   {
      int i_count = ArraySize(_actions);
      for (int i = 0; i < i_count; ++i)
      {
         _actions[i].DoAction();
      }
   }

   void Create(const int order)
   {
      if (!OrderSelect(order, SELECT_BY_TICKET, MODE_TRADES) || OrderCloseTime() != 0.0)
         return;

      int i_count = ArraySize(_actions);
      for (int i = 0; i < i_count; ++i)
      {
         if (_actions[i].SetOrder(order))
         {
            return;
         }
      }

      ArrayResize(_actions, i_count + 1);
      _actions[i_count] = new CustomExitAction();
      _actions[i_count].SetOrder(order);
   }
};
