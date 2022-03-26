# Import external resources
import datetime
import random

# Hardcode the deleted samples & max (= index of the last element of the list)
deleted_samples = ["KE001","KE002", "KE003", "KE011", "KE012", "KE020", "KE027", "KE041", "KE042","KE050", "KE051","KE052", "KE053",
        "KE055", "KE056", "KE057", "KE058", "KE061", "KE073", "KE077"]
max = 81

# Function that builds a list of samples
def get_sample_list():
    # Creates an empty accumulator to store further information
    tot = []
    # For samples from 1 to 9...
    for sample in range(1, 10):
        # Prefix for those samples is "KE00"
        prefix_ten = "KE00"
        # Add every one of these samples in the empty accumulator "tot"
        tot.append(prefix_ten + str(sample))
    # For samples from 10 to 81...
    for sample in range(10, max+1):
        # Prefix for those samples is "KE0"
        prefix_hundred = "KE0"
        # Add every one of these samples in the "tot" accumulator
        tot.append(prefix_hundred + str(sample))
    # If an element of the tot accumulator is not present in the deleted_samples list, add it to the "samples" list
    samples = [x for x in tot if x not in deleted_samples]
    # Return the previously computed list
    return samples

# Defines the main function
def main():
    d = str(datetime.datetime.now())
    print("")
    # Display the name of the program
    print('******************** RANDOM SELECTION OF SAMPLES ********************')

    # Asks the user to input the number of samples desired
    n = input("How many samples would you like to select ? Enter an number between 1 and " + str(max) + " : ")
    print('*********************************************************************')
    # Creates an empty accumulator
    selection = []
    # As long as there are fewer samples in the "selection" list than the number of samples desired...
    while len(selection) < int(n):
        # Continue to randomly select samples from those present in the "samples" list
        req = random.SystemRandom().choices(get_sample_list(), k=1)
        # If the randomly selected sample is not present in the "selection" list
        if req not in selection:
            # Add it to the "selection" list
            selection.append(req)
    # Display the selection
    print("Here are the selected samples : " + str(selection))
    print('*********************************************************************')
    save_choice = input("Would you like to save this selection into a .txt file ? (Enter Y or N) : ")
    print('*********************************************************************')
    if (save_choice == "Y"):
        output_path = input("Enter the destination folder of the .txt file : ")
        print('*********************************************************************')
        output_file_path = f"{output_path}/random_selection" + " (" + d[0:10] + ").txt"
        output_file = open(output_file_path, "w")
        output_file.write("SELECTION PERFORMED ON : " + str(datetime.datetime.now()) + "\n" + "___________________________________________________" + "\n\n\n" + "SELECTED SAMPLES :" + "\n\n" + str(selection).replace("[", "").replace("]", "").replace("'", ""))
    else:
        print("")
        print("Thanks for using this utility!")

# Executes the main function
main()