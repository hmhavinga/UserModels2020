# Set working directory to source file location first! (under session)

# http://www.sthda.com/english/wiki/paired-samples-t-test-in-r
# install.packages("dplyr")
# library("dplyr")

install.packages("ggplot2")
library("ggplot2")

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

## Difference between ratio of (words correct)/(words seen) per condition
ratio_correct_vs_seen_hints <- c()
ratio_correct_vs_seen_no_hints <- c()

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
  
  ratio_correct_vs_seen_hints <- append(ratio_correct_vs_seen_hints, nrow(correctHint) / length(unique_fact_ids_hints))
  ratio_correct_vs_seen_no_hints <- append(ratio_correct_vs_seen_no_hints, nrow(correctNoHint) / length(unique_fact_ids_nohints))

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

### Perform t-tests and make plots

## Difference between number of correct answers for short vs long words
t.test(dat$nr_of_correct_short, dat$nr_of_correct_long, paired = TRUE, alternative = "two.sided")

## In absolute number of words
short_long <- rbind(nr_of_correct_short, nr_of_correct_long)
barplot(short_long, ylim = c(0,20), beside = TRUE, col = c("green2", "purple"), 
        main = "Recall of short words versus long words", ylab = "Nr of correct answers",
        legend.text = c("short", "long"), 
        names.arg = c("Subject 1", "Subject 2", "Subject 3", "Subject 4", "Subject 5", "Subject 6", "Subject 7",
                      "Subject 8", "Subject 9") )

#barplot(dat$nr_of_correct_short, col=rainbow(9))

## In a percentage
short_long_percentage <- ((short_long / 4.8) * 10 )
barplot(short_long_percentage, ylim = c(0,45), beside = TRUE, col = c("green2", "purple"), 
        main = "Recall of short words versus long words", ylab = "Percentage of correct answers",
        legend.text = c("short", "long"), 
        names.arg = c("Subject 1", "Subject 2", "Subject 3", "Subject 4", "Subject 5", "Subject 6", "Subject 7",
                      "Subject 8", "Subject 9") )

## Difference between number of correct answers between conditions
t.test(dat$nr_of_correct_hints, dat$nr_of_correct_no_hints, paired = TRUE, alternative = "two.sided")

## In absolute number of words
hints_nohints <- rbind(nr_of_correct_hints, nr_of_correct_no_hints)
barplot(hints_nohints, ylim = c(0,27), beside = TRUE, col = c("red2", "blue3"), 
        main = "Recall of words studied with hints versus without hints", ylab = "Nr of correct answers",
        legend.text = c("with hints", "without hints"), 
        names.arg = c("Subject 1", "Subject 2", "Subject 3", "Subject 4", "Subject 5", "Subject 6", "Subject 7",
                      "Subject 8", "Subject 9") )

## In a percentage
hints_nohints_percentage <- ((hints_nohints / 4.8) * 10 )
barplot(hints_nohints_percentage, ylim = c(0,54), beside = TRUE, col = c("red2", "blue3"), 
        main = "Recall of words studied with hints versus without hints", ylab = "Percentage of correct answers",
        legend.text = c("with hints", "without hints"), 
        names.arg = c("Subject 1", "Subject 2", "Subject 3", "Subject 4", "Subject 5", "Subject 6", "Subject 7",
                      "Subject 8", "Subject 9") )


## Difference between number of trials between conditions
t.test(dat$nr_of_trials_hints, dat$nr_of_trials_no_hints, paired = TRUE, alternative = "two.sided")

trials_hints_nohints <- rbind(nr_of_trials_hints, nr_of_trials_no_hints)
barplot(trials_hints_nohints, ylim = c(0,170), beside = TRUE, col = c("magenta3", "orange2"), 
        main = "Number of study-trials with hints versus without hints", ylab = "Nr of trials",
        legend.text = c("with hints", "without hints"), 
        names.arg = c("Subject 1", "Subject 2", "Subject 3", "Subject 4", "Subject 5", "Subject 6", "Subject 7",
                      "Subject 8", "Subject 9") )

## Difference between number of unique words seen between conditions
t.test(dat$nr_of_unique_words_hints, dat$nr_of_unique_words_no_hints, paired = TRUE, alternative = "two.sided")

words_hints_nohints <- rbind(nr_of_unique_words_hints, nr_of_unique_words_no_hints)
barplot(words_hints_nohints, ylim = c(0,35), beside = TRUE, col = c("deepskyblue1", "chartreuse2"), 
        main = "Number of unique words studied with hints versus without hints", ylab = "Nr of unique words",
        legend.text = c("with hints", "without hints"), 
        names.arg = c("Subject 1", "Subject 2", "Subject 3", "Subject 4", "Subject 5", "Subject 6", "Subject 7",
                      "Subject 8", "Subject 9") )

## Difference between ratio of (words correct)/(words seen) per condition
t.test(ratio_correct_vs_seen_hints, ratio_correct_vs_seen_no_hints, paired = TRUE, alternative = "two.sided")

ratio_hints_nohints <- rbind(ratio_correct_vs_seen_hints, ratio_correct_vs_seen_no_hints)
barplot(ratio_hints_nohints, ylim = c(0,1.1), beside = TRUE, col = c( "mediumaquamarine", "tomato2"), 
        main = "Ratio of correct words / seen words", ylab = "Ratio correct / seen",
        legend.text = c("studied with hints", "studied without hints"), 
        names.arg = c("Subject 1", "Subject 2", "Subject 3", "Subject 4", "Subject 5", "Subject 6", "Subject 7",
                      "Subject 8", "Subject 9") )
