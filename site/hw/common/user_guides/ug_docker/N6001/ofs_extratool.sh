#Copyright (c) 2022 Intel Corporation
#!/bin/bash
############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Extra functionality for Intel OFS."
   echo
   echo "Syntax: "
   echo "options:"
   echo "s     define a integer number with the SEED value "
   echo "s     set_global_assignment -name SEED NEWVALUE "
   echo "h     Print this Help."
   echo "e     export the output files and log     "
   echo ""
}

############################################################
############################################################
# Main program                                             #
############################################################
############################################################

# Set variables
SEED=101
# main case selection

# Get the options
while getopts ":hentpls:" option; do
   case "${option}" in
      h) # display Help
        Help
        exit ;;
      n) # export no_proxy=
         VALTEXT=${OPTARG}
         echo $VALTEXT
         echo 'export no_proxy='"$VALTEXT"
         sed -i 's/^export no_proxy=.*/export no_proxy='"$VALTEXT"'/' ~/.bash_IOFS
         exit ;;

      t) # export http_proxy=
         VALTEXT=${OPTARG}
         echo 'export https_proxy='"$VALTEXT"'/'
         sed -i 's/^export https_proxy=.*/export https_proxy='"$VALTEXT"'/' ~/.bash_IOFS
         exit ;;

      l) # export LM_LICENSE_FILE=
         VALTEXT=${OPTARG}
         echo 'export LM_LICENSE_FILE='"$VALTEXT"'/'
         sed -i 's/^export LM_LICENSE_FILE=.*/export LM_LICENSE_FILE='"$VALTEXT"'/' ~/.bash_IOFS
         exit ;;

      e) # export the log files and output files
         CID=$(basename $(cat /proc/1/cpuset))
         rm -rf /dataofs/$CID/
         mkdir /dataofs/$CID/
         cp /home/IOFS_BUILD_ROOT/Log_ofs_n6000_eval.log /dataofs/$CID/Log_ofs_n6000_eval.log
         cp -a /home/IOFS_BUILD_ROOT/intel-ofs-fim/work_adp_base_x16/syn/n6000/base_x16/adp/syn_top/output_files/. /dataofs/$CID/
         echo "Files are saved properly"
         exit ;;

      s) # Enter a seed
        SEED=${OPTARG}
        if ! [[ "$SEED" =~ ^[0-9]+$ ]]
            then

             echo "Error: Seed only allows integers only"

            else
             sed -i 's/^set_global_assignment -name SEED .*/set_global_assignment -name SEED '"$SEED"'/' /home/IOFS_BUILD_ROOT/intel-ofs-fim/syn/n$             echo 'Seed was change it to '"$SEED"

        fi
        exit;;
      *) # Invalid option
         echo "Error: Invalid option"
         exit ;;
   esac
done