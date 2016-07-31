
module CCO.HM2SystemF (
    -- * Converting
    hm2systemf
) where

import CCO.HM2SystemF.AG
import qualified CCO.HM as HM (Tm)
import qualified CCO.SystemF as SF (Tm)
import CCO.Feedback (Feedback)

hm2systemf :: HM.Tm -> Feedback SF.Tm
hm2systemf t = do let syn = wrap_Tm (sem_Tm t) (Inh_Tm [] (subst_Syn_Tm syn) identifiers 0 []) 
                  return (sfrep_Syn_Tm syn)