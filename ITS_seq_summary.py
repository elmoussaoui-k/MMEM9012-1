# Import external resources
import os
import datetime

# Creates dictionary that returns the corresponding GLIMS number for a given sample ID
def id_to_glims(id):
    conv_dict = {
        'KE001': '13-150520-0009',
        'KE002': '13-161208-0065',
        'KE003': '13-170109-0029',
        'KE004': '13-170221-0030',
        'KE005': '13-170314-0069',
        'KE006': '13-170607-0016',
        'KE007': '13-170626-0018',
        'KE008': '13-170710-0034',
        'KE009': '13-171026-0006',
        'KE010': '13-171026-0009',
        'KE011': '13-171026-0011',
        'KE012': '13-171227-0054',
        'KE013': '13-171228-0003',
        'KE014': '13-180209-0032',
        'KE015': '13-180507-0017',
        'KE016': '13-180604-0007',
        'KE017': '13-180817-0102',
        'KE018': '13-180925-0065',
        'KE019': '13-181008-0004',
        'KE020': '13-190213-0003',
        'KE021': '13-190220-0076',
        'KE022': '13-190129-0017',
        'KE023': '13-190226-0091',
        'KE024': '13-190315-0029',
        'KE025': '13-190228-0018',
        'KE026': '13-190326-0052',
        'KE027': '13-190408-0011',
        'KE028': '13-190419-0055',
        'KE029': '13-190523-0057',
        'KE030': '13-190808-0073',
        'KE031': '13-190919-0037',
        'KE032': '13-191127-0046',
        'KE033': '13-191212-0072',
        'KE034': '13-191224-0067',
        'KE035': '13-191217-0023',
        'KE036': '13-200219-0080',
        'KE037': '13-200318-0095',
        'KE038': '13-200529-0132',
        'KE039': '13-200803-0093',
        'KE040': '13-200707-0114',
        'KE041': '13-200714-0262',
        'KE042': '13-200824-0063',
        'KE043': '13-201029-0245',
        'KE044': '13-201105-0172',
        'KE045': '13-201125-0228',
        'KE046': '13-201119-0244',
        'KE047': '13-201125-0225',
        'KE048': '13-201210-0193',
        'KE049': '13-210115-0033',
        'KE050': '13-210203-0060',
        'KE051': '13-210323-0050',
        'KE052': '13-210312-0203',
        'KE053': '13-210331-0040',
        'KE054': '13-210420-0192',
        'KE056': '13-210617-0087',
        'KE057': '13-210720-0013',
        'KE058': '13-210929-0015',
        'KE059': '13-180730-0023',
        'KE060': '13-180814-0029',
        'KE061': '13-180925-0010',
        'KE062': '13-180925-0031',
        'KE063': 'IHEM n°28378',
        'KE064': 'IHEM n°28379',
        'KE065': 'IHEM n°28380',
        'KE066': 'IHEM n°28382',
        'KE067': 'IHEM n°28384',
        'KE068': 'IHEM n°28388',
        'KE069': '13-210408-0015',
        'KE070': '13-210507-0223',
        'KE071': '13-211201-0059',
        'KE072': '13-220207-0001',
        'KE073': '13-220207-0004',
        'KE074': '13-220207-0003',
        'KE075': '13-220207-0005',
        'KE076': '13-220112-0028',
        'KE077': '13-220112-0125',
        'KE078': '13-220112-0126',
        'KE079': '13-220218-0018',
        'KE080': '13-220218-0019',
        'KE081': '13-220214-0070',
    }
    return conv_dict.get(id)

# Defines the main function
def main():
    print("\n")
    # Display the name of the program
    print('*************** ITS SEQUENCING : GENERATE RESULTS SUMMARY ***************')
    print("")

    # Asks the user to input the path to the folder containing the extracted sequences files
    input_path = input("Enter the path of the folder that contains the extracted sequences files : ")

    # Asks the user to input the path to the summary folder
    output_path = input("Enter the path of the summary folder : ")
    print("")
    print('*************************************************************************')

    # Builds a path for the output .txt file
    output_file_path = f"{output_path}/ITS_seq_summary.txt"
    # Creates the output file in append mode
    output_file = open(output_file_path, "w")
    # Writes the header information into the output file
    output_file.write("ITS SEQUENCING SUMMARY (" + str(datetime.datetime.now()) + ")" + "\n" + "___________________________________________________" + "\n\n\n" + "SAMPLE         GLIMS                   IDENTIFICATION (BY ITS SEQUENCING)        " + "\n\n")

    # Creates 2 empty accumulators to store further information
    ID = []
    RESULTS = []

    # List all files contained in the source folder
    for file in os.listdir(input_path):
        # Consider only files whose extension is .txt
        if file.endswith(".txt"):
            # Builds a path for each of these files
            input_file_path = f"{input_path}/{file}"
            # Opens these files in reading mode
            raw_f = open(input_file_path, "r")
            # For each line contained in these files...
            for line in raw_f.readlines():
                # Consider only the lines who start with "> SAMPLE ID"
                if line.startswith("> SAMPLE ID"):
                    # If the line meets this criteria, then it should be added to the ID accumulator after removing prefix & sufix
                    ID.append(line.removeprefix("> SAMPLE ID = ").removesuffix("\n"))
                # Consider only the lines who start with "> IDENTIFICATION"
                if line.startswith("> IDENTIFICATION"):
                    # If the line meets this criteria, then it should be added to the RESULTS accumulator after removing prefix & sufix
                    RESULTS.append(line.removeprefix("> IDENTIFICATION RESULT = ").removesuffix("\n"))
    # For each element contained in the ID accumulator...
    for i in range(0,len(ID)):
        # Select the corresponding information in the RESULTS accumulator (based on index) and write that in the output file
        output_file.write(ID[i] + "          " + id_to_glims(ID[i]) + "          " + RESULTS[i] + "\n")

# Executes the main function
main()