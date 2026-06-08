#!/bin/bash

# Delete some intermediate assembler output just in case
rm -f S1S3.debug.gen
rm -f S1S3.debug.p
rm -f S1S3.debug.h
rm -f S1S3.debug.log

# Run the assembler:
AS_MSGPATH=Tools/AS/Linux
USEANSI=n

# Allow the user to choose to print error messages out by supplying the -pe parameter
${AS_MSGPATH}/asl @Tools/AS/Linux/asflags_debug Engine/Includes.asm

test -f S1S3.debug.log && cat S1S3.debug.log
if [ ! -f S1S3.debug.p ]; then
    echo "Assembler did not produce S1S3.debug.p"
    exit 1
fi

# Convert the assembled file to binary
${AS_MSGPATH}/p2bin -p=FF S1S3.debug.p S1S3.debug.gen S1S3.debug.h

# Delete temporary files
rm -f S1S3.debug.p
rm -f S1S3.debug.h

# Generate debug information
${AS_MSGPATH}/convsym S1S3.debug.lst S1S3.debug.gen -input as_lst -range 0 FFFFFF -exclude -filter \"z[A-Z].+\" -a
${AS_MSGPATH}/convsym S1S3.debug.lst "Engine/_RAM.debug.lst" -in as_lst -out asm -range FF0000 FFFFFF

# Make ROM padding (commented out as in the original)
#${AS_MSGPATH}/rompad S1S3.debug.gen 255 0

# Fix the ROM header
${AS_MSGPATH}/fixheader S1S3.debug.gen

# Copy rom to CD folder
if [ -f "S1S3.debug.gen" ]; then
    cp S1S3.debug.gen _CD/
    if [ $? -ne 0 ]; then
        echo "Failed to copy S1S3.debug.gen"
        exit 1
    fi
fi

if test -f S1S3.debug.gen
then
  exit 0
fi
exit 1
