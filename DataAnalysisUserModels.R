# Set working directory to source file location first! (under session)

studyFile <- read.csv("Data/Training/Han-FullTrial-Even.csv", header = TRUE, sep = ",", dec = ".")
testFile <- read.csv("Data/Testing/Han_test.csv", header = TRUE, sep = ",", dec = ".")


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

## divide words from test in 3 categories (seen with hint, seen with no hint, not seen during study)
testNoHint <- testFile[testFile$fact_id %in% unique_fact_ids_nohints,]
testHint <- testFile[testFile$fact_id %in% unique_fact_ids_hints,]


#testCorrect <- testFile[testFile$correct == "yes",]

