"ENlisib"=function(res.mca,nbvar,nbind,axes=c(1,2)){                              #res.mca r�sultat d'une ACM, nbvar: pourcentage ou nombre sur les modalit�s et nbind : pourcentage ou nombre sur les individus, axes : axes factoriels que l'on souhaite regarder
#Attention : si version de facto inf�rieure � 1_12 remplacer v.test par vtest
tab=as.matrix(res.mca$var$v.test)                                      #r�cup�ration des vtests des modalit�s dans un tableau
vtestmean1=mean(tab[,axes[1]])                                    #calcul de la moyenne des vtests
vtestmean2=mean(tab[,axes[2]])                                    #calcul de la moyenne des vtests
vtestsd1=sd(tab[,axes[1]])                                        #calcul de l'�cart-type des vtests
vtestsd2=sd(tab[,axes[2]])                                        #calcul de l'�cart-type des vtests
seuil1=vtestmean1+vtestsd1                                            #seuil=moyenne+�cart-type
seuil2=vtestmean2+vtestsd2                                            #seuil=moyenne+�cart-type
modext=which(abs(tab[,axes[1]])>=seuil1 | abs(tab[,axes[2]])>=seuil2)          #r�cup�ration des modalit�s dont la vtest est sup�rieure au seuil
tab2=which(abs(tab[,axes[1]])<seuil1 & abs(tab[,axes[2]])<seuil2)               #r�cup�ration des modalit�s dont la vtest est inf�rieure au seuil
if ((nbvar<=1) & (nbvar>=0)){
modmoy=tab2[sample(1:length(tab2),nbvar*length(tab2))]}                           #tirage au hasard des modalit�s r�cup�r�es � l'�tape pr�c�dente
else {
nbvar=nbvar/nrow(tab)
if (nbvar>1){ #si on demande plus de variables qu'il y en a
nbvar=1}
modmoy=tab2[sample(1:length(tab2),nbvar*length(tab2))]}
mod_kept=cbind(t(modext),t(modmoy))                                   #ensemble des modalit�s gard�es

#idem pour les variables qualitatives suppl�mentaires
if (!is.null(res.mca$quali.sup)){
tab=as.matrix(res.mca$quali.sup$v.test)                                      #r�cup�ration des vtests des modalit�s dans un tableau
vtestmean1=mean(tab[,axes[1]])                                    #calcul de la moyenne des vtests
vtestmean2=mean(tab[,axes[2]])                                    #calcul de la moyenne des vtests
vtestsd1=sd(tab[,axes[1]])                                        #calcul de l'�cart-type des vtests
vtestsd2=sd(tab[,axes[2]])                                        #calcul de l'�cart-type des vtests
seuil1=vtestmean1+vtestsd1                                            #seuil=moyenne+�cart-type
seuil2=vtestmean2+vtestsd2                                            #seuil=moyenne+�cart-type
modsupext=which(abs(tab[,axes[1]])>=seuil1 | abs(tab[,axes[2]])>=seuil2)          #r�cup�ration des modalit�s dont la vtest est sup�rieure au seuil
mod_sup_kept=modsupext #on ne garde que les modalit�s suppl�mentaires les plus extr�mes
}


tab=as.matrix(res.mca$ind$coord)                                      #r�cup�ration des coordonn�es des individus puis idem que pour les modalit�s
coordmean1=mean(abs(tab[,axes[1]]))
coordmean2=mean(abs(tab[,axes[2]]))
coordsd1=sd(abs(tab[,axes[1]]))
coordsd2=sd(abs(tab[,axes[2]]))
seuil1=coordmean1+coordsd1
seuil2=coordmean2+coordsd2
indext=which(abs(tab[,axes[1]])>=seuil1 | abs(tab[,axes[2]])>=seuil2)
tab2=which(abs(tab[,axes[1]])<seuil1 & abs(tab[,axes[2]])<seuil2)
if ((nbind<=1) & (nbind>=0)){
indmoy=tab2[sample(1:length(tab2),nbind*length(tab2))]}                           #tirage au hasard des modalit�s r�cup�r�es � l'�tape pr�c�dente
else {
nbind=nbind/nrow(tab)
if (nbind>1){ #si on demande plus d'individus qu'il y en a
nbind=1}
indmoy=tab2[sample(1:length(tab2),nbind*length(tab2))]}
ind_kept=cbind(t(indext),t(indmoy))

#idem pour les individus suppl�mentaires  
if(!is.null(res.mca$ind.sup)){
tab=as.matrix(res.mca$ind.sup$coord)                                      #r�cup�ration des coordonn�es des individus puis idem que pour les modalit�s
coordmean1=mean(abs(tab[,axes[1]]))
coordmean2=mean(abs(tab[,axes[2]]))
coordsd1=sd(abs(tab[,axes[1]]))
coordsd2=sd(abs(tab[,axes[2]]))
seuil1=coordmean1+coordsd1
seuil2=coordmean2+coordsd2
indsupext=which(abs(tab[,axes[1]])>=seuil1 | abs(tab[,axes[2]])>=seuil2)
ind_sup_kept=indsupext #on ne garde que les individus suppl�mentaires les plus extr�mes
}
                                                   
res=res.mca                                                           #remplissage du r�sultat avec seulement les individus et modalit�s s�lectionn�s
res$ind$coord=res.mca$ind$coord[ind_kept,]
res$ind$cos2=res.mca$ind$cos2[ind_kept,]
res$ind$contrib=res.mca$ind$contrib[ind_kept,]
if(!is.null(res.mca$ind.sup)){
if (length(ind_sup_kept)!=0){
res$ind.sup$coord=res.mca$ind.sup$coord[ind_sup_kept,]
res$ind.sup$cos2=res.mca$ind.sup$cos2[ind_sup_kept,]}
else{
res$ind.sup=NULL}
}
res$var$coord=res.mca$var$coord[mod_kept,]
res$var$cos2=res.mca$var$cos2[mod_kept,]
res$var$contrib=res.mca$var$contrib[mod_kept,]
res$var$v.test=res.mca$var$v.test[mod_kept,]
if (!is.null(res.mca$quali.sup)){
if (length(mod_sup_kept)!=0){
res$quali.sup$coord=res.mca$quali.sup$coord[mod_sup_kept,]
res$quali.sup$cos2=res.mca$quali.sup$cos2[mod_sup_kept,]
res$quali.sup$v.test=res.mca$quali.sup$v.test[mod_sup_kept,]}
else{
res$quali.sup=NULL}
}
plot.MCA(res,axes=axes)                                     #plot individus et modalit�s
plot.MCA(res,axes=axes,invisible=c("var","quali.sup"))                     #plot individus
plot.MCA(res,axes=axes,invisible=c("ind","ind.sup"))                     #plot modalit�s
}                                                 

#ENlisib(res.mca,0.05,50,axes=c(1,2))




