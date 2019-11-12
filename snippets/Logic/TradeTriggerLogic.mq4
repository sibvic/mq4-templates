// Trade trigger logic v1.0

#include <TradeTriggerController.mq4>

#ifndef TradeTriggerLogic_IMP
#define TradeTriggerLogic_IMP

class TradeTriggerLogic
{
   TradeTriggerController *_triggers[];
public:
   ~TradeTriggerLogic()
   {
      Clear();
   }

   void Clear()
   {
      int count = ArraySize(_triggers);
      for (int i = 0; i < count; ++i)
      {
         delete _triggers[i];
      }
      ArrayResize(_triggers, 0);
   }

   void DoLogic()
   {
      int count = ArraySize(_triggers);
      for (int i = 0; i < count; ++i)
      {
         _triggers[i].DoLogic();
      }
   }

   void SetAction(const int order, IAction *actionOnTade)
   {
      int count = ArraySize(_triggers);
      for (int i = 0; i < count; ++i)
      {
         if (_triggers[i].SetAction(order, actionOnTade))
            return;
      }
      ArrayResize(_triggers, count + 1);
      _triggers[count] = new TradeTriggerController();
      _triggers[count].SetAction(order, actionOnTade);
   }
};

#endif