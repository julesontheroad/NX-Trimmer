# NX-Trimmer v0.4
https://github.com/julesontheroad/NX-Trimmer  So for whoever that didn't realized it yet:
- For building xci files without the need of a ticket use: https://github.com/julesontheroad/NUT_BATCH_CLEANER/releases/tag/v0.41
- For the trimmer and things without tickets for now use https://github.com/julesontheroad/NUT_BATCH_CLEANER/releases

Made by JulesOnTheRoad and first released in elotrolado.net

---------------
0. Changelog
---------------
v0.4   - Cleaned echos giving better input to the user about the process.
         Added compatibility with XCI_BatchBuilder.
         Erased auto-exit at the end of program so it can be used by command line if you want.
         Made a couple of fixes in the code.
	 
v0.3.1.REV2 - Changed ztools folder to erase sfk.exe as it wasn't needed. Added Bigjokker build of hacbuild so it eliminate the warning about not having a header_key.txt in hacbuild as it wasn't needed.
Returned to previous build of hactool used since the prebuild one from SciresM seemed to give issues to some users with 32bit systems.

v0.3.1 - Added options in batch header. Edit with notepad++ to select them

   I - "preservemanual" By default 0. Set at 1 if you want the manual nca to not be deleted. If set at 1 the manual will be sent to output folder.
  NOTE1: Is advised to ¡¡NOT INSTALLED the manual .nca!! as the game will give error if you try to access the game manual.
	NOTE2: The xci without manual is completely functional and if manual is selected it won't happened anything. 
	NOTE3: This option is thought for a future xci to nsp converter that will revert the process.
  
   II - "delete_brack_tags" Erase [] tags like [trimmed]- By default at 1
   
  III - "delete_pa_tags" Erase tags () like (USA) - By default at 0. If activated it could also erase [] tags
  
v0.3.0 - Lot of changes made to first version:
   I - Added compatibility with games with more than 5 nca. This accomplished by using the following approach. 
       a) Games with html manual (5 nca). The manual was stripped from the game, this doesn't impede game execution. And game is fully functional.
	  If you try to access the manual in these kind of games this action won't get any result and you will be able to keep playing.
	  Games are fully funtional without manual nca and there are few games that includes it to begin with.
       b) Games "rev" (revision) that includes updates or even dlcs (Sonic Mania). For this games was decided to strip the updates and dlc files
	  from the xci.
	  Additionally nsp files are created with the updates and dlcs files that were stripped from the xci. 
	  For this you'll need to have Python installed in the computer.
    
   II - Output route was moved to "output_nxt" so everything is better organiced and NX-Trimmer can be in the same folder as XCI_Builder, which now uses el usará "output_xcib" as output folder.
   
   III - Reformed ztools folder, erasing not needed files. 
   
   IV - Little mod to hacbuild.exe so it takes "xci_header_key" from ztools. "xci_header_key" it's actually not needed everything works without it but hacbuild gives a warning wich was ugly for the batch output
   
   V  - Added template for keys.txt and header_key.txt in ztools
   
   VI - Added tag system for the files output. It goes as follows:
     [nxt] xci trimmed with n NX-Trimmer
	   [nm] "no manual", manual was erased to get the resulting xci to work
	   [c1][c2]... In output nsp: order of the content in the original xci. (updates, dlcs ...)
	   [dlc] In output nsp means the content is a dlc.
	   [upd] In output nsp means the content is an update.
	The output dlc files are ticketless, should be encrypted with cartridge key and only functional with SX OS. To make them       functional in other CFW a false ticket should be needed as 4NXCI does but this defies this program purpose and my current goal.
	The updates use common tickets signed by Nintendo, so they should be functional in every CFW.
  
  VII - The "normal" partition content is now erased as it's thought in case the format of the "meta" or/and or "control" nca changes and no current cartridge really uses it right now. It can serve a purpose in new cartridge type revisions.
Nowadays the nca files in normal are the same as in "secure" so this partition is not necessary	and is empty in card 2 types. 

 VIII - Better use of hactool only extracting the secure partition.

NOTE: If upgrading from previous version replace ztools folder. hactool version was upgraded and an small modification was made in hacbuild code.

v0.1.0 - First launch in elotrolado.net

v0.2.x - Development versions


---------------
1. Description
---------------

This tool is meant to clean the update partition from xci files and to reduce the padding used between partitions.
This is a batch application which serves to automate the workflow between the following programs:

a.) hacbuild: Program meant to create xci files from nca files, made by LucaFraga.

https://github.com/LucaFraga/hacbuild

b.) hactool: Program which function is give information, decrypt and extract a lot of different kind of files us by the NX System.
Hactool was made by SciresM

https://github.com/SciresM/hactool

c.) nspBuild: Program meant to create nsp files from nca files. 
nspBuild was made by CVFireDragon

https://github.com/CVFireDragon/nspBuild

NX-Trimmer was also inspired by "A Simple XCI, NCA, NSP Extracting Batch file (Just Drag and Drop) with Titlekey decrypt"
by Bigjokker and published in gbatemp:

https://gbatemp.net/threads/a-simple-xci-nca-nsp-extracting-batch-file-just-drag-and-drop-with-titlekey-decrypt.513300/

---------------
2. Requirements
---------------

- A computer with a Window's OS is needed
- You'll need to complete keys.txt in ztools with the keys needed by hactool.
- Optionally complete header_key.txt with xci_header_key
- You'll need to have Python installed for nspbuild to work correctly
- You'll need to have at least .net frameworks 4.5.2 installed so hacbuild can work correctly.

---------------
3. Functions
---------------

- Padding reduction, partition cleaning for "update" and "normal" removal of logo partition (not needed).
- All cartridges are built as "card1"
- Stripping of updates and dlcs from rev cartridges.
- Removal of manual nca from cartridges that incudes it (very few of them) without loosing cartridge funcion.
- "game_info" files extraction.

---------------
4. Limitations
---------------

- xci files only work with SX OS
- Currently hacbuild can only build files with 4nca files in the secure partition. 
  Now that XCI_Builder and NX-Trimmer are fully update this issue will be investigated. It seems to ne tied to some parameter in the cartrige header
  which is undocumented and points to the number of files in the secure partition. Probably was assumed as a fixed value as most of the cartridges 
  only use program, control, meta and legal nca files which makes 4 nca files.
- It's necessary to remove the manual nca to get the games that incorporate it to work after the rebuild
- For rev games is necessary to extract updates and dlc files in nsp files.
- Currently the program doesn't identify the version for the updates
  (Not sure if you can do it with hactool without extracting the nca files)
- Processing times for more than 4gb games is longer than it shoul be proporcionallu. Probably linked to hacbuild fix number 5 regarding the overflow
  error in this kind of files. (Could be interesting to investigate if a fastest processing approach is possible)
- The symbol "!" gives error when passed to hacbuild. So rename snipperclips file

-------------------------
5. Use of the application
-------------------------

I.-   First fill "keys.txt" in ztools folder so hactool can work properly.
      More info: https://github.com/SciresM/hactool
      
II.-  Optionally fill the file header_key.txt in ztools with xci_header_key value

III.- To trim an xci dragg it over "NX-Trimmer_v0.31" and wait till the cmd windows closes itself. You should see a thumps up ;)

IV.-  You'll get a folder with the name of the file in output_nxt. Inside it'll be the trimmed file.

V.-   In case the cartridge incorporate the updates or dlcs they will be included in the same output folder

V.-   Aditionally the game_info.ini file will be placed in the folder "game_info"

VI.-  Load the xci in OS.

VII.- Optionally install the updates or dlcs generated by the program.

------------------
6. Compatibility
------------------

With current changes and accepting the described limitations this method should be compatible with all current xci files.
At least I didn't find any issues.

------------------------
7. Thanks and credits to 
------------------------

LucaFraga, SciresM and CVFireDragon 
Also thanks to all members from gbatemp and elotrolado.net


