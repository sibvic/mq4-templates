// Trailing logic interface v1.0

#ifndef ITrailingController_IMP
#define ITrailingController_IMP

enum TrailingControllerType
{
   TrailingControllerTypeStandard
#ifdef USE_ATR_TRAILLING
   ,TrailingControllerTypeATR
#endif
   ,TrailingControllerTypeStream
};

interface ITrailingController
{
public:
   virtual bool IsFinished() = 0;
   virtual void UpdateStop() = 0;
   virtual TrailingControllerType GetType() = 0;
};

#endif