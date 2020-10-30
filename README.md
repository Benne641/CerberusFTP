# CerberusFTP
Script to Resolve the known issue with Cerberus FTP and %HOME
- This is a script for resolving the known cerberus issue with %HOME allowing users to have 2 home directories 
- Will add more as issues arise with CerberusFTP

- Setup 
	- You will need to export a backup of Cerberus first
	- Then extract the user names from the .xml that contains your shared files
	- select-string ns1:sharedBy .\<Cerberus backup .xml file> | out-file -filepath .\<outputfile>  can work but you will need to trim away everything not part of the AD name

- Running 
	- check the file paths in the scripts functions and chcange as needed
	- run in order if it is the first time running 
	-  1 & 2 will update your share links
	- 3 & 4 will rename folders and copy files
	

- Questions? email me I might answer maybe.
