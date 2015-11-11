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
print "query: $query\n";
print "queryArray:\n"; 
print "@queryArray\n";
# print "tempquery: $querytemp\n";


#set up k-mer length
$k = 4;

%kmer = ();                      # This initializes the hash called kmer.
#set up variable for indexing kmer array
#we use zero index because THIS IS AMERICA!! (*queue explosions and bald eagles)
$i = 0;
# read in $query and set up kmer hash
while (length($query) >= $k) {
  $query =~ m/(.{$k})/; 
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
   $query = substr($query, 1, length($query) -1);
}

%stringHash = (); #hash table to hold matching strings to reduce errors

# read data input file line by line to build kmer array
while($line = <DATA_IN>){
	print "line: $line\n\n";
	@dataBaseLineArray = split //, $line;
	# print "@dataBaseLineArray\n";
	$i = 0;
	while (length($line) >= $k) {
		$line =~ m/(.{$k})/; 
	  	# print "$1, $i \n";
	   	if (defined $kmer{$1}) {      
	    	$L  = 0; #store length of query and database matching charatures
	    	$j = 0;

	    	#check charactures to right of starting index of matching kmer for matches
	    	while ($queryArray[$kmer{$1}+$j] eq $dataBaseLineArray[$i+$j]){
	    		# print "$j\n";
	    		$j++;
	    		$L++;
	    	}
	    	$subEnd = $i+$j-1;
	    	$j = 1;

	    	#check charatures to the left of the matching kmer starting index for match
	    	while ($queryArray[$kmer{$1}-$j] eq $dataBaseLineArray[$i-$j]){
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
	    		print("Matching string: $matchString\n");
	    		if ($L > 10){
	    			print "Good HSP has been found\n";
	    		}
	    		print "Match Length = $L\n";
	    	}
	   	}
		$i++;
	 	$line = substr($line, 1, length($line) -1);
	}
}
