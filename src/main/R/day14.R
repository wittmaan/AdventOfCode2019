
## --- Day 14: Space Stoichiometry ---

## --- Part one ---

library(data.table)
library(testthat)
library(dplyr)
library(stringr)


sample_input <- "10 ORE => 10 A
1 ORE => 1 B
7 A, 1 B => 1 C
7 A, 1 C => 1 D
7 A, 1 D => 1 E
7 A, 1 E => 1 FUEL"

reactions <- list()
for (line in strsplit(sample_input, "\n") %>% unlist()) {
  matched <- str_match_all(line, "(\\d+) (\\w+)")
  
  print(matched)
}




  


## --- Part two ---



# 5525561

