Perl_It-sABlast
=====================

This is a toy commandline [BLAST](http://blast.ncbi.nlm.nih.gov/Blast.cgi) (Basic Local Alignment Search Tool) written in PERL. 
It uses 1 query string and 1 database string to find all high scoring string matches between the query string and the database string. 
The program uses the k-value (`line 25: perl_ItsABlast.pl`) to set the length of the substrings matched between the database string and the query string.

##How to Use

1. Download repository contents

2. Open up the `perl_ItsABlast.pl` file in your text editor of choice

3. Modify lines 9 and 12 to refer to the files you are using to hold your database and query strings

5. Run using `perl perl_ItsABlast.pl` and to display the number of high scoring match pairs between the strings and the length of their similar sequence.
