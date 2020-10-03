from __future__ import division
import math
import pandas as pd
import numpy
import random
import csv
from collections import namedtuple

Fact = namedtuple("Fact", "fact_id, question, answer, easy_or_hard")

def generate_hint(word):
    length_word_min1 = len(word) - 1
    random_index = random.randint(1,length_word_min1)
    hint = word[0] + ("_" * (random_index - 1)) + word[random_index] + ("_" * (length_word_min1 - random_index))
    return hint

easy_facts = []
hard_facts = []

fact_id = 0

# Read in easy facts from file
with open('wordlist_easy.txt') as wordlist_easy:
	reader = csv.reader(wordlist_easy, delimiter=',')
	for row in reader:
		fact_id = fact_id + 1
		easy_facts.append(Fact(fact_id, row[0], (row[1])[1:], "easy"))


# Read in hard facts from file
with open('wordlist_hard.txt') as wordlist_hard:
	reader = csv.reader(wordlist_hard, delimiter=',')
	for row in reader:
		fact_id = fact_id + 1
		hard_facts.append(Fact(fact_id, row[0], (row[1])[1:], "hard"))

### This is how the fact-lists in the experiment were generated
# print(easy_facts)
# print(hard_facts)

# make two arrays of easy facts, each containing one half of the easy facts
random.shuffle(easy_facts)
easy_facts_1 = easy_facts[0:int(len(easy_facts) / 2)]
easy_facts_2 = easy_facts[int(len(easy_facts) / 2 ):]

# make two arrays of hard facts, each containing one half of the hard facts
random.shuffle(hard_facts)
hard_facts_1 = hard_facts[0:int(len(hard_facts) / 2)]
hard_facts_2 = hard_facts[int(len(hard_facts) / 2 ):]

### Testing
# print(generate_hint("happy"))
# print(generate_hint("happy"))
# print(generate_hint("happy"))
# print(len(easy_facts_1))
# print(len(easy_facts_2))
