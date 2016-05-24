data (diamonds.df)
diamonds.df
plot(price~weight,main="Price versus weight of diamonds",data=diamonds.df)
diamond.fit<-lm(price~weight,data=diamonds.df)
eovcheck(diamond.fit)
summary(diamond.fit)
layout20x(1,2)
plot(diamond.fit,which=1)
plot(residuals(diamond.fit)~diamonds.df$weight,main="Residual plot (weight)")
layout20x(1,1)
normcheck(diamond.fit)
ciReg(diamond.fit)
diamond.predict<-data.frame(c(0.3,1.2))
predict20x(diamond.fit,diamond.predict)
