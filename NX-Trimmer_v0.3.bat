@echo off
color 03

::NX-Trimmer v0.3 by julesontheroad::
::A batch file made to automate system updates trimming, game updates trimming and padding reduction via hacbuild
::NX-Trimmer serves as a workflow helper for hacbuild, hactool and nspbuild
::Just drag and drop. Drag a xci file into NX-Trimmer .bat and it'll take care of everything



if not exist "%~dp0\ztools\KEYS.txt" echo Falta archivo "KEYS.txt" o "keys.txt!"
echo.
if not exist "%~dp0\ztools\KEYS.txt" pause
if not exist "%~dp0\ztools\KEYS.txt" exit
set file=%~n1
FOR %%i IN ("%file%") DO (
set filename=%%~ni
)
if exist "xciDecrypted" RD /s /q "xciDecrypted"
CD /d "%~dp0"
cls

if "%~x1"==".xci" ( goto xci )
if "%~x1"==".*" ( goto salida )
echo No hagas doble click sobre NX-Trimmer
echo.
echo Este programa solo funciona arrastrando un archivo xci sobre el mismo
echo.
echo Su función es eliminar la partición update de los archivos xci de forma automática
echo.
echo.El autor no es responsable de cualquier problema que los programas puedan acarrear sobre su dispositivo
echo.
pause
exit
:salida
echo Este programa solo acepta archivos xci
echo.
pause
exit

:xci
@echo off
setlocal enabledelayedexpansion
if exist "xciDecrypted" RD /s /q "xciDecrypted"
if not exist game_info MD game_info
if not exist output_nxt MD output_nxt
MD xciDecrypted

if exist "game_info\!filename!.ini" del "game_info\!filename!.ini"
cls
"%~dp0\ztools\hacbuild.exe" read xci "%~f1"
cls

move  "%~dp1\*.ini"  "%~dp0\xciDecrypted\" 
echo f | xcopy /f /y "xciDecrypted\*.ini" "game_info\"
RENAME xciDecrypted\*.ini ""game_info.ini"

::Remove identifiers [] in filename. If also want to remove () change delims=[ to delims=(
if exist xciDecrypted\*.txt del xciDecrypted\*.txt
echo %filename%>xciDecrypted\fname.txt
for /f "tokens=1* delims=[" %%a in (xciDecrypted\fname.txt) do (
    set filename=%%a)
::I also wanted to remove_(
set filename=%filename:_= %
del xciDecrypted\fname.txt
if exist "%~dp0\output_nxt\!filename!\" RD /s /q "%~dp0\output_nxt\!filename!\"

::Get partitions table from hactool and format it to get the secure partitions nca in correct order
"%~dp0\ztools\hactool.exe" -k "%~dp0\ztools\keys.txt" -t xci -i  "%~1" >xciDecrypted\partitions.txt 
cls

for /f "tokens=2* delims= " %%a in (xciDecrypted\partitions.txt) do (
echo %%a>>xciDecrypted\helper1.txt
)
FINDSTR "secure:/" xciDecrypted\helper1.txt >xciDecrypted\s_order.txt

for /f "tokens=1* delims= " %%a in (xciDecrypted\partitions.txt) do (
echo %%a>>xciDecrypted\helper2.txt
)
FINDSTR "secure:/" xciDecrypted\helper2.txt >>xciDecrypted\s_order.txt

for /f "tokens=4* delims= " %%a in (xciDecrypted\partitions.txt) do (
echo %%a>>xciDecrypted\helper3.txt
)

::Secu order is the order of the secure partitions nca
for /f "tokens=2* delims=/ " %%a in (xciDecrypted\s_order.txt) do (
echo %%a>>xciDecrypted\secu_order.txt)


Set "skip=,1,2,3,4,6,"
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<xciDecrypted\helper3.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>xciDecrypted\secu_number.txt

::Secu number is the number of the secure partitions nca
for /f %%a in (xciDecrypted\secu_number.txt) do (
    set secu_number=%%a
)
::echo !secu_number!>xciDecrypted\secn.txt


::Clean the folder
del xciDecrypted\helper1.txt
del xciDecrypted\helper2.txt
del xciDecrypted\helper3.txt
del xciDecrypted\partitions.txt
del xciDecrypted\s_order.txt

::If only 4 nca there's no game and no manual
:: Skip the next steps
if !secu_number! LSS 5 ( goto ognm )

::Get positions of cnmt.nca
FINDSTR  /N "cnmt.nca" xciDecrypted\secu_order.txt >>xciDecrypted\helper1.txt
for /f "tokens=1* delims=:" %%a in (xciDecrypted\helper1.txt) do (
echo %%a>>xciDecrypted\positions.txt)

del xciDecrypted\helper1.txt

::Get position of .cert
FINDSTR  /N ".cert" xciDecrypted\secu_order.txt >>xciDecrypted\helper2.txt
for /f "tokens=1* delims=:" %%a in (xciDecrypted\helper2.txt) do (
echo %%a>>xciDecrypted\cert_pos.txt)
del xciDecrypted\helper2.txt

for /f %%a in (xciDecrypted\cert_pos.txt) do (
    set cert_pos=%%a
)

::Get position of cnmt.nca in variables
set crlt=0
for /f %%a in (xciDecrypted\positions.txt) do (
    set /a crlt=!crlt! + 1
    set vet!crlt!=%%a
)

::check with echos
::echo !vet1!>xciDecrypted\vet1.txt
::echo !vet2!>xciDecrypted\vet2.txt
::echo !vet3!>xciDecrypted\vet3.txt
::echo !crlt!>xciDecrypted\cont.txt
::echo !cert_pos!>xciDecrypted\cert_pos2.txt
::echo !secu_number!>xciDecrypted\secu_number.txt


::Strip game content from rawsecure to move into secure
::Step 1. Get skiplist

set pos1=!vet1!
set pos2=!secu_number!
set string=
:stripgame1 
if !pos1! GTR !pos2! ( goto :stripgame2 ) else (set /a pos1+=1)
set string=%string%,%pos1%
goto :stripgame1 

:stripgame2
set string=%string%,
set skiplist=%string%

::echo %skiplist%>xciDecrypted\skiplist.txt

::Step 2. Strip no game content and save game nca in txt
Set "skip=%skiplist%"
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<xciDecrypted\secu_order.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>xciDecrypted\game_nca.txt

::Step 4. Extract secure partition with hactool
"%~dp0\ztools\hactool.exe" -k "%~dp0\ztools\keys.txt" -t xci --securedir=xciDecrypted\rawsecure\ "%~1"
MD "xciDecrypted\secure"

::Step 5. Move game nca to secure
set game_nca_number=0
for /f %%a in (xciDecrypted\game_nca.txt) do (
move  "xciDecrypted\rawsecure\%%a"  "xciDecrypted\secure" 
set /a game_nca_number+=1
)
::echo !game_nca_number!>xciDecrypted\game_nca_number.txt

echo f | xcopy /f /y "xciDecrypted\secu_order.txt" "xciDecrypted\content_helper.txt"
set a/ contador=0
set /a pos2=!vet1!-1
::echo %pos2%>xciDecrypted\pos2.txt
set /a pos1=0
set string=
:update_list1
if !pos1! GTR !pos2! ( goto :update_list2 ) else ( set /a pos1+=1 )
set string=%string%,%pos1%
goto :update_list1 
:update_list2
set string=%string%,
set skiplist=%string%
Set "skip=%skiplist%"
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<xciDecrypted\content_helper.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>xciDecrypted\other_content.txt
::del xciDecrypted\content_helper.txt
::echo %skiplist%>xciDecrypted\skiplist.txt
setlocal EnableDelayedExpansion

::Get number of other content
FINDSTR /R /N "^.*" xciDecrypted\other_content.txt | FIND /C ":">xciDecrypted\ocont_number.txt
for /f %%a in (xciDecrypted\ocont_number.txt) do (
    set ocont_number=%%a
)
::echo !ocont_number!>xciDecrypted\ocont_number2.txt

if %ocont_number% EQU 0 ( goto nocontent )


del xciDecrypted\positions.txt
::Get positions of cnmt.nca
FINDSTR  /N "cnmt.nca" xciDecrypted\other_content.txt >>xciDecrypted\helper1.txt
for /f "tokens=1* delims=:" %%a in (xciDecrypted\helper1.txt) do (
echo %%a>>xciDecrypted\positions.txt)

del xciDecrypted\helper1.txt

::Get position of cnmt.nca in variables
set crlt=0
for /f %%a in (xciDecrypted\positions.txt) do (
    set /a crlt=!crlt! + 1
    set vet!crlt!=%%a
)

::Get position of .cert
FINDSTR  /N ".cert" xciDecrypted\other_content.txt >>xciDecrypted\helper2.txt
for /f "tokens=1* delims=:" %%a in (xciDecrypted\helper2.txt) do (
echo %%a>>xciDecrypted\cert_pos.txt)
del xciDecrypted\helper2.txt

for /f %%a in (xciDecrypted\cert_pos.txt) do (
    set cert_pos=%%a
)

if cert_pos GTR 0 ( goto update_exist )
goto not_update 

:update_exist
set /a test=!cert_pos!-!vet1!
if !test! LSS 3 ( goto isupdate )

goto not_update
 
:not_update
set /a pos1=!vet1!
set /a pos2=!ocont_number!
set string=
if !vet1! EQU !ocont_number! ( goto endofcontent )

goto contentstrip1

:isupdate
if !cert_pos! EQU !ocont_number! ( goto endofcontent )


:contentstrip1
if !pos1! GTR !pos2! ( goto :contentstrip2 ) else (set /a pos1+=1)
set string=%string%,%pos1%
goto :contentstrip1 

:contentstrip2


set string=%string%,
set skiplist=%string%
echo %skiplist%>xciDecrypted\skiplist.txt
set /a contador+=1
set "skip=%skiplist%"
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<xciDecrypted\other_content.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>xciDecrypted\content!contador!.txt
MD "xciDecrypted\content!contador!"
for /f %%a in (xciDecrypted\content!contador!.txt) do (
move  "xciDecrypted\rawsecure\%%a"  "xciDecrypted\content!contador!" 
)

set /a pos2=!vet1!
set /a pos1=1
set string=
echo f | xcopy /f /y "xciDecrypted\other_content.txt" "xciDecrypted\content_helper.txt"
del xciDecrypted\other_content.txt

goto :update_list1 

:endofcontent
set /a contador+=1
MD "xciDecrypted\content!contador!"
move  "xciDecrypted\rawsecure\*"  "xciDecrypted\content!contador!" 

:nocontent

::If we only have 4 nca we have no manual
if !game_nca_number! LSS 5 ( goto nomanual )

::In this portion we'll identify the manual nca files via hactool
::Hactool will recognize 2 of them as manual when one is actually legal
::We'll do a supposition to identify each

set /a c_gamenca=1
set mycheck=Manual
:getmeinfo1
::In normal conditions we'll only have 5 nca files "tops" with a proper release
::If not proper it could be a big pain in the ass depending the conditions
::We'll iterate to identify the two manual nca files

set gstring=
if !c_gamenca! EQU 6 ( goto getmeinfo2 )
if !c_gamenca! EQU 1 ( set gstring=,2,3,4,5, )
if !c_gamenca! EQU 2 ( set gstring=,1,3,4,5, )
if !c_gamenca! EQU 3 ( set gstring=,1,2,4,5, )
if !c_gamenca! EQU 4 ( set gstring=,1,2,3,5, )
if !c_gamenca! EQU 5 ( set gstring=,1,2,3,4, )

Set "skip=%gstring%"
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<xciDecrypted\game_nca.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>xciDecrypted\ncatocheck.txt
for /f %%a in (xciDecrypted\ncatocheck.txt) do (
    set ncatocheck=%%a
)

"%~dp0\ztools\hactool.exe" -k "%~dp0\ztools\keys.txt" -t nca -i "xciDecrypted\secure\%ncatocheck%" >"xciDecrypted\nca_data.txt"
FINDSTR "Type" xciDecrypted\nca_data.txt >xciDecrypted\nca_helper.txt
for /f "tokens=3* delims=: " %%a in (xciDecrypted\nca_helper.txt) do (
echo %%a>>xciDecrypted\nca_helper2.txt)
Set "skip=,2,3,"
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<xciDecrypted\nca_helper2.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>xciDecrypted\nca_type.txt
for /f %%a in (xciDecrypted\nca_type.txt) do (
    set nca_type=%%a
)
if %nca_type% EQU %mycheck% ( echo %ncatocheck%>>xciDecrypted\manual_list.txt )
set /a c_gamenca+=1
del xciDecrypted\ncatocheck.txt
del xciDecrypted\nca_data.txt
del xciDecrypted\nca_helper.txt
del xciDecrypted\nca_helper2.txt
del xciDecrypted\nca_type.txt

goto getmeinfo1

:getmeinfo2
::We'll get the route of the alleged "manual nca" 
set crlt=0
for /f %%a in (xciDecrypted\manual_list.txt) do (
    set /a crlt=!crlt! + 1
    set tmanual!crlt!=%%a
)

::del manual_list.txt

::Set complete route
set f_tmanual1="%~dp0\xciDecrypted\secure\%tmanual1%"
set f_tmanual2="%~dp0\xciDecrypted\secure\%tmanual2%"

::Get size of both nca
for /f "usebackq" %%A in ('%f_tmanual1%') do set size_tm1=%%~zA
for /f "usebackq" %%A in ('%f_tmanual2%') do set size_tm2=%%~zA

::echo !size_tm1!>xciDecrypted\size_tm1.txt
::echo !size_tm2!>xciDecrypted\size_tm2.txt

::Ok, here's some technical explanation
::Normaly legas is like 130-190kb
::Manual can be some mb (offline manual) or less size than legal (online manual)
::I'm assuming the limit for legal sise is a little over 300kb. Can be altered if needed

if !size_tm1! GTR 3400000 ( goto case1 )
if !size_tm1! GTR 3400000 ( goto case2 )
if !size_tm1! GTR !size_tm2! ( goto case3 )
if !size_tm2! GTR !size_tm1!( goto case4 )
goto nomanual

:case1
del "%f_tmanual1%"
set filename=!filename![nm]
goto nomanual
:case2
del "%f_tmanual2%"
set filename=!filename![nm]
goto nomanual
:case3
del "%f_tmanual2%"
set filename=!filename![nm]
goto nomanual
:case4
del "%f_tmanual1%"
set filename=!filename![nm]
goto nomanual

:ognm
::If only 4 nca just extract secure partition to secure
"%~dp0\ztools\hactool.exe" -k "%~dp0\ztools\keys.txt" -t xci --securedir=xciDecrypted\secure\ "%~1"
goto nomanual

::In case we have no manual to proccess less code
:nomanual

RD /s /q "%~dp0\xciDecrypted\rawsecure"
::We don't need to preserve normal and update
MD "xciDecrypted\update"
MD "xciDecrypted\normal"
::We can clean the txt files
del xciDecrypted\*.txt

::Call hacbuild to build the xci
::To do->Force hacbuild to build secure in correct order in all cases
::To do->Option to preserve padding in secure header for future compatibility to dlc and update reforming
"%~dp0\ztools\hacbuild.exe" xci_auto "%~dp0\xciDecrypted"  "%~dp0\xciDecrypted\!filename![nxt].xci" 

::Create output folder and move trimmed file
echo %filename%>xciDecrypted\fname.txt
for /f "tokens=1* delims=[" %%a in (xciDecrypted\fname.txt) do (
    set ofolder=%%a)
del xciDecrypted\fname.txt
MD "%~dp0\output_nxt\!ofolder!"
move  "%~dp0\xciDecrypted\*.xci"  "%~dp0\output_nxt\!ofolder!" 
RD /s /q "%~dp0\xciDecrypted\normal"
RD /s /q "%~dp0\xciDecrypted\secure"
RD /s /q "%~dp0\xciDecrypted\update"
del xciDecrypted\*.ini

::Create content nsp
set a/ c_aux=0
if !contador! GTR 0 ( goto create_nsp ) 
goto :final

:create_nsp
if !contador! LEQ !c_aux! ( goto :final ) else ( set /a c_aux+=1 )

dir "%~dp0\xciDecrypted\content!c_aux!" /b  > "%~dp0\xciDecrypted\fileslist.txt"
FINDSTR /R /N "^.*" xciDecrypted\fileslist.txt | FIND /C ":">xciDecrypted\fileslist_helper.txt
for /f %%a in (xciDecrypted\fileslist_helper.txt) do (
    set fileslist=%%a
)

set list=0
for /F "tokens=*" %%A in (xciDecrypted\fileslist.txt) do (
    SET /A list=!list! + 1
    set varlist!list!=%%A
)
set varlist

::echo %string%>xciDecrypted\teststring.txt

if !fileslist! EQU 0 ( goto :final)
if !fileslist! EQU 1 ( "%~dp0\ztools\nspbuild.py" "%~dp0\xciDecrypted\content!c_aux!.nsp" "%~dp0\xciDecrypted\content!c_aux!\%varlist1%" )
if !fileslist! EQU 2 ( "%~dp0\ztools\nspbuild.py" "%~dp0\xciDecrypted\content!c_aux!.nsp" "%~dp0\xciDecrypted\content!c_aux!\%varlist1%" "%~dp0\xciDecrypted\content!c_aux!\%varlist2%" )
if !fileslist! EQU 3 ( "%~dp0\ztools\nspbuild.py" "%~dp0\xciDecrypted\content!c_aux!.nsp" "%~dp0\xciDecrypted\content!c_aux!\%varlist1%" "%~dp0\xciDecrypted\content!c_aux!\%varlist2%" "%~dp0\xciDecrypted\content!c_aux!\%varlist3%" )
if !fileslist! EQU 4 ( "%~dp0\ztools\nspbuild.py" "%~dp0\xciDecrypted\content!c_aux!.nsp" "%~dp0\xciDecrypted\content!c_aux!\%varlist1%" "%~dp0\xciDecrypted\content!c_aux!\%varlist2%" "%~dp0\xciDecrypted\content!c_aux!\%varlist3%" "%~dp0\xciDecrypted\content!c_aux!\%varlist4%" )
if !fileslist! EQU 5 ( "%~dp0\ztools\nspbuild.py" "%~dp0\xciDecrypted\content!c_aux!.nsp" "%~dp0\xciDecrypted\content!c_aux!\%varlist1%" "%~dp0\xciDecrypted\content!c_aux!\%varlist2%" "%~dp0\xciDecrypted\content!c_aux!\%varlist3%" "%~dp0\xciDecrypted\content!c_aux!\%varlist4%" "%~dp0\xciDecrypted\content!c_aux!\%varlist5%" )
if !fileslist! EQU 6 ( "%~dp0\ztools\nspbuild.py" "%~dp0\xciDecrypted\content!c_aux!.nsp" "%~dp0\xciDecrypted\content!c_aux!\%varlist1%" "%~dp0\xciDecrypted\content!c_aux!\%varlist2%" "%~dp0\xciDecrypted\content!c_aux!\%varlist3%" "%~dp0\xciDecrypted\content!c_aux!\%varlist4%" "%~dp0\xciDecrypted\content!c_aux!\%varlist5%" "%~dp0\xciDecrypted\content!c_aux!\%varlist6%")
if !fileslist! EQU 7 ( "%~dp0\ztools\nspbuild.py" "%~dp0\xciDecrypted\content!c_aux!.nsp" "%~dp0\xciDecrypted\content!c_aux!\%varlist1%" "%~dp0\xciDecrypted\content!c_aux!\%varlist2%" "%~dp0\xciDecrypted\content!c_aux!\%varlist3%" "%~dp0\xciDecrypted\content!c_aux!\%varlist4%" "%~dp0\xciDecrypted\content!c_aux!\%varlist5%" "%~dp0\xciDecrypted\content!c_aux!\%varlist6%" "%~dp0\xciDecrypted\content!c_aux!\%varlist7%")
if !fileslist! EQU 8 ( "%~dp0\ztools\nspbuild.py" "%~dp0\xciDecrypted\content!c_aux!.nsp" "%~dp0\xciDecrypted\content!c_aux!\%varlist1%" "%~dp0\xciDecrypted\content!c_aux!\%varlist2%" "%~dp0\xciDecrypted\content!c_aux!\%varlist3%" "%~dp0\xciDecrypted\content!c_aux!\%varlist4%" "%~dp0\xciDecrypted\content!c_aux!\%varlist5%" "%~dp0\xciDecrypted\content!c_aux!\%varlist6%" "%~dp0\xciDecrypted\content!c_aux!\%varlist7%" "%~dp0\xciDecrypted\content!c_aux!\%varlist8%")

set fileslist=0
del xciDecrypted\fileslist.txt
del xciDecrypted\fileslist_helper.txt
echo %filename%>xciDecrypted\fname.txt
for /f "tokens=1* delims=[" %%a in (xciDecrypted\fname.txt) do (
    set onsp=%%a)
del xciDecrypted\fname.txt
if exist "%~dp0\xciDecrypted\content!c_aux!\*.tik" ( rename "%~dp0\xciDecrypted\content!c_aux!.nsp" "!onsp![c!c_aux!][upd].nsp") else ( rename "%~dp0\xciDecrypted\content!c_aux!.nsp" "!onsp![c!c_aux!][dlc].nsp")
RD /s /q "%~dp0\xciDecrypted\content!c_aux!"
goto create_nsp

:final
move  "%~dp0\xciDecrypted\*.nsp" "%~dp0\output_nxt\!ofolder!" 

::Delete work folder
RD /s /q "%~dp0\xciDecrypted"

cls

echo Process finished
echo Your files should be in the output_nxt folder
PING -n 4 127.0.0.1 >NUL 2>&1
echo    /@
echo    \ \
echo  ___\ \
echo (__O)  \
echo (____@)  \
echo (____@)   \
echo (__o)_    \
echo       \    \

PING -n 2 127.0.0.1 >NUL 2>&1
exit





