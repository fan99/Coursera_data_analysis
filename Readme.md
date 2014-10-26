How the script works:

It reads all the files containing information about the X or the Y set using the read.table command.

Then, it merges all the tables with cbind or rbind.

In order to select those columns contaning the word 'mean' or 'std' on their label variable, we used the grep command.

On the selected names, we removed the underscore and the parenthesis with the command gsub.

On the other side, the tidy dataset is constructed in two steps. First, using aggregate we construct a table with the mean of each activity 
with the aggregate command. To perform this, we need to factorize the activities. This process is repeated for the subjects.
To finish, we merge the two resulgint tables with rbind.

With write.table, we obtain the output table.