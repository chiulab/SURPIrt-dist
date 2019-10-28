## SURPIrt version 0.7.28

#### Hardware & Software Requirements

	• Linux server, tested Ubuntu 16.04 with 512 GB memory, 18 TB shared disk volume

#### Additional Software Dependencies
	• Python interpreter, tested Python v2.7.12
	• Perl interpreter, tested Perl v5.22.1


#### Required Scripts
	Linux shell scripts
		• blast_ncores.sh [OBFUSCATED]
		• extractAlltoFast.sh [OBFUSCATED]
		• FastaToTab.csh [OBFUSCATED]
		• filterOverlapSAM.sh [OBFUSCATED] 
		• split_barcodes.sh [OBFUSCATED]
		• SURPIrt.sh [OBFUSCATED]
		• SURPIrt_viz.sh [OBFUSCATED]
		• TabToFasta.csh [OBFUSCTED]
		• taxonomy_annotation.sh [OBFUSCATED]

	Python scripts
		• classify_annotated.py [BINARIZED]
		• mask_primers.py [BINARIZED]
		• parse_overlapping.py [BINARIZED]
		• trim_primers.py [BINARIZED]

	Perl scripts
		• fasta_to_fastq.pl
		• subtractBlastFromFasta.pl

	C/C++ executables
		• fqextract_5m

#### Instructions for Installing and Running the SURPIrt Software

1. The reference databases used by SURPIrt for identification of human, bacterial, fungal, and parasitic reads and for taxonomy lookup are not provided in the Github distribution.  They will need to be regenerated as follows:

	• The reference headers for the fasta reference database are provided in the `/reference_headers` subdirectory. Note that the reference headers can be in either gi or accession number format and also may include extraneous descriptive text. Use the reference headers to reconstruct the individual fasta files and place them in the directory structure as described in the README file.
	
	• The subdirectory `/taxonomy_files` contains the file CSV-formatted file `lineages-2019-01-20.csv`.  Instructions for generating the 2nd taxonomy file `nucl_all_sorted_LCall.txt` are provided in the README file. These files will need to be placed in the $taxonomy_folder (default `/reference/surpirt/taxonomy`).

2. Once the human/microbial reference and taxonomy lookup databases have been generated and placed in their appropriate directories, the pipeline can be run using the `SURPIrt.sh` script with the following command-line switches:

```
SURPIrt version 0.7.28

This program will run the SURPIrt pipeline.

Command Line Switches:

	-h	Show this help & ignore all other switches

	-r	Specify reference folder [optional - default: "/reference/surpirt"]

	-f 	Specify input FASTQ [required]

	-v	Execute pipeline in virus-only mode

		This is implemented for speed, if only looking for viruses.

	-w	Create files necessary for SURPIviz

	-x	Execute pipeline in verification-only mode.

		This mode will verify all database locations, but not execute the pipeline.

	-t	Specify number of threads to use [optional - will be set to number of cores if unspecified]

	-c	Specify config file [optional]

		This switch is used to initiate a SURPIrt run using a specified config file. Any parameters 
		in the config file will supersede default parameters within the pipeline.
		
		When using a config file, it is best to avoid using other command-line parameters. Instead, all
		parameters should be included with the config file.

	-z	Create default config file. [optional] (specify fastq filename)
		This option will create a standard .config file, and go file.
```

#### Test Run
1. A sample test file named `ZIKV-nohuman.fastq` is provided, is a metagenomic run of a ZIKV clinical sample with the human reads removed [n=517 sequences].

2. Using default reference directory of `/reference/surpi`, run the `SURPIrt.sh` script from the command line with the following parameters (using 8 threads/cores):

  `SURPIrt.sh -f "ZIKV-nohuman.fastq" -t 8`
