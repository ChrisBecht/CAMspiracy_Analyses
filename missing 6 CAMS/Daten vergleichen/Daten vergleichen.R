setwd(dirname(rstudioapi::getSourceEditorContext()$path))
rm(list=ls(all=TRUE))

# load packages

library(openxlsx)
library(dplyr)


# load data

setwd("./data")

data_t12 <- read.xlsx("t12_questionnaireCAMs.xlsx") # Data set: https://github.com/ChrisBecht/CAMspiracy_Analyses/blob/main/t12_segCAMs/outputs/t12_questionnaireCAMs.xlsx
t2_invited <- read.xlsx("IDs_t2_coloured.xlsx") # Participants invited to t2: https://github.com/ChrisBecht/CAMspiracy_Analyses/blob/main/t1_segmentation/outputs/IDs_t2_coloured.xlsx and https://github.com/ChrisBecht/CAMspiracy_Analyses/blob/main/t1_segmentation/outputs/IDs_t2_additional_coloured.xlsx
t2_CAMs <- read.xlsx("questionnaireCAMs.xlsx") # Participants who submitted a CAM: https://github.com/ChrisBecht/CAMspiracy_Analyses/blob/main/t2_CAMs/dataPreperation_step1/outputs/questionnaireCAMs.xlsx

setwd("..")

# load functions

setwd("functions")

for(i in 1:length(dir())){
  source(dir()[i], encoding = "utf-8")
}
rm(i)

setwd("..")

#######################################################################################

# Filter rows of data_t12 according to criteria: 
## 1. Was participant invited to t2?: data_t12$Prolific_PID in t2_invited$ID
## 2. Did participant not participate in t2?: rows 104 to 132 (t2) empty

t2_dataEmpty <- data_t12 %>%
  filter(PROLIFIC_PID %in% t2_invited$ID) %>%
  filter(apply(.[, 104:182], 1, are_cols_empty))

setwd("./output")
write.xlsx(t2_dataEmpty, file = "t2_dataEmpty.xlsx")
setwd("..")

# -> 98 VPn wurden zwar eingeladen, aber haben nicht teilgenommen. 

#######################################################################################

# Filter rows of data_t12 according to criteria:
## 1. Was participant invited to t2?: data_t12$Prolific_PID in t2_invited$ID
## 2. Did participant  participate in t2?: not filtered in previous step

t2_data <- data_t12 %>%
  filter(PROLIFIC_PID %in% t2_invited$ID) %>%
  filter(!PROLIFIC_PID %in% t2_dataEmpty$PROLIFIC_PID)

setwd("./output")
write.xlsx(t2_data, file = "t2_data.xlsx")
setwd("..")

# -> Für t2 haben wir Daten von insg. 122 VPn. 

#######################################################################################

# Compare t2_data with t2_CAMs

t2_dataCAMs <- data_t12 %>%
  filter(PROLIFIC_PID %in% t2_CAMs$PROLIFIC_PID)

# -> Für t2 haben wir CAMs von insg. 130 VPn. 



t2_missing <- anti_join(t2_dataCAMs, t2_data, by = "PROLIFIC_PID")
setwd("./output")
write.xlsx(t2_missing, file = "t2_missing.xlsx")
setwd("..")

# -> 8 VPn wurden eingeladen, haben CAMs gezeichnet, aber keine Daten für t2. 
# -> 1 Person zusätzlich entfernt wegen fehlender Werte

#####################

# in t2 wurden insg. 130 CAMs erhoben (DE: 75, USA: 55)
# in zwei CAMs wurden die Valenzen nicht instruktionsgemäß angepasst (5b7e118e87d85f0001baac27, 5ff5922c4721d5000981fcde)
# in 7 CAMs gab es technische Probleme, z.B. Neuladen des Browsers (5fff542aeed8c2065133114e, 5c395df5f5ebd50001850900, 63d13f2f59ef764f641406dd, 61188057fe5a395476806c12, 60c14a3e834adb62102cffa0, 62d59a066ee263bb659aa445, 63cedc8a97a0bb604736baea)