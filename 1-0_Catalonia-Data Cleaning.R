library(magrittr)
library(data.table)

lines <- readLines("raw/MUNICIPIS-Resultados-del-referendum-del-1-de-octubre.txt")
header_municipis <- gsub("[\t]+$","",lines[1])

pattern <- "(?<=[^0-9-])[\t]+([^0-9-])"

# x <- "El\ti\tPlà\ti\ti\tde,\tSanta,\tMaria\t1.774\t490\t484\t6\t454\t25\t5\t\t"
# x_sub <- gsub(pattern, " \\1", x, perl = T)

example <- "1.34\t2.456\t1.\t1.34\t6.8\t67\t7879\t\7\t"

lines_sub <- gsub('([0-9]+[.][0-9]{1})([^0-9])','\\10\\2', lines)
lines_sub <- gsub('([0-9]+[.][0-9]{2})([^0-9])','\\10\\2', lines_sub)
lines_sub <- gsub('[.\"]', "", lines_sub)
lines_sub <- gsub(pattern, " \\1", lines_sub, perl = T)
lines_sub <- gsub("[\t ]+$", "", lines_sub)
lines_len <- sapply(lines_sub, nchar) %>% unname
lines_min <- lines_len > 3
lines_non_empty <- lines_sub[lines_min]

comarques_detect <- stringr::str_detect(string=lines_non_empty, pattern="MUNICIPIS")

# add comarques
# comarques <- readLines(con <- file("data/COMARQUES.txt", encoding="windows-1252"))[-1] # remove the header
# comarques_delim <- c(which(comarques_detect), length(lines_non_empty))
# reps <- diff(comarques_delim)

# remove Separators
municipis <- lines_non_empty[!comarques_detect]

municipis <- c(header_municipis, municipis)
writeLines(text=municipis, "data/municipis.txt")

municipis_df <- fread("data/municipis.txt", sep="\t", na.strings = "-")
municipis_df[, CensLE := Cens > Votants]
municipis_df[, VotantsOK := Votants==Vàlids+Nuls]
municipis_df[, ValidsOK := Vàlids==Sí+No+Blanc]

## all checks passed

