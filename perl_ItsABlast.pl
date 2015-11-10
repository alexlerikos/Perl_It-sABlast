#!/pkg/bin/perl -w
# Program perl_ItsABlast.pl


#Set up file i/o

# file to handle the input query
$input_query_file = "q_test_string.txt";

# file to handle the input data used to build our associative arrays
$input_data_file = "perlblastdatas.txt";

open(QUERY, "<$input_query_file");
open(DATA_IN,"$input_data_file");
while($line = <QUERY>){
	chomp $line;
	print "line: $line\n";
}


#set up k-mer length
$k = 4;

%kmer = ();                      # This initializes the hash called kmer.
#set up variable for indexing kmer array
#we use zero index because THIS IS AMERICA!! (*queue explosions and bald eagles)
$i = 0;

# read data input file line by line to build kmer array
while($line = <DATA_IN>){

	while (length($line) >= $k) {
		$line =~ m/(.{$k})/; 
	  	# print "$1, $i \n";
	   	if (! defined $kmer{$1}) {     #defined is a function that returns true
	                                  # if a value has already been assigned to
	                                  # $kmer{$1}, otherwise it returns false. 
	                                  # the ! character is the negation, so
	                                  # if $kmer{$1} has no value, then it will
	                                  # be assigned the value of $i, the position
	                                  # where the k-mer is first found.
	    	$kmer{$1} = $i;       
	   }
		$i++;
	 	$line = substr($line, 1, length($line) -1);
	}
}

# foreach $kmerkey (keys(%kmer)) {
#  print "The first occurrence of string $kmerkey is in position 
#  $kmer{$kmerkey}\n";
# }


