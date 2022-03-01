;;; ***************************
;;; * DEFTEMPLATES & DEFFACTS *
;;; ***************************

(deftemplate UI-state
   (slot id (default-dynamic (gensym*)))
   (slot display)
   (slot relation-asserted (default none))
   (slot response (default none))
   (multislot valid-answers)
   (slot state (default middle)))
   
(deftemplate state-list
   (slot current)
   (multislot sequence))
  
(deffacts startup
   (state-list))
   
;;;****************
;;;* STARTUP RULE *
;;;****************

(defrule system-banner ""
  =>
  (assert (UI-state (display WelcomeMessage)
                    (relation-asserted start)
                    (state initial)
                    (valid-answers))))

;;;***************
;;;* QUERY RULES *
;;;***************

(defrule determine-who ""
   (logical (start))
   =>
   (assert (UI-state (display StartQuestion)
                     (relation-asserted who)
                     (valid-answers SignificantOther Friend SecretSanta FamilyMember CoWorker))))
   
(defrule determine-whoFamily ""
   (logical (who FamilyMember))
   =>
   (assert (UI-state (display WhoFamilyQuestion)
                     (relation-asserted whoFamily)
                     (valid-answers ASibling Parents TheInlaws))))
                     
(defrule determine-Overachiever ""
   (logical (whoFamily ASibling))
   =>
   (assert (UI-state (display Overachiever)
                     (relation-asserted Overachiever)
                     (valid-answers NotMe Me))))
                     
(defrule determine-HighRoad ""
   (logical (Overachiever NotMe))
   =>
   (assert (UI-state (display HighRoad)
                     (relation-asserted HighRoad)
                     (valid-answers Yes No))))

(defrule ChateauDiana ""
   (logical (HighRoad No))
   =>
   (assert (UI-state (display ChateauDiana)
                     (state final))))            
                     
(defrule ReservaRioja ""
   (logical (HighRoad Yes))
   =>
   (assert (UI-state (display ReservaRioja)
                     (state final))))    

(defrule determine-StickIt ""
   (logical (Overachiever Me))
   =>
   (assert (UI-state (display StickIt)
                     (relation-asserted StickIt)
                     (valid-answers Yes No))))

(defrule ClassifiedGrowthBordeAux ""
   (logical (StickIt Yes))
   =>
   (assert (UI-state (display ClassifiedGrowthBordeAux)
                     (state final))))   

(defrule determine-AwfullyBig ""
   (logical (StickIt No))
   =>
   (assert (UI-state (display AwfullyBig)
                     (relation-asserted AwfullyBig)
                     (valid-answers))))

(defrule OregonPinotNoir ""
   (logical (AwfullyBig))
   =>
   (assert (UI-state (display OregonPinotNoir)
                     (state final))))                     

(defrule determine-GoldenChild ""
   (logical (whoFamily Parents))
   =>
   (assert (UI-state (display GoldenChild)
                     (relation-asserted GoldenChild)
                     (valid-answers Yes No))))

(defrule TheirFavorite ""
   (logical (GoldenChild Yes))
   =>
   (assert (UI-state (display TheirFavorite)
                     (state final))))  

(defrule determine-TryingGood ""
   (logical (GoldenChild No))
   =>
   (assert (UI-state (display TryingGood)
                     (relation-asserted TryingGood)
                     (valid-answers Yes Meh))))
                     
 (defrule RussianNoir ""
   (logical (TryingGood Yes))
   =>
   (assert (UI-state (display RussianNoir)
                     (state final))))                  

(defrule JugWine ""
   (logical (TryingGood Meh))
   =>
   (assert (UI-state (display JugWine)
                     (state final))))


(defrule determine-WeHelp ""
   (logical (whoFamily TheInlaws))
   =>
   (assert (UI-state (display WeHelp)
                     (relation-asserted WeHelp)
                     (valid-answers))))

(defrule determine-AtTheirHouse ""
   (logical (WeHelp))
   =>
   (assert (UI-state (display AtTheirHouse)
                     (relation-asserted AtTheirHouse)
                     (valid-answers Yes No))))

(defrule Zinfandel ""
   (logical (AtTheirHouse Yes))
   =>
   (assert (UI-state (display Zinfandel)
                     (state final))))  
                     
(defrule determine-HowMarriage ""
   (logical (AtTheirHouse No))
   =>
   (assert (UI-state (display HowMarriage)
                     (relation-asserted HowMarriage)
                     (valid-answers Bliss Divorce))))               

(defrule AgedRum ""
   (logical (HowMarriage Divorce))
   =>
   (assert (UI-state (display AgedRum)
                     (state final))))  
                     
(defrule determine-AndTheInlaws ""
   (logical (HowMarriage Bliss))
   =>
   (assert (UI-state (display AndTheInlaws)
                     (relation-asserted AndTheInlaws)
                     (valid-answers Love Shoot))))                      
                     
(defrule MoselRiesling ""
   (logical (AndTheInlaws Shoot))
   =>
   (assert (UI-state (display MoselRiesling)
                     (state final))))                      
                     
(defrule determine-Seriously ""
   (logical (AndTheInlaws Love))
   =>
   (assert (UI-state (display Seriously)
                     (relation-asserted Seriously)
                     (valid-answers IKnow))))                      
                     
(defrule ChateauneufDuPape ""
   (logical (Seriously IKnow))
   =>
   (assert (UI-state (display ChateauneufDuPape)
                     (state final))))                   
                     
(defrule determine-Broke ""

   (logical (who SecretSanta))
   =>
   (assert (UI-state (display Broke)
                     (relation-asserted Broke)
                     (valid-answers Yes No))))              
         
(defrule 2BuckChuck ""
   (logical (Broke Yes))
   =>
   (assert (UI-state (display 2BuckChuck)
                     (state final))))  

(defrule PasoRoblesCab ""
   (logical (Broke No))
   =>
   (assert (UI-state (display PasoRoblesCab)
                     (state final))))           
         
              
              
(defrule determine-ActuallyBoss ""
   (logical (who CoWorker))
   =>
   (assert (UI-state (display ActuallyBoss)
                     (relation-asserted ActuallyBoss)
                     (valid-answers Yes No))))               
              
(defrule Malbec ""
   (logical (ActuallyBoss No))
   =>
   (assert (UI-state (display Malbec)
                     (state final))))     
   
(defrule determine-BossSnob ""
   (logical (ActuallyBoss Yes))
   =>
   (assert (UI-state (display BossSnob)
                     (relation-asserted BossSnob)
                     (valid-answers Yes No))))     
   
(defrule NapaCabernet ""
   (logical (BossSnob Yes))
   =>
   (assert (UI-state (display NapaCabernet)
                     (state final))))    
                     
(defrule determine-Strategy ""
   (logical (BossSnob No))
   =>
   (assert (UI-state (display Strategy)
                     (relation-asserted Strategy)
                     (valid-answers WaitJanuary Rise Qutting DogHouse))))                       
                     
(defrule PrestigeCuveeChampagne ""
   (logical (Strategy WaitJanuary))
   =>
   (assert (UI-state (display PrestigeCuveeChampagne)
                     (state final))))                     
                     
(defrule PriemierCruRedBurgundy ""
   (logical (Strategy Rise))
   =>
   (assert (UI-state (display PriemierCruRedBurgundy)
                     (state final))))                      
                     
(defrule AGoodTuscan ""
   (logical (Strategy DogHouse))
   =>
   (assert (UI-state (display AGoodTuscan)
                     (state final))))                       
                     
(defrule determine-BetterJob ""
   (logical (Strategy Qutting))
   =>
   (assert (UI-state (display BetterJob)
                     (relation-asserted BetterJob)
                     (valid-answers Yes No))))  
                     
(defrule Amarone ""
   (logical (BetterJob Yes))
   =>
   (assert (UI-state (display Amarone)
                     (state final))))                                         

(defrule ChateauDiana2 ""
   (logical (BetterJob No))
   =>
   (assert (UI-state (display ChateauDiana)
                     (state final)))) 

(defrule determine-LikeWine ""
   (logical (who Friend))
   =>
   (assert (UI-state (display LikeWine)
                     (relation-asserted LikeWine)
                     (valid-answers Yes ActuallyNo))))   

(defrule JackDaniels ""
   (logical (LikeWine ActuallyNo))
   =>
   (assert (UI-state (display JackDaniels)
                     (state final)))) 

(defrule determine-Bestie ""
   (logical (LikeWine Yes))
   =>
   (assert (UI-state (display Bestie)
                     (relation-asserted Bestie)
                     (valid-answers Yes No))))   

(defrule PrestigeCuveeChampagne2 ""
   (logical (Bestie Yes))
   =>
   (assert (UI-state (display PrestigeCuveeChampagne)
                     (state final)))) 
 
 (defrule Malbec2 ""
   (logical (Bestie No))
   =>
   (assert (UI-state (display Malbec)
                     (state final)))) 
 
 (defrule determine-HowLong ""
   (logical (who SignificantOther))
   =>
   (assert (UI-state (display HowLong)
                     (relation-asserted HowLong)
                     (valid-answers ItsNewAnd Forever))))  
 
  (defrule determine-ItsNewAnd ""
   (logical (HowLong ItsNewAnd))
   =>
   (assert (UI-state (display ItsNewAnd)
                     (relation-asserted ItsNewAnd)
                     (valid-answers ItSerious ItFling))))  
 
  (defrule Barolo ""
   (logical (ItsNewAnd ItSerious))
   =>
   (assert (UI-state (display Barolo)
                     (state final)))) 
                     
  (defrule JackDaniels2 ""
   (logical (ItsNewAnd ItFling))
   =>
   (assert (UI-state (display JackDaniels)
                     (state final))))                   
                     
  (defrule determine-WhatsNext ""
   (logical (HowLong Forever))
   =>
   (assert (UI-state (display WhatsNext)
                     (relation-asserted WhatsNext)
                     (valid-answers Propose HonestLook))))                    
                     
  (defrule Assyrtiko ""
   (logical (WhatsNext Propose))
   =>
   (assert (UI-state (display Assyrtiko)
                     (state final))))                       
                     
  (defrule determine-HonestLook ""
   (logical (WhatsNext HonestLook))
   =>
   (assert (UI-state (display HonestLook)
                     (relation-asserted HonestLook)
                     (valid-answers awesome timeAtWork))))                       
                     
  (defrule Chablis ""
   (logical (HonestLook awesome))
   =>
   (assert (UI-state (display Chablis)
                     (state final))))     
  
  (defrule OpusOne ""
   (logical (HonestLook timeAtWork))
   =>
   (assert (UI-state (display OpusOne)
                     (state final))))     
       
(defrule no-wine ""

   (declare (salience -10))
   (logical (UI-state (id ?id)))
   (state-list (current ?id))
   =>
   (assert (UI-state (display NoWine)
                     (state final))))
                     
;;;*************************
;;;* GUI INTERACTION RULES *
;;;*************************

(defrule ask-question
   (declare (salience 5))
   (UI-state (id ?id))
   ?f <- (state-list (sequence $?s&:(not (member$ ?id ?s))))     
   =>
   (modify ?f (current ?id)
              (sequence ?id ?s))
   (halt))

(defrule handle-next-no-change-none-middle-of-chain
   (declare (salience 10))
   ?f1 <- (next ?id)
   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))            
   =>
   (retract ?f1)
   (modify ?f2 (current ?nid))
   (halt))

(defrule handle-next-response-none-end-of-chain
   (declare (salience 10))
   ?f <- (next ?id)
   (state-list (sequence ?id $?))
   (UI-state (id ?id)
             (relation-asserted ?relation))              
   =>
   (retract ?f)
   (assert (add-response ?id)))   

(defrule handle-next-no-change-middle-of-chain
   (declare (salience 10))
   ?f1 <- (next ?id ?response)
   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
   (UI-state (id ?id) (response ?response))
   => 
   (retract ?f1)
   (modify ?f2 (current ?nid))
   (halt))

(defrule handle-next-change-middle-of-chain
   (declare (salience 10))
   (next ?id ?response)
   ?f1 <- (state-list (current ?id) (sequence ?nid $?b ?id $?e))
   (UI-state (id ?id) (response ~?response))
   ?f2 <- (UI-state (id ?nid))
   =>  
   (modify ?f1 (sequence ?b ?id ?e))
   (retract ?f2))
   
(defrule handle-next-response-end-of-chain
   (declare (salience 10))
   ?f1 <- (next ?id ?response)
   (state-list (sequence ?id $?))
   ?f2 <- (UI-state (id ?id)
                    (response ?expected)
                    (relation-asserted ?relation))           
   =>
   (retract ?f1)
   (if (neq ?response ?expected)
      then
      (modify ?f2 (response ?response)))
   (assert (add-response ?id ?response)))   

(defrule handle-add-response
   (declare (salience 10))
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   ?f1 <- (add-response ?id ?response)         
   =>
   (str-assert (str-cat "(" ?relation " " ?response ")"))
   (retract ?f1))   

(defrule handle-add-response-none
   (declare (salience 10))
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   ?f1 <- (add-response ?id)           
   => 
   (str-assert (str-cat "(" ?relation ")"))
   (retract ?f1))   

(defrule handle-prev
   (declare (salience 10))
   ?f1 <- (prev ?id)
   ?f2 <- (state-list (sequence $?b ?id ?p $?e))          
   =>
   (retract ?f1)
   (modify ?f2 (current ?p))
   (halt))
   
