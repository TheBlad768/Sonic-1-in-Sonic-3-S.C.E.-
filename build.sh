#!/bin/bash

# Delete some intermediate assembler output just in case
rm -f S1S3.gen
rm -f S1S3.p
rm -f S1S3.h
rm -f S1S3.log

# Run the assembler:
AS_MSGPATH=Tools/AS/Linux
USEANSI=n

# Allow the user to choose to print error messages out by supplying the -pe parameter
${AS_MSGPATH}/asl @Tools/AS/Linux/asflags Engine/Includes.asm

test -f S1S3.log && cat S1S3.log
if [ ! -f S1S3.p ]; then
    echo "Assembler did not produce S1S3.p"
    exit 1
fi

# Convert the assembled file to binary
${AS_MSGPATH}/p2bin -p=FF -z=0,kosinskiplus,Size_of_DAC_driver_guess,after S1S3.p S1S3.gen S1S3.h

# Delete temporary files
rm -f S1S3.p
rm -f S1S3.h

# Generate debug information
${AS_MSGPATH}/convsym S1S3.lst S1S3.gen -input as_lst -range 0 FFFFFF -exclude -filter \"z[A-Z].+\" -a
${AS_MSGPATH}/convsym S1S3.lst "Engine/_RAM.lst" -in as_lst -out asm -range FF0000 FFFFFF

# Make ROM padding (commented out as in the original)
#${AS_MSGPATH}/rompad S1S3.gen 255 0

# Fix the ROM header
${AS_MSGPATH}/fixheader S1S3.gen

# Copy rom to CD folder
if [ -f "S1S3.gen" ]; then
    cp S1S3.gen _CD/
    if [ $? -ne 0 ]; then
        echo "Failed to copy S1S3.gen"
        exit 1
    fi
fi

if test -f S1S3.gen
then
  exit 0
fi
exit 1
