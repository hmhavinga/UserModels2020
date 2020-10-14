# get files:
studyFile = Han.FullTrial.Even


#Clean white-space

Study = studyFile[!is.na(studyFile$trial),]


# Label what condition comes first, for Study data.
# HintFirst means that the first block was the Hint condition

if (nrow(Study[which(Study$cond == "Hint" & Study$block == 1),]) == 0) {
  HintFirst = FALSE
} else {
  HintFirst = TRUE
}
