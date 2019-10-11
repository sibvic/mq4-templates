// Trailing logic interface v1.0

#ifndef ITrailingLogic_IMP
#define ITrailingLogic_IMP

interface ITrailingLogic
{
public:
   virtual void DoLogic() = 0;
   virtual void Create(const int order, const double stop) = 0;
};

#endif