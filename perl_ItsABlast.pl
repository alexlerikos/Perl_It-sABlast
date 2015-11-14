#!/pkg/bin/perl -w
# Program perl_ItsABlast.pl


#Set up file i/o
$/ = ""; #set to paragraph mode

# file to handle the input query
$input_query_file = "q_test_string.txt";

# file to handle the input data used to build our associative arrays
$input_data_file = "perlblastdatas.txt";

open(QUERY, "$input_query_file");
open(DATA_IN,"$input_data_file");

#read in input_query string to query variable
$query = <QUERY>;
chomp $query;
@queryArray = split //, $query; # save duplicate string for comparison use after query
					 # is parsed into the kmer hash


#set up k-mer length
$k = 4;

%kmer = ();                      # This initializes the hash called kmer.
#set up variable for indexing kmer array
#we use a zero index because THIS IS AMERICA!! (*queue explosions and bald eagles)
$i = 0;
# read in $query and set up kmer hash
while (length($query) >= $k) {
  $query =~ m/(.{$k})/; 
  # print "$1, $i \n";
   if (! defined $kmer{$1}) {   # here we tell Perl that the value of a kmer entry will
                         		# be an array. This is done by enclosing $i with [ ].
                         		# More correctly, $kmer{$1} is a reference to an array
                         		# whose first value is the value of $i.
    $kmer{$1} = [$i];       
   }
   else {
   	push (@{$kmer{$1}}, $i);
   }
   $i++;
   $query = substr($query, 1, length($query) -1);
}

%stringHash = (); #hash table to hold matching strings to reduce errors

# read data input file line by line to build kmer array
while($line = <DATA_IN>){
	@dataBaseLineArray = split //, $line;
	$i = 0;
	while (length($line) >= $k) {
		$line =~ m/(.{$k})/; 
	  	# print "$1, $i \n";
	   	if (defined $kmer{$1}) {
	   		foreach $querylocation (@{$kmer{$1}}){
	   			# print "query location: $querylocation\n";
	   		      
		    	$L  = 0; #store length of query and database matching chars
		    	$j = 0;

		    	#check charactures to right of starting index of matching kmer for matches
		    	while ($queryArray[$querylocation+$j] eq $dataBaseLineArray[$i+$j]){
		    		# print "$j\n";
		    		$j++;
		    		$L++;
		    	}
		    	$subEnd = $i+$j-1;
		    	$j = 1;

		    	#check charatures to the left of the matching kmer starting index for match
		    	while ($queryArray[$querylocation-$j] eq $dataBaseLineArray[$i-$j]){
		    		# print "$j\n";
		    		$j++;
		    		$L++;
		    	}
		    	$subStart = $i-$j+1;
		    	#create string of all matching chars 
		    	$matchString = join('',@dataBaseLineArray[$subStart..$subEnd]);
		    	# print("Matching string: $matchString\n");

		    	if (!defined $stringHash{$subStart}){
		    		$stringHash{$subStart} = $matchString;
		    		print("Matching string: '$matchString' with length $L\n");
		    		if ($L > 10){
		    			print "Good HSP has been found\n";
		    		}
		    	}
		    }
	   	}
		$i++;
	 	$line = substr($line, 1, length($line) -1);
	}
}
# Uncomment below to view all kmer locations in the query string
# foreach $kmerkey (keys(%kmer)) {
#  $occrs = join(', ' , @{$kmer{$kmerkey}});
#  print "The occurrences of string $kmerkey are in positions $occrs \n";
# }
