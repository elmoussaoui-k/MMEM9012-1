# Display the name of the program
print("")
print('******************** DATA INTEGRITY CHECKER ********************')
# Asks the user for the path to the file containing the original hashes :
or_path = input("Please enter the path to original_md5.txt : ")
# Asks the user for the path to the file containing the recomputed hashes :
re_path = input("Please enter the path to recomputed_md5.txt : ")
print('----------------------------------------------------------------')
# Opens the file containing the original hashes (received with the files from the GIGA genomics platform)
original = open(or_path,"r").readlines()
# Creates an empty dictionary that will store the keys & values that have been read from the previously opened file
original_hashes_dict = {}
# For every line in the "original hashes" file...
for line in original:
    # Hash corresponds to index 0 to 32 of the line
    or_hash = line[0:32]
    # Filename corresponds to index 34 to 78 of the line
    or_filename = line[34:78]
    # Update the previously created dictionary with those 2 information in the format key : value
    original_hashes_dict.update({or_filename:or_hash})
# Opens the file containing the recomputed hashes (recalculated using md5 function within a terminal window)
recomputed = open(re_path,"r").readlines()
# Creates an empty dictionary that will store the keys & values that have been read from the previously opened file
recomputed_hashes_dict = {}
# For every line in the "recomputed hashes" file...
for line in recomputed:
    # Find the index of the pattern 'KE0' => store as start index for filename
    filename_start_index = line.index("KE0")
    # Find the index of the pattern '.' => store as end index for filename
    filename_end_index = line.index(".")
    # Find the index of the pattern '=' => store as start index for hash
    hash_start_index = line.index("=")
    # Add 2 to hash start index
    hash_start_index = int(hash_start_index) +2
    # Extracts hash based on previously determined indexes
    re_filename = line[filename_start_index:filename_end_index]
    # Extracts filename based on previously determined indexes (-1 = index of last character)
    re_hash = line[hash_start_index:-1]
    # Update the previously created dictionary with those 2 information in the format key : value
    recomputed_hashes_dict.update({re_filename:re_hash})

# If the 2 dictionaries are not exactly the same, print a warning message
if recomputed_hashes_dict != original_hashes_dict:
    print("")
    print("Warning : one or more hashes do not match. Please check the integrity of the data and proceed with a new download if necessary.")
# If they are perfect copies of each other, display another message
else:
    print("")
    print("It's ok : the integrity of the data has been checked. All hashes match.")
    print("")
