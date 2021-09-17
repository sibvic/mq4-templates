// Stream factory interface v1.0
#ifndef IStreamFactory_IMP
#define IStreamFactory_IMP

interface IStreamFactory
{
public:
   virtual IStream *Create(const int order) = 0;
};

#endif