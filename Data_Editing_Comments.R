library(dplyr)
setwd("D:/Users/Arman/Downloads")
data1 <- read.csv(file="Raw Data - MP3 - Oct2017 to Mar2018.csv", header=TRUE, sep=",")
#which( colnames(data1)=="Consistance" )
#which( colnames(data1)=="Valve.Vapeur.Douche.Transfer.Rossilator.Shower" )+3
#Taking the subsets of the data
sub1 <- data1[,60:65]
sub2 <- data1[95]
sub3 <- data1[97:137]

Data_Subset <- data1[c("MP3.Ã.nergie.Totale.IntensitÃ....tonne","TOTAL.PRODUCTION.RATE" ,"MP3.Papier.Grade",
                       "Run","Production..t.hr.","POIDS.DE.BASE","HUMIDITÃ.","PÃ.te.DÃ.bit..GPM.",
                       "DÃ.BIT.PÃ.TE.POIDS.DE.BASE")]
Data_Subset <- cbind(Data_Subset,sub1,sub2,sub3)
Data_Subset <- data.frame(Data_Subset)

########Only 1600
Data_Subset_1600 <- Data_Subset[which(Data_Subset$MP3.Papier.Grade == 1600),]
Final_Summary <- c()
Run_Unique <- unique(Data_Subset_1600$Run)
for(i in 1:length(Run_Unique)){
  Data_Subsetted_Run <- Data_Subset_1600[which(Data_Subset_1600$Run == Run_Unique[i]),]
  Data_Subsetted_Run[1] <- lapply(Data_Subsetted_Run[1], function(x) as.numeric(gsub("[,$]", "", x)))
  #Obtaining the average of each of the columns for a particular run based on the value stored in the Run_Unique file
  new_df <- summarise_each(Data_Subsetted_Run, funs(mean))
  Final_Summary <- rbind(Final_Summary,new_df)
}

########Only 1601
Data_Subset_1601 <- Data_Subset[which(Data_Subset$MP3.Papier.Grade == 1601),]
Run_Unique <- unique(Data_Subset_1601$Run)
for(i in 1:length(Run_Unique)){
  Data_Subsetted_Run <- Data_Subset_1601[which(Data_Subset_1601$Run == Run_Unique[i]),]
  Data_Subsetted_Run[1] <- lapply(Data_Subsetted_Run[1], function(x) as.numeric(gsub("[,$]", "", x)))
  new_df <- summarise_each(Data_Subsetted_Run, funs(mean))
  Final_Summary <- rbind(Final_Summary,new_df)
}

Final_Summary <- data.frame(Final_Summary)
Final_Summary$MP3.Ã.nergie.Totale.IntensitÃ....tonne <- paste("$",Final_Summary$MP3.Ã.nergie.Totale.IntensitÃ....tonne)
write.csv(Final_Summary, file = "Final_Summary.csv")

