## Difference between number of correct answers for short words between hint vs no hint conditions
mean(nr_of_correct_hints_short)
mean(nr_of_correct_no_hints_short)

t.test(dat$nr_of_correct_hints_short, dat$nr_of_correct_no_hints_short, paired = TRUE, alternative = "two.sided")

## In absolute number of words
hints_nohints_short <- rbind(nr_of_correct_hints_short, nr_of_correct_no_hints_short)
barplot(hints_nohints_short, ylim = c(0,27), beside = TRUE, col = c( "mediumaquamarine", "tomato2"), 
        main = "Recall of SHORT words studied with hints versus without hints", ylab = "Nr of correct answers",
        legend.text = c("with hints", "without hints"), 
        names.arg = c("Subject 1", "Subject 2", "Subject 3", "Subject 4", "Subject 5", "Subject 6", "Subject 7",
                      "Subject 8", "Subject 9") )

## Difference between number of correct answers for long words between hint vs no hint conditions
mean(nr_of_correct_hints_long)
mean(nr_of_correct_no_hints_long)

t.test(dat$nr_of_correct_hints_long, dat$nr_of_correct_no_hints_long, paired = TRUE, alternative = "two.sided")

## In absolute number of words
hints_nohints_long <- rbind(nr_of_correct_hints_long, nr_of_correct_no_hints_shortlong)
barplot(hints_nohints_long, ylim = c(0,27), beside = TRUE, col = c( "mediumaquamarine", "tomato2"), 
        main = "Recall of LONG words studied with hints versus without hints", ylab = "Nr of correct answers",
        legend.text = c("with hints", "without hints"), 
        names.arg = c("Subject 1", "Subject 2", "Subject 3", "Subject 4", "Subject 5", "Subject 6", "Subject 7",
                      "Subject 8", "Subject 9") )