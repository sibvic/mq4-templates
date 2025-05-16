// Stream factory interface v2.0
#ifndef IStreamFactory_IMP
#define IStreamFactory_IMP

interface IStreamFactory
{
public:
   virtual TIStream<double>* Create(const int order) = 0;
};

#endif