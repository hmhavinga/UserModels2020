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


#Get unique fact IDs per condition for this person:
hint_trials = Study[Study$cond == 'Hint',]
nohint_trials = Study[Study$cond == 'No Hint',]
unique_fact_ids_hints = unique(hint_trials$fact_id)
unique_fact_ids_nohints = unique(nohint_trials$fact_id)