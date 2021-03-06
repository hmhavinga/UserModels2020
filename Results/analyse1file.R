studyFile <- read.csv(file = "Thomas_study.csv", header = TRUE, sep = ",", dec = ".")

# Initialize vectors for values
# After the for loop, create a dataframe with these vectors as columns in order to perform t-tests

nr_of_correct_total <- c()

nr_of_trials_hints <- c()
nr_of_trials_no_hints <- c()
nr_of_unique_words_hints <- c()
nr_of_unique_words_no_hints <- c()

nr_of_hints_bought <- c()
nr_of_hints_bought_unique_words <- c()
nr_of_correct_hint_bought <- c()
boolean_hint_condition_first <- c()

# distinction between words seen with hints and words seen without hints
nr_of_correct_hints <- c()
nr_of_correct_no_hints <- c()
nr_of_correct_not_seen <- c()

# distinction between short and long words
nr_of_correct_short <- c()
nr_of_correct_long <- c()

## Difference between ratio of (words correct)/(words seen) per condition
ratio_correct_vs_seen_hints <- c()
ratio_correct_vs_seen_no_hints <- c()

# Distinction based on both hints/no hints and short/long
# We probably won't use this but just in case
nr_of_correct_hints_short <- c()
nr_of_correct_no_hints_short <- c()
nr_of_correct_not_seen_short <- c()

nr_of_correct_hints_long <- c()
nr_of_correct_no_hints_long <- c()
nr_of_correct_not_seen_long <- c()

#Clean white-space

Study = studyFile[!is.na(studyFile$trial),]


# Label what condition comes first, for Study data.
# HintFirst means that the first block was the Hint condition

if (nrow(Study[which(Study$cond == "Hint" & Study$block == 1),]) == 0) {
  HintFirst = FALSE
} else {
  HintFirst = TRUE
}

boolean_hint_condition_first <- append(boolean_hint_condition_first, HintFirst)

#Get unique fact IDs per condition for this person:
hint_trials <- Study[Study$cond == 'Hint',]
nohint_trials <- Study[Study$cond == 'No Hint',]

nr_of_trials_hints <- append(nr_of_trials_hints, nrow(hint_trials))
nr_of_trials_no_hints <- append(nr_of_trials_no_hints, nrow(nohint_trials))

unique_fact_ids_hints = unique(hint_trials$fact_id)
unique_fact_ids_nohints = unique(nohint_trials$fact_id)

nr_of_unique_words_hints <- append(nr_of_unique_words_hints, length(unique_fact_ids_hints))
nr_of_unique_words_no_hints <- append(nr_of_unique_words_no_hints, length(unique_fact_ids_nohints))

## Check how many hints were bought
hint_bought_trials <- Study[Study$hint == 'True',]
nr_of_hints_bought <- append(nr_of_hints_bought, nrow(hint_bought_trials))
hint_fact_ids <- unique(hint_bought_trials$fact_id)
