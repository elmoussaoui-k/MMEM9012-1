# Define functions
def is_seq_valid(seq):
    valid_bases = ['A', 'T', 'G', 'C']
    for base in seq:
        if base not in valid_bases:
            return False
    return True

def reverse(seq):
    return seq[::-1]

def complement(seq):
    complement_dict = {'A': 'T', 'C': 'G', 'T': 'A', 'G': 'C'}
    seq_list = list(seq)
    seq_list = [complement_dict[base] for base in seq_list]
    return ''.join(seq_list)

def reverse_complement(seq):
    seq = reverse(seq)
    seq = complement(seq)
    return seq

# Main function
def main():
    print("\n")
    print('********************** Reverse Complement Program **********************')
    sequence = input("Please enter an oligonucleotide sequence : ").upper()
    print('************************************************************************')
    print('')
    if (is_seq_valid(sequence)):
        print('Reverse complement sequence: ' + reverse_complement(sequence))
    print('________________________________________________________________________')

main()

