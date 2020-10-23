# Set working directory to source file location first! (under session)

# http://www.sthda.com/english/wiki/paired-samples-t-test-in-r
# install.packages("dplyr")
# library("dplyr")

study_files <- list.files(path = "Study", full.names = TRUE, pattern = "csv")
test_files <- list.files(path = "Test", full.names = TRUE, pattern = "csv")

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

# distinction based both hints/no hints and short/long
# Oke toch niet
# nr_of_correct_hints_short <- c()
# nr_of_correct_no_hints_short <- c()
# nr_of_correct_not_seen_short <- c()

# nr_of_correct_hints_long <- c()
# nr_of_correct_no_hints_long <- c()
# nr_of_correct_not_seen_long <- c()

results_index = 1

for (study_file in study_files) {
  studyFile <- read.csv(file = study_file, header = TRUE, sep = ",", dec = ".")
  testFile <- read.csv(file = test_files[results_index], header = TRUE, sep = ",", dec = ".")
  
  results_index = results_index + 1

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
  hint_trials = Study[Study$cond == 'Hint',]
  nohint_trials = Study[Study$cond == 'No Hint',]

  nr_of_trials_hints <- append(nr_of_trials_hints, nrow(hint_trials))
  nr_of_trials_no_hints <- append(nr_of_trials_no_hints, nrow(nohint_trials))

  unique_fact_ids_hints = unique(hint_trials$fact_id)
  unique_fact_ids_nohints = unique(nohint_trials$fact_id)

  nr_of_unique_words_hints <- append(nr_of_unique_words_hints, length(unique_fact_ids_hints))
  nr_of_unique_words_no_hints <- append(nr_of_unique_words_no_hints, length(unique_fact_ids_nohints))

  ## divide words from test in correct and incorrect
  testCorrect <- testFile[testFile$correct == "yes",]
  testIncorrect <- testFile[testFile$correct == "no",]

  nr_of_correct_total <- append(nr_of_correct_total, nrow(testCorrect))

  ## divide correct words from test in 3 categories (seen with hint, seen with no hint, not seen during study)
  correctNoHint <- testCorrect[testCorrect$fact_id %in% unique_fact_ids_nohints,]
  correctHint <- testCorrect[testCorrect$fact_id %in% unique_fact_ids_hints,]
  correctNotSeen <- testCorrect[!(testCorrect$fact_id %in% unique_fact_ids_hints) & !(testCorrect$fact_id %in% unique_fact_ids_nohints),]

  nr_of_correct_no_hints <- append(nr_of_correct_no_hints, nrow(correctNoHint))
  nr_of_correct_hints <- append(nr_of_correct_hints, nrow(correctHint))
  nr_of_correct_not_seen <- append(nr_of_correct_not_seen, nrow(correctNotSeen))

  ## divide correct words from test in short vs long
  correctShort <- testCorrect[testCorrect$easy_or_hard =="easy",]
  correctLong <- testCorrect[testCorrect$easy_or_hard =="hard",]

  nr_of_correct_short <- append(nr_of_correct_short, nrow(correctShort))
  nr_of_correct_long <- append(nr_of_correct_long, nrow(correctLong))
  
  ## Check how many hints were bought
  hint_bought_trials <- Study[Study$hint == 'True',]
  nr_of_hints_bought <- append(nr_of_hints_bought, nrow(hint_bought_trials))
  hint_fact_ids <- unique(hint_bought_trials$fact_id)
  correctHintBought <- testCorrect[testCorrect$fact_id %in% hint_fact_ids,]
  
  ## check for how many unique words hints were bought, and how many of these words were answered correctly during test
  nr_of_hints_bought_unique_words <- append(nr_of_hints_bought_unique_words, length(hint_fact_ids))
  nr_of_correct_hint_bought <- append(nr_of_correct_hint_bought, nrow(correctHintBought))

}

### Make dataframe
dat <- data.frame(boolean_hint_condition_first, nr_of_trials_hints, nr_of_trials_no_hints, 
                  nr_of_unique_words_hints, nr_of_unique_words_no_hints,
                  nr_of_correct_total, nr_of_correct_hints, nr_of_correct_no_hints, nr_of_correct_not_seen,
                  nr_of_correct_short, nr_of_correct_long,
                  nr_of_hints_bought, nr_of_hints_bought_unique_words, nr_of_correct_hint_bought)

### Perform t-tests

## Difference between number of correct answers for short vs long words
t.test(dat$nr_of_correct_short, dat$nr_of_correct_long, paired = TRUE, alternative = "two.sided")

## Difference between number of correct answers between conditions
t.test(dat$nr_of_correct_hints, dat$nr_of_correct_no_hints, paired = TRUE, alternative = "two.sided")

## Difference between number of trials between conditions
t.test(dat$nr_of_trials_hints, dat$nr_of_trials_no_hints, paired = TRUE, alternative = "two.sided")

## Difference between number of unique words seen between conditions
t.test(dat$nr_of_unique_words_hints, dat$nr_of_unique_words_no_hints, paired = TRUE, alternative = "two.sided")
