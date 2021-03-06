 ###################################################
 ## Example 1: Evaluate reduct and generate 
 ##            new decision table
 ###################################################
 library(RoughSets)
 data(RoughSetData)
 decision.table <- RoughSetData$hiring.dt 

 ## evaluate single reduct
 res.1 <- FS.greedy.heuristic.superreduct.RST(decision.table)
 print(res.1)
 
 ## generate new decision table according to the reduct
 new.decTable <- SF.applyDecTable(decision.table, res.1)
 print(new.decTable)