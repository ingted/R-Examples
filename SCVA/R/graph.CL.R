graph.CL<-function(design,CL,tr,data=read.table(file.choose(new=FALSE)),xlab="Measurement Times",ylab="Scores"){

  x<-1:nrow(data)
  
  if(design=="ATD"|design=="RBD"|design=="CRD"|design=="AB"){
    A<-data[,2][data[,1]=="A"]
    B<-data[,2][data[,1]=="B"]
    
    if(CL=="mean"){
      CLA<-mean(A)	
      CLB<-mean(B)
    }
    if(CL=="median"){
      CLA<-median(A)	
      CLB<-median(B)
    }
    if(CL=="bmed"){
      aa<-sort(A)
      bb<-sort(B)
      if(length(aa)<5){
        CLA<-median(A)
      }
      if(length(aa)==5|length(aa)==7|length(aa)==9|length(aa)==11){
        CLA<-(aa[ceiling(length(aa)/2)-1]+aa[ceiling(length(aa)/2)]+aa[ceiling(length(aa)/2)+1])/3
      }
      if(length(aa)>=13&length(aa)%%2==1){
        CLA<-(aa[ceiling(length(aa)/2)-2]+aa[ceiling(length(aa)/2)-1]+aa[ceiling(length(aa)/2)]+aa[ceiling(length(aa)/2)+1] +aa[ceiling(length(aa)/2)+2])/5
      }
      if(length(aa)==6|length(aa)==8|length(aa)==10|length(aa)==12){
        CLA<-1/6*aa[length(aa)/2-1]+1/3*aa[length(aa)/2]+1/3*aa[length(aa)/2+1]+1/6*aa[length(aa)/2+2]
      }
      if(length(aa)>13&length(aa)%%2==0){
        CLA<-1/10*aa[length(aa)/2-2]+1/5*aa[length(aa)/2-1]+1/5*aa[length(aa)/2]+1/5*aa[length(aa)/2+1]+1/5*aa[length(aa)/2+2]+1/10*aa[length(aa)/2+3]
      }
      if(length(bb)<5){
        CLB<-median(B)
      }
      if(length(bb)==5|length(bb)==7|length(bb)==9|length(bb)==11){
        CLB<-(bb[ceiling(length(bb)/2)-1]+bb[ceiling(length(bb)/2)]+bb[ceiling(length(bb)/2)+1])/3
      }
      if(length(bb)>=13&length(bb)%%2==1){
        CLB<-(bb[ceiling(length(bb)/2)-2]+bb[ceiling(length(bb)/2)-1]+bb[ceiling(length(bb)/2)]+bb[ceiling(length(bb)/2)+1]+bb[ceiling(length(bb)/2)+2])/5
      }
      if(length(bb)==6|length(bb)==8|length(bb)==10|length(bb)==12){
        CLB<-1/6*bb[length(bb)/2-1]+1/3*bb[length(bb)/2]+1/3*bb[length(bb)/2+1]+1/6*bb[length(bb)/2+2]
      }
      if(length(bb)>13&length(bb)%%2==0){
        CLB<-1/10*bb[length(bb)/2-2]+1/5*bb[length(bb)/2-1]+1/5*bb[length(bb)/2]+1/5*bb[length(bb)/2+1]+1/5*bb[length(bb)/2+2]+1/10*bb[length(bb)/2+3]
      }
    }
    if(CL=="trimmean"){
      CLA<-mean(A,trim=tr)	
      CLB<-mean(B,trim=tr)
    }  
    if(CL=="mest"){
      hpsi<-function(x,bend=1.28){
        hpsi<-ifelse(abs(x)<=bend,x,bend*sign(x))
        hpsi
      }
      mest<-function(x,bend=1.28,na.rm=F){
        if(na.rm)x<-x[!is.na(x)]
        if(mad(x)==0)stop("MAD=0. The M-estimator cannot be computed.")
        y<-(x-median(x))/mad(x)
        A<-sum(hpsi(y,bend))
        B<-length(x[abs(y)<=bend])
        mest<-median(x)+mad(x)*A/B
        repeat{
          y<-(x-mest)/mad(x)
          A<-sum(hpsi(y,bend))
          B<-length(x[abs(y)<=bend])
          newmest<-mest+mad(x)*A/B
          if(abs(newmest-mest) <.0001)break
          mest<-newmest
        }
        mest
      }
      CLA<-mest(A,bend=tr)	
      CLB<-mest(B,bend=tr)
    }

    if(design=="ATD"|design=="RBD"|design=="CRD"){
      plot(x,data[,2],type="n",xlab=xlab,ylab=ylab)
      points(x[data[,1]=="A"],data[,2][data[,1]=="A"],pch=1)
      points(x[data[,1]=="B"],data[,2][data[,1]=="B"],pch=16)
      a<-data[,2][data[,1]=="A"]
      b<-data[,2][data[,1]=="B"]
      MTa<-x[data[,1]=="A"]
      MTb<-x[data[,1]=="B"]
      for(it in 1:(length(a)-1)){
        lines(c(MTa[it],MTa[it+1]),c(a[it],a[it+1]),lty=2)
      }
      for(it in 1:(length(b)-1)){
        lines(c(MTb[it],MTb[it+1]),c(b[it],b[it+1]),lty=1)
      }
      lines(c(1,nrow(data)),c(CLA,CLA),lty=3)
      lines(c(1,nrow(data)),c(CLB,CLB),lty=6)
      legend(locator(1),lty=c(2,1,3,6),pch=c(1,16,46,46),legend=c("A","B","central tendency A","central tendency B"),cex=0.8)
    }
    if(design=="AB"){
      plot(x,data[,2],xlab=xlab,ylab=ylab,pch=16)
      lines(x[data[,1]=="A"],data[,2][data[,1]=="A"])
      lines(x[data[,1]=="B"],data[,2][data[,1]=="B"])
      lines(c(sum(data[,1]=="A")+0.5,sum(data[,1]=="A")+0.5),c(min(data[,2])-5,max(data[,2])+5),lty=2)
      mtext("A",side=3,at=(sum(data[,1]=="A")+1)/2)
      mtext("B",side=3,at=(sum(data[,1]=="A")+(sum(data[,1]=="B")+1)/2))
      lines(c(1,(sum(data[,1]=="A"))),c(CLA,CLA),lty=3)
      lines(c((sum(data[,1]=="A")+1),nrow(data)),c(CLB,CLB),lty=3)
    }
  }
  
  if(design=="ABA"|design=="ABAB"){
    A1<-data[,2][data[,1]=="A1"]
    B1<-data[,2][data[,1]=="B1"]
    A2<-data[,2][data[,1]=="A2"]
    B2<-data[,2][data[,1]=="B2"]
    
    if(CL=="mean"){
      CLA1<-mean(A1)
      CLB1<-mean(B1)
      CLA2<-mean(A2)
      CLB2<-mean(B2)
    }
    if(CL=="median"){
      CLA1<-median(A1)
      CLB1<-median(B1)
      CLA2<-median(A2)
      CLB2<-median(B2)
    }
    if(CL=="bmed"){
      aa1<-sort(A1)
      bb1<-sort(B1)
      aa2<-sort(A2)
      bb2<-sort(B2)
      if(length(aa1)<5){
        CLA1<-median(data[,2][data[,1]=="A1"])
      }
      if(length(aa1)==5|length(aa1)==7|length(aa1)==9|length(aa1)==11){
        CLA1<-(aa1[ceiling(length(aa1)/2)-1]+aa1[ceiling(length(aa1)/2)]+aa1[ceiling(length(aa1)/2)+1])/3
      }
      if(length(aa1)>=13&length(aa1)%%2==1){
        CLA1<-(aa1[ceiling(length(aa1)/2)-2]+aa1[ceiling(length(aa1)/2)-1]+aa1[ceiling(length(aa1)/2)]+aa1[ceiling(length(aa1)/2)+1] +aa1[ceiling(length(aa1)/2)+2])/5
      }
      if(length(aa1)==6|length(aa1)==8|length(aa1)==10|length(aa1)==12){
        CLA1<-1/6*aa1[length(aa1)/2-1]+1/3*aa1[length(aa1)/2]+1/3*aa1[length(aa1)/2+1]+1/6*aa1[length(aa1)/2+2]
      }
      if(length(aa1)>13&length(aa1)%%2==0){
        CLA1<-1/10*aa1[length(aa1)/2-2]+1/5*aa1[length(aa1)/2-1]+1/5*aa1[length(aa1)/2]+1/5*aa1[length(aa1)/2+1]+1/5*aa1[length(aa1)/2+2]+1/10*aa1[length(aa1)/2+3]
      }
      if(length(bb1)<5){
        CLB1<-median(data[,2][data[,1]=="B1"])
      }
      if(length(bb1)==5|length(bb1)==7|length(bb1)==9|length(bb1)==11){
        CLB1<-(bb1[ceiling(length(bb1)/2)-1]+bb1[ceiling(length(bb1)/2)]+bb1[ceiling(length(bb1)/2)+1])/3
      }
      if(length(bb1)>=13&length(bb1)%%2==1){
        CLB1<-(bb1[ceiling(length(bb1)/2)-2]+bb1[ceiling(length(bb1)/2)-1]+bb1[ceiling(length(bb1)/2)]+bb1[ceiling(length(bb1)/2)+1]+bb1[ceiling(length(bb1)/2)+2])/5
      }
      if(length(bb1)==6|length(bb1)==8|length(bb1)==10|length(bb1)==12){
        CLB1<-1/6*bb1[length(bb1)/2-1]+1/3*bb1[length(bb1)/2]+1/3*bb1[length(bb1)/2+1]+1/6*bb1[length(bb1)/2+2]
      }
      if(length(bb1)>13&length(bb1)%%2==0){
        CLB1<-1/10*bb1[length(bb1)/2-2]+1/5*bb1[length(bb1)/2-1]+1/5*bb1[length(bb1)/2]+1/5*bb1[length(bb1)/2+1]+1/5*bb1[length(bb1)/2+2]+1/10*bb1[length(bb1)/2+3]
      }
      if(length(aa2)<5){
        CLA2<-median(data[,2][data[,1]=="A2"])
      }
      if(length(aa2)==5|length(aa2)==7|length(aa2)==9|length(aa2)==11){
        CLA2<-(aa2[ceiling(length(aa2)/2)-1]+aa2[ceiling(length(aa2)/2)]+aa2[ceiling(length(aa2)/2)+1])/3
      }
      if(length(aa2)>=13&length(aa2)%%2==1){
        CLA2<-(aa2[ceiling(length(aa2)/2)-2]+aa2[ceiling(length(aa2)/2)-1]+aa2[ceiling(length(aa2)/2)]+aa2[ceiling(length(aa2)/2)+1] +aa2[ceiling(length(aa2)/2)+2])/5
      }
      if(length(aa2)==6|length(aa2)==8|length(aa2)==10|length(aa2)==12){
        CLA2<-1/6*aa2[length(aa2)/2-1]+1/3*aa2[length(aa2)/2]+1/3*aa2[length(aa2)/2+1]+1/6*aa2[length(aa2)/2+2]
      }
      if(length(aa2)>13&length(aa2)%%2==0){
        CLA2<-1/10*aa2[length(aa2)/2-2]+1/5*aa2[length(aa2)/2-1]+1/5*aa2[length(aa2)/2]+1/5*aa2[length(aa2)/2+1]+1/5*aa2[length(aa2)/2+2]+1/10*aa2[length(aa2)/2+3]
      }
      if(length(bb2)<5){
        CLB2<-median(data[,2][data[,1]=="B2"])
      }
      if(length(bb2)==5|length(bb2)==7|length(bb2)==9|length(bb2)==11){
        CLB2<-(bb2[ceiling(length(bb2)/2)-1]+bb2[ceiling(length(bb2)/2)]+bb2[ceiling(length(bb2)/2)+1])/3
      }
      if(length(bb2)>=13&length(bb2)%%2==1){
        CLB2<-(bb2[ceiling(length(bb2)/2)-2]+bb2[ceiling(length(bb2)/2)-1]+bb2[ceiling(length(bb2)/2)]+bb2[ceiling(length(bb2)/2)+1]+bb2[ceiling(length(bb2)/2)+2])/5
      }
      if(length(bb2)==6|length(bb2)==8|length(bb2)==10|length(bb2)==12){
        CLB2<-1/6*bb2[length(bb2)/2-1]+1/3*bb2[length(bb2)/2]+1/3*bb2[length(bb2)/2+1]+1/6*bb2[length(bb2)/2+2]
      }
      if(length(bb2)>13&length(bb2)%%2==0){
        CLB2<-1/10*bb2[length(bb2)/2-2]+1/5*bb2[length(bb2)/2-1]+1/5*bb2[length(bb2)/2]+1/5*bb2[length(bb2)/2+1]+1/5*bb2[length(bb2)/2+2]+1/10*bb2[length(bb2)/2+3]
      }
    }
    if(CL=="trimmean"){
      CLA1<-mean(A1,trim=tr)
      CLB1<-mean(B1,trim=tr)
      CLA2<-mean(A2,trim=tr)
      CLB2<-mean(B2,trim=tr)
    }
    if(CL=="mest"){
      hpsi<-function(x,bend=1.28){
        hpsi<-ifelse(abs(x)<=bend,x,bend*sign(x))
        hpsi
      }
      mest<-function(x,bend=1.28,na.rm=F){
        if(na.rm)x<-x[!is.na(x)]
        if(mad(x)==0)stop("MAD=0. The M-estimator cannot be computed.")
        y<-(x-median(x))/mad(x)
        A<-sum(hpsi(y,bend))
        B<-length(x[abs(y)<=bend])
        mest<-median(x)+mad(x)*A/B
        repeat{
          y<-(x-mest)/mad(x)
          A<-sum(hpsi(y,bend))
          B<-length(x[abs(y)<=bend])
          newmest<-mest+mad(x)*A/B
          if(abs(newmest-mest) <.0001)break
          mest<-newmest
        }
        mest
      }
      CLA1<-mest(A1,bend=tr)
      CLB1<-mest(B1,bend=tr)
      CLA2<-mest(A2,bend=tr)
      CLB2<-mest(B2,bend=tr)
    }
    plot(x,data[,2],xlab=xlab,ylab=ylab,pch=16)
    lines(x[data[,1]=="A1"],data[,2][data[,1]=="A1"])
    lines(x[data[,1]=="B1"],data[,2][data[,1]=="B1"])
    lines(x[data[,1]=="A2"],data[,2][data[,1]=="A2"])
    lines(c(sum(data[,1]=="A1")+0.5,sum(data[,1]=="A1")+0.5),c(min(data[,2])-5,max(data[,2])+5),lty=2)
    lines(c(sum(data[,1]=="A1")+sum(data[,1]=="B1")+0.5,sum(data[,1]=="A1")+sum(data[,1]=="B1")+0.5),c(min(data[,2])-5,max(data[,2])+5),lty=2)
    mtext("A",side=3,at=(sum(data[,1]=="A1")+1)/2)
    mtext("B",side=3,at=(sum(data[,1]=="A1")+(sum(data[,1]=="B1")+1)/2))
    mtext("A",side=3,at=(sum(data[,1]=="A1")+sum(data[,1]=="B1")+(sum(data[,1]=="A2")+1)/2))
    lines(c(1,(sum(data[,1]=="A1"))),c(CLA1,CLA1),lty=3)
    lines(c((sum(data[,1]=="A1")+1),(sum(data[,1]=="A1")+sum(data[,1]=="B1"))),c(CLB1,CLB1),lty=3)
    lines(c((sum(data[,1]=="A1")+sum(data[,1]=="B1")+1),(sum(data[,1]=="A1")+sum(data[,1]=="B1")+sum(data[,1]=="A2"))),c(CLA2,CLA2),lty=3)
    if(design=="ABAB"){
      lines(x[data[,1]=="B2"],data[,2][data[,1]=="B2"])
      lines(c(sum(data[,1]=="A1")+sum(data[,1]=="B1")+sum(data[,1]=="A2")+0.5,sum(data[,1]=="A1")+sum(data[,1]=="B1")+sum(data[,1]=="A2")+0.5),c(min(data[,2])-5,max(data[,2])+5),lty=2)
      mtext("B",side=3,at=(sum(data[,1]=="A1")+sum(data[,1]=="B1")+sum(data[,1]=="A2")+(sum(data[,1]=="B2")+1)/2))
      lines(c((sum(data[,1]=="A1")+sum(data[,1]=="B1")+sum(data[,1]=="A2")+1),nrow(data)),c(CLB2,CLB2),lty=3)
    }
  }  
  
  if(design=="MBD"){
    N<-ncol(data)/2
    par(mfrow=c(N,1))
    for(it in 1:N){
      A<-data[,it*2][data[,(it*2)-1]=="A"]
      B<-data[,it*2][data[,(it*2)-1]=="B"]
      
      if(CL=="mean"){
        CLA<-mean(A)	
        CLB<-mean(B)
      }
      if(CL=="median"){
        CLA<-median(A)	
        CLB<-median(B)
      }
      if(CL=="bmed"){
        aa<-sort(A)
        bb<-sort(B)
        if(length(aa)<5){
          CLA<-median(A)
        }
        if(length(aa)==5|length(aa)==7|length(aa)==9|length(aa)==11){
          CLA<-(aa[ceiling(length(aa)/2)-1]+aa[ceiling(length(aa)/2)]+aa[ceiling(length(aa)/2)+1])/3
        }
        if(length(aa)>=13&length(aa)%%2==1){
          CLA<-(aa[ceiling(length(aa)/2)-2]+aa[ceiling(length(aa)/2)-1]+aa[ceiling(length(aa)/2)]+aa[ceiling(length(aa)/2)+1] +aa[ceiling(length(aa)/2)+2])/5
        }
        if(length(aa)==6|length(aa)==8|length(aa)==10|length(aa)==12){
          CLA<-1/6*aa[length(aa)/2-1]+1/3*aa[length(aa)/2]+1/3*aa[length(aa)/2+1]+1/6*aa[length(aa)/2+2]
        }
        if(length(aa)>13&length(aa)%%2==0){
          CLA<-1/10*aa[length(aa)/2-2]+1/5*aa[length(aa)/2-1]+1/5*aa[length(aa)/2]+1/5*aa[length(aa)/2+1]+1/5*aa[length(aa)/2+2]+1/10*aa[length(aa)/2+3]
        }
        if(length(bb)<5){
          CLB<-median(B)
        }
        if(length(bb)==5|length(bb)==7|length(bb)==9|length(bb)==11){
          CLB<-(bb[ceiling(length(bb)/2)-1]+bb[ceiling(length(bb)/2)]+bb[ceiling(length(bb)/2)+1])/3
        }
        if(length(bb)>=13&length(bb)%%2==1){
          CLB<-(bb[ceiling(length(bb)/2)-2]+bb[ceiling(length(bb)/2)-1]+bb[ceiling(length(bb)/2)]+bb[ceiling(length(bb)/2)+1]+bb[ceiling(length(bb)/2)+2])/5
        }
        if(length(bb)==6|length(bb)==8|length(bb)==10|length(bb)==12){
          CLB<-1/6*bb[length(bb)/2-1]+1/3*bb[length(bb)/2]+1/3*bb[length(bb)/2+1]+1/6*bb[length(bb)/2+2]
        }
        if(length(bb)>13&length(bb)%%2==0){
          CLB<-1/10*bb[length(bb)/2-2]+1/5*bb[length(bb)/2-1]+1/5*bb[length(bb)/2]+1/5*bb[length(bb)/2+1]+1/5*bb[length(bb)/2+2]+1/10*bb[length(bb)/2+3]
        }
      }  
      if(CL=="trimmean"){
        CLA<-mean(A,trim=tr)	
        CLB<-mean(B,trim=tr)
      }
      if(CL=="mest"){
        hpsi<-function(x,bend=1.28){
          hpsi<-ifelse(abs(x)<=bend,x,bend*sign(x))
          hpsi
        }
        mest<-function(x,bend=1.28,na.rm=F){
          if(na.rm)x<-x[!is.na(x)]
          if(mad(x)==0)stop("MAD=0. The M-estimator cannot be computed.")
          y<-(x-median(x))/mad(x)
          A<-sum(hpsi(y,bend))
          B<-length(x[abs(y)<=bend])
          mest<-median(x)+mad(x)*A/B
          repeat{
            y<-(x-mest)/mad(x)
            A<-sum(hpsi(y,bend))
            B<-length(x[abs(y)<=bend])
            newmest<-mest+mad(x)*A/B
            if(abs(newmest-mest) <.0001)break
            mest<-newmest
          }
          mest
        }
        CLA<-mest(A,bend=tr)	
        CLB<-mest(B,bend=tr)
      }
      plot(x,data[,it*2],xlab="",ylab=ylab,pch=16)
      lines(x[data[,(it*2)-1]=="A"],data[,it*2][data[,(it*2)-1]=="A"])
      lines(x[data[,(it*2)-1]=="B"],data[,it*2][data[,(it*2)-1]=="B"])
      lines(c(sum(data[,(it*2)-1]=="A")+0.5,sum(data[,(it*2)-1]=="A")+0.5),c(min(data[,it*2])-5,max(data[,it*2])+5),lty=2)
      mtext("A",side=3,at=(sum(data[,(it*2)-1]=="A")+1)/2)
      mtext("B",side=3,at=(sum(data[,(it*2)-1]=="A")+(sum(data[,(it*2)-1]=="B")+1)/2))
      lines(c(1,(sum(data[,(it*2)-1]=="A"))),c(CLA,CLA),lty=3)
      lines(c((sum(data[,(it*2)-1]=="A")+1),nrow(data)),c(CLB,CLB),lty=3)
    }    
    title(xlab=xlab,pch=16)

    par(mfrow=c(1,1)) 
  }

}
