#!/bin/bash

# Author: Esteban Capella (estebancapella.dg@gmail.com)
# Date: Nov 2023
# Description: take notes in bash

# MIT License
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so.

# SAY 'THANK YOU' WIT BITCOIN #
# https://coinos.io/estebanc
#
# Or Paypal: https://www.paypal.com/donate?token=VDf-ktQ3juHmTEVXNyI0fIuPmGqSfUe6lCcZh5bdsvdSytsdH5w0rcFq1jcUEiBP_Xx1X6skMcVo_moF

# set default values

category=""
count_category=""
count_note=0
get_this_note=""
captured_note=""

    #colores
coloroff="\e[0m"
black="\e[30m"
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
magenta="\e[35m"
cyan="\e[36m"
white="\e[37m"
grey="\e[90m"

## DEF FUNCTIONS
################

load_settings(){
    source .settings #load default variables settings from the file

    #load language setted in .settings file
    loadlanguage=".language_$language"
    source $loadlanguage
}
list_recent(){
    #list notes ordered by recent first
    list_recent=$(ls -t "$app_path" 2>/dev/null) #search for notes, recents first
    list_length=$(echo "$list_recent" | wc -l)
}
list_recent_sub(){
    #list notes in subfolder/categorie ordered by recent first
    list_recent_sub=$(ls -t "$app_path/$@" 2>/dev/null) #search for notes, recents first
    list_length_sub=$(echo "$list_recent_sub" | wc -l)
}
underline(){
    #print a undersocore for each character
    for ((i = 0; i < ${#1}; i++)); do

        if ((i % 2 == 0)); then
            colorhyphen="$cyan" #change color on even hyphens
        else
            colorhyphen="$green"
        fi

        echo -e -n "$colorhyphen-$coloroff"
    done
}
get_note(){
    #detect if its a folder
    if [[ $(ls --file-type -d "$app_path/$category/$file") =~ [/]+$ && $1 == "" ]]; then #ls will output a barr "/" at the end of the line if it's a folfer
        category="$file"

        if [[ "$count_category" == "" ]]; then #check it's the first folder/category found
            count_category="A"
        else #if it's not the first category (A) augment no the next
            count_category=$(echo "$count_category" | tr 'A-Za-z' 'B-ZAb-za') # increase alphabetic counter (A->B)
        fi

        if [[ "$get_this_note" == "$count_category" ]]; then #exit loop when category found
            get_this_note="pass"
            echo "$file"
            exit 0
        fi

        list_recent_sub "$category" #list notes in subfolder

        if [[ $list_recent_sub != "" && "$get_this_note" != "pass" ]]; then #check there is at list one note in the subfolder/category

            #get notes on subfolder/categorie
            subfolder=$(echo "$list_recent_sub" | while IFS= read -r file; do #call the printer
                get_note "$category"
            done)
            count_note=$((count_note + list_length_sub)) # in bash recursion sets a diferent set of variables in each call, so I need to update the number manually after printing the subcategory
            if [[ "$subfolder" != "" ]];then
                echo "$subfolder"
                exit 0
            fi
        fi
        category=""

    else #it's not a folder but a file
        ((count_note++))
    fi
    #print note name if it whas found
    if [[ "$get_this_note" == "$count_note" || "$get_this_note" == "$count_category" && "$get_this_note" != "pass" ]]; then
        #echo "nota: $count_note; categoría: $count_category; nombre: $file"
        category_with_slash=""
        if [[ "$category" != "" ]]; then
            category_with_slash="$category/" #add a divisory bar if the note is inside a category
        fi
        echo "$category_with_slash$file"
        get_this_note="pass"
        return
    fi
}
printnotelist(){
    #echo "variable COUNT es: $count_note" #testing
    #echo "var1 es: $1" #testing
    # print notes
    #detect if its a folder
    if [[ $(ls --file-type -d "$app_path/$category/$file") =~ [/]+$ && $1 == "" ]]; then #ls will output a barr "/" at the end of the line if it's a folfer
        category="$file"

        if [[ "$count_category" == "" ]]; then #check it's the first folder/category found
            count_category="A"
        fi

        #print category name and letter
        echo -n -e "$red  $count_category > $blue"
        echo -n -e ""
        echo "$category:"

        list_recent_sub "$category" #list notes in subfolder

        if [[ $list_recent_sub != "" ]]; then
            #print notes on subfolder/categorie
            #printnotelist "$file"
            echo "$list_recent_sub" | while IFS= read -r file; do #call the printer
                tab_subnote="     "
                printnotelist "$category"
                tab_subnote=""
            done
            count_note=$((count_note + list_length_sub)) # in bash recursion sets a diferent set of variables in each call, so I need to update the number manuali after printing the subcategory
        else
            #echo "variable de COUNT es: $count_note" #testing
            echo "      ---"
        fi
        category=""
        count_category=$(echo "$count_category" | tr 'A-Za-z' 'B-ZAb-za') # increase alphabetic counter (A->B)

    else
        ((count_note++))
        #print title
        echo -n -e "  ${magenta}"
        echo -n -e "$tab_subnote$count_note > $cyan"
        echo -n "$file"
        echo -e -n "$coloroff"

        #indicate if the note has content
        if [[ $(ls -s "$app_path/$category/$file") =~ ^[0]+ ]]; then #search for a size == 0 in the first character of the ls output
            #echo -n "$(ls -s "$file")"
            echo -n"" #pass
        else
            echo -e -n "$magenta +$coloroff" #print content indicator
        fi
        echo "" #print line jump
    fi
}
imprimir_uso_basico(){
    echo -e "\n   $dialgo_help_2" #dialgo_help_2 = USAGE:

    echo -e "\t$dialog_help_3$yellow $dialog_help_4 $coloroff" #dialog_help_3 = Check the list of notes like this: #dialog_help_4 = note
    echo -e "\t\t$dialog_help_5" #dialog_help_5 = Notes are always displayed in order of creation (most recent first)
    echo -e "\t\t$dialog_help_6\n" #dialog_help_6 = Each note has a number with which to manipulate them, and each category a letter

    echo -e "\t$dialog_help_7$yellow nota 1 $coloroff\n" #dialog_help_7 = Check the content of a note by indicating its number:

    echo -n -e "\t$dialog_help_8 $yellow" #dialog_help_8 = Add a simple note like this:
    echo -n "$dialog_help_9" && echo -n -e " $coloroff" #dialog_help_9 = nota My first note
    echo "$dialog_help_10" #dialog_help_10 = (you can use quotes or not)

    echo -n -e "\t$dialog_help_11 $yellow" #dialog_help_11 = Add a note with content like this:
    echo "$dialog_help_12" && echo -n -e " $coloroff" #dialog_help_12 = Title of the note; Content of the note after the semicolon, all in quotes

    echo -n -e "\t$dialog_help_13 $yellow" #dialog_help_13 = Add a category (to group notes) with a double semicolon at the end:
    echo "$dialog_help_14" && echo -n -e " $coloroff" #dialog_help_14 = note "Urgent tasks;;"


    echo -n -e "\n\t$dialog_help_15$yellow " #dialog_help_15 = Move a note within a category by pointing to note number + category letter:
    echo -e "nota 1 B$coloroff $dialog_help_17" #dialog_help_17 = (move note number 1 to category B, you can use lowercase)

    echo -n -e "\n\t$dialog_help_18$yellow " #dialog_help_18 = Delete a note or category like this:
    echo -e "nota -d 1$coloroff $dialog_help_19" #dialog_help_19 = (it will be a letter if you try to delete a category)
    echo -n -e "\t\t$dialog_help_20$yellow " #dialog_help_20 = It can also be removed with:
    echo -e "-d -del -delete -r -remove $coloroff\n"

    echo -e "\t$dialog_help_23:$yellow nota -edit 1 $coloroff ($dialog_help_27)" #dialog_help_23 = Edit a note like this #dialog_help_27 = edit note 1
    echo -e "\t\t$dialog_help_25$yellow -e $lang_param_edit$coloroff \n" #dialog_help_25 = You can also use

    echo -e "\t$dialog_help_32:$yellow nota -edit 1 kate $coloroff ($dialog_help_33)" #dialog_help_32 = Edit a note with any text editor like this #dialog_help_33 = edit note 1 with the Kate text editor
    echo -e "\t\t$dialog_help_25$yellow -e $lang_param_edit$coloroff \n" #dialog_help_25 = You can also use

    echo -e "\t$dialog_help_29:$yellow nota -rename 1 $coloroff ($dialog_help_30)" #dialog_help_29 = Rename the title of a note or category (group of notes) like this #dialog_help_30 = rename note 1
    echo -e "\t\t$dialog_help_25$yellow -name $coloroff \n" #dialog_help_25 = You can also use

    echo -e "\t$dialog_help_24:$yellow nota -path 1$coloroff (the path will be printed)" #dialog_help_24 = Show note's path like this
    echo -e "\t\t$dialog_help_25$yellow -p -$param_path $param_path $coloroff \n" #dialog_help_25 = You can also use

    echo -e "\t$dialog_help_26:$yellow nota -browser$coloroff" #dialog_help_26 = Open file browser in the notes directory like this
    echo -e "\t\t$dialog_help_25$yellow -b -fb$coloroff \n" #dialog_help_25 = You can also use

    echo -e "\t$dialog_help_28:$yellow nota -touch 4 $coloroff"
    echo -e "\t\t$dialog_help_25$yellow -t -up -u$coloroff \n" #dialog_help_25 = You can also use

    echo -e "\t$dialog_help_31:$yellow nota -language$coloroff"
    echo -e "\t\t$dialog_help_25$yellow -l -lang $coloroff \n" #dialog_help_25 = You can also use

    echo -n -e "\t$dialog_help_21$yellow " #dialog_help_21 = Consult this guide with:
    echo -e "nota --help $coloroff (or -h; -help; $dialog_help_1)"

    #donations:
    echo -e "\n    $dialog_help_22" #dialog_help_22 = SAY 'THANK YOU' BY SENDING BITCOIN
    echo -e "    -$cyan https://coinos.io/estebanc $coloroff"
    echo "    -"
    echo -e "    - Or Paypal: https://www.paypal.com/donate/?hosted_button_id=DTG94EYGCN5PG"

    echo "" #esto es un separador
}
#################




# LOADING SETTINGS FILE
#######################

# move to the note directory if executed from the installed script
if [[ "$0" == "/usr/local/bin/nota" ]]; then
    cd ~/nota

    #if error acceding to the note's folder
    if [ $? == 1 ]; then
        echo -e "\nERROR\n$red    EN: The notes directory cannot be found, try installing the program again from source. $coloroff"
        echo -e "$red    ES: No se encuantra el directorio de notas, intenta instalar nuevamente el programa desde la fuente. $coloroff\n"
        exit 0
    fi

    load_settings #load defaults
else
    load_settings #load defaults
    #replace default note directory
    app_path="$(dirname "$0")" #saving relative path
fi



# INSTALATION
#############

if [[ "$firstime" == "yes" ]]; then
    if [ -e "/usr/local/bin/notaaaaa" ]; then #check the scripts its already installed, fake script for enter
        echo "$dialog_install_2"; #dialog_install_2 = It's already installed
    else
        echo "$dialog_install_3" #dialog_install_3 = It looks like this is the first time you've run this script.
        userinput=
        while [[ "$userinput" != [yYsSnN] ]]; do
            echo -n "$dialog_install_4" && echo ' /usr/local/bin/nota ?' #dialog_install_4 = Do you want to install it on
            echo -e "$yellow ($dialog_install_5 ~/nota/) $coloroff" #dialog_install_5 = your notes will be saved in
            read userinput
        done

        if [[ "$userinput" == [yYsS] ]]; then
            #instalar script
            #copiar script
            sudo cp nota.sh /usr/local/bin/nota
            #check it's installed
            if [[ -e "/usr/local/bin/nota" ]]; then
                #dar permiso de root
                sudo chmod +x /usr/local/bin/nota
                #notificar instalación
                echo "$dialog_install_6 /usr/local/bin/nota" #dialog_install_6 = script installed in
            else
                echo -e "$red$dialog_install_7 :(" #dialog_install_7 = Could not install
                exit 0
            fi

            #reload settings to recover the original $app_path variable value
            load_settings

            #crear folder en home
            if [[ -e "$app_path" ]]; then #check the app_path directory already exists
                echo "$dialog_install_8 $app_path $dialog_install_9" #dialog_install_8 = The folder #dialog_install_9 = already exists, it will be used to save notes
            else
                mkdir $app_path #create dir
                #check the dir exists
                if [[ -e "$app_path" ]]; then
                    echo "$dialog_install_10 $app_path $dialog_install_11" #dialog_install_10 = The folder  #dialog_install_11 = was successfully created
                else
                    echo "$dialog_install_12 $app_path, $dialog_install_13" #dialog_install_12 = Can't create directory  #dialog_install_13 = try creating it manually and try the installation again
                    exit 0
                fi
            fi

            sed -i 's/^firstime=.*/firstime=no/' .settings #save variable in file

            #copy config and language files
            list_language_files=$(ls ".language"*)
            echo "$list_language_files" | while read -r file; do
                cp "$file" "$app_path/$file"
                echo "$dialog_install_14    $app_path/$file" #dialog_install_14 = Copied:
            done
            cp ".settings" "$app_path/.settings"
            echo "$dialog_install_14    $app_path/.settings" #dialog_install_14 = Copied:

            echo -e "\n$cyan $dialog_install_15... $coloroff \n" #dialog_install_15 = All ready
            imprimir_uso_basico #print user's manual
        fi
        sed -i 's/^firstime=.*/firstime=no/' .settings #save variable in file
    fi
    exit 0
fi

# CHECK THE WORKING DIRECTORY EXISTS (afterinstall)
####################################

if ! [[ -e "$app_path" ]]; then
    echo "$dialog_install_10 $app_path $dialog_install_16" #dialog_install_10 = The folder #dialog_install_16 = does NOT exist, it is going to be created...

    mkdir $app_path #create dir
    #check the dir exists
    if [[ -e "$app_path" ]]; then
        echo "$dialog_install_10 $app_path $dialog_install_19" #dialog_install_10 = The folder  #dialog_install_19 = was successfully created
    else
        echo "$dialog_install_17 $app_path, $dialog_install_18" #dialog_install_17 = Could not create directory  #dialog_install_18 = try creating it manually and try the installation again.
        exit 0
    fi
    exit 0
fi



### P A R A M E T E R S ###-----


# RESTORE INSTALL DIALOG
########################

if [[ "$@" == "-install" || "$@" == "install" ]]; then
    sed -i 's/^firstime=.*/firstime=yes/' .settings #save variable in file
    echo "$dialog_install_1" && echo "" #dialog_install_1 = The installation dialog has been restored, now run the script again without parameters to install the script in your system
    exit 0
fi


# LIST LANGUAGES
################

if [[ "$@" == "-l" || "$@" == "-lang" || "$@" == "-language" ]]; then
    current_language_code=$(cat ".settings" | sed -n "s/^language=\(.*\)/\1/p") #save actual language code

    echo -e "\n    $dialog_21\n" #dialog_21 = Available languages:
    languages_counter=0
    #list available languages
    available_languages=$(ls ".language_"*)
    echo "$available_languages" | while IFS= read -r file; do
        ((languages_counter ++))

        current_file_language_code=$(echo "$file" | sed -n "s/^.language\_\(.*\)/\1/p") #curren file item lang code

        #check it's the language setted
        if [[ "$current_file_language_code" == "$current_language_code" ]]; then
            marker="$cyan$dialog_lang_1$coloroff" #dialog_lang_1 = < current
        else
            marker=
        fi

        echo -n -e "      $magenta$languages_counter $coloroff"
        echo -e $(cat $file | head -1 | sed -n 's/^#dialogs \(.*\)/\1/p') $marker
    done
    echo ""

    #ask user to select a language
    read  -p "  $dialog_lang_2" language_selected #read user input #dialog_lang_2 = Select language (by its index number):

    languages_counter=0 #reset counter
    language_changed=false

    #get language code (EN; ES; etc.)
    while IFS= read -r file; do #loop troughout the list of languages
        ((languages_counter ++))
        if [[ "$languages_counter" == "$language_selected" ]]; then #if it's the language user wanted
            language_selected=$(echo "$file" | sed -n 's/^.language_\(.*\)/\1/p')
            sed -i "s/^language=.*/language=$language_selected/" .settings #save new language in settings
            language_changed=true #the language was changed
            language_long=$(cat $file | head -1 | sed -n 's/^#dialogs \(.*\)/\1/p')
            break
        fi
    done <<< "$available_languages" #loop input

    if [[ $language_changed == true ]]; then
        echo -e "  $dialog_lang_3 $yellow $language_long ($language_selected)$coloroff\n" #dialog_lang_3 = The language has changed to
    else
        echo -e "$red  $dialog_lang_4 $coloroff\n" #dialog_lang_4 = Nothing has been changed
    fi
    exit 0
fi



# PRINT HELP
############

if [[ "$@" == "-h" || "$@" == "-help" || "$@" == "--help" || "$@" == "$dialog_help_1" ]]; then
    imprimir_uso_basico
    exit 0
fi






### N O T E S ###-------


# TOUCH NOTE (BRING IT UP)
##########################

if [[ "$#" == 2 && ( "$1" == "-touch" || "$1" == "-t" || "$1" == "-up" || "$1" == "-u" ) && "$2" =~ [0-9a-zA-Z]+ ]]; then
    # searching note or category
    list_recent #obtain list of notes

    get_this_note="${2^^}" #make string UPERCASE if a letter

    captured_note=$(echo "$list_recent" | while IFS= read -r file; do #get the note
        get_note
    done)

    if [[ "$captured_note" == "" ]]; then
        echo -e "$red\n $dialog_31\n" #dialog_31 = Note not found
        exit 0
    fi

    if [ "$app_path" == "." ]; then
        app_path=$PWD
    fi
    echo -e -n "\n   $dialog_32:" #dialog_32 = The note was elevated
    touch "$app_path/$captured_note"
    echo -e "$yellow $captured_note $coloroff \n" #print note path
    exit 0
fi



# SHOW NOTE PATH
################

if [[ "$#" == 2 && ( "$1" == "-path" || "$1" == "-p" || "$1" == "-$param_path" || "$1" == "$param_path" ) && "$2" =~ [0-9a-zA-Z]+ ]]; then
    # searching note or category
    list_recent #obtain list of notes

    get_this_note="${2^^}" #make string UPERCASE if a letter

    captured_note=$(echo "$list_recent" | while IFS= read -r file; do #get the note
        get_note
    done)

    if [ "$app_path" == "." ]; then
        app_path=$PWD
    fi
    echo -e -n "\n   $dialog_30:" #dialog_30 = Ruta
    echo -e "$yellow   $app_path/$captured_note $coloroff \n" #print note path
    exit 0
fi

# OPEN FILE BROWSER
###################

if [[ "$@" == "-browser" || "$@" == "-b" || "$@" == "-fb" ]]; then
    # searching note or category
    if [ "$app_path" == "." ]; then
        app_path=$PWD
    fi
    xdg-open "$app_path"
    exit 0
fi


# EDIT NOTE or CATEGORY
#########################

if [[ "$#" == 2 && ( "$1" == "-edit" || "$1" == "-e" || "$1" == "$lang_param_edit" ) && "$2" =~ [0-9a-zA-Z]+ ]]; then #if editing with 2 parameters
    # searching note or category
    list_recent #obtain list of notes

    get_this_note="${2^^}" #make string UPERCASE if a letter

    captured_note=$(echo "$list_recent" | while IFS= read -r file; do #get the note
        get_note
    done)

    #echo "cap: $captured_note"

    if [[ "$captured_note" == "" ]]; then #exit on out of range
        echo "$dialog_22" #Note not found
        exit 0
    fi

    original_path="$app_path/$captured_note" #save entire path

    #detect it's a category (folder)
    if [[ $(ls --file-type -d "$original_path") =~ [/]+$ ]]; then
        echo -e "$dialog_23$yellow nota -rename $get_this_note" #dialog_23 = you cannot edit a category (group of notes), try renaming with this command:
        echo "" #print new line
        exit 0
    else #it's a file
        echo -e "$dialog_24:$cyan $captured_note $coloroff" #dialog_24 = Edit
        $text_editor "$original_path"
        echo "" #print new line
    fi
    exit 0
elif [[ "$#" == 3 && ( "$1" == "-edit" || "$1" == "-e" ) && "$2" =~ [0-9]+ && "$3" =~ ^[a-zA-Z]+$ ]]; then #if 3 parameter, edit with other editor
    if type "$3" &> /dev/null; then #if the command passed is instaled
        # searching note or category
        list_recent #obtain list of notes

        get_this_note="${2^^}" #make string UPERCASE if a letter

        captured_note=$(echo "$list_recent" | while IFS= read -r file; do #get the note
            get_note
        done)

        #echo "cap: $captured_note"

        if [[ "$captured_note" == "" ]]; then #exit on out of range
            echo "$dialog_22" #Note not found
            exit 0
        fi

        $3 "$app_path/$captured_note" #launch editor

    else
        echo -e "$red    $dialog_34 $coloroff '$3'" #dialog_34 = Command not found
        echo -e "    $dialog_20 $yellow nota --help $coloroff($dialog_33 -h; -help; help)" #dialog_20 = Get help with the following command:
        echo "" #line jump
    fi
    exit 0
fi


# RENAME NOTE or CATEGORY
#########################

if [[ "$#" == 2 && ( "$1" == "-rename" || "$1" == "-name" ) && "$2" =~ [0-9a-zA-Z]+ ]]; then
    list_recent #obtain list of notes

    get_this_note="${2^^}" #make string UPERCASE if a letter

    captured_note=$(echo "$list_recent" | while IFS= read -r file; do #get the note
        get_note
    done)

    #echo "cap: $captured_note" #testing

    if [[ "$captured_note" == "" ]]; then #exit on out of range
        echo -e "\n$red    $dialog_22\n" # dialog_22 = Note not found
        exit 0
    fi

    echo -e "\n    $dialog_25$cyan $captured_note$coloroff" #dialog_25 = It is going to be renamed
    echo -e -n "    $dialog_28:$grey$dialog_29 $yellow" # dialog_28 = Write the new name #dialog_29 = (N to cancel)
    user_input=
    while [[ "$user_input" == "" ]]; do
        read user_input
    done

    echo -e -n "$coloroff" #color off, no new line

    if [[ "$user_input" == "N" || "$user_input" == "n" ]]; then #user cancelled operation
        echo -e "\n    $dialog_26\n" # dialog_26 = Canceled, nothing has been changed
        exit 0
    fi

    original_path="$app_path/$captured_note" #save entire path
    #detect it's a category (folder)
    if [[ $(ls --file-type -d "$original_path") =~ [/]+$ ]]; then
        echo "" #new line
        mv "$original_path" "${original_path%/*}/$user_input"
        echo -e -n "   $dialog_27: $yellow" && echo "${original_path%/*}/$user_input" # dialog_27 = Renamed to
        echo "" #print new line
    else #it's a file
        echo "" #new line
        mv "$original_path" "${original_path%/*}/$user_input"
        echo -e -n "   $dialog_27: $yellow" && echo "${original_path%/*}/$user_input" # dialog_27 = Renamed to
        echo "" #print new line
    fi

    exit 0
fi





# PRINTING NOTE LIST
####################

# check there is not arguments and print list of notes
if [ $# -eq 0 ]; then
    #list notes and save in "$list_recent""
    list_recent

    #check for empty notes
    if [ $? -eq 2 ] || [ "$list_recent" = "" ]; then   #outpu 2 means not files or directory found
        echo -e "  $dialog_3,\n  $dialog_4:$yellow $dialog_4b $coloroff" #dialog_3 = No notes saved, #dialog_4 = You can add a new one with the following command #dialog_4b = 'note Note title; Content of the note after the first semicolon'

        echo -e -n "  $dialog_20 $yellow" #dialog_20 = Get help with the following command:
        echo -e "nota --help $coloroff ($dialog_33 -h; -help; $dialog_help_1)\n" #dialog_33 = or

    #print notes found
    elif [ "$list_recent" != "" ]; then
        echo -e "\n $dialog_1\n" #dialog_1 = Saved notes:
        #echo "$list_recent"

        echo "$list_recent" | while IFS= read -r file; do #call the printer
            printnotelist
        done
        echo -e "$grey\n  $dialog_2\n" #dialog_2 = You can read the content of a note by indicating it's number, example: 'nota 1'
    fi
    exit 0
fi


## PRINTING A NOTE
#################

# check there is 1 argument nonly AND discard the first argument is a parameter AND check it's an integer or a letter
if [[ $# -eq 1 && $1 != "-"* && $1 =~ ^[0-9A-Z]+$ ]]; then
    #echo "buscando nota, num de parametros: $#, que es: $1"
    list_recent #obtein list of notes

    get_this_note="$1"

    captured_note=$(echo "$list_recent" | while IFS= read -r file; do #get the note
        get_note
    done)

    #echo "cap: $captured_note"

    if [[ "$captured_note" == "" ]]; then #exit on out of range
        echo -e "\n$red   $dialog_22 \n" #dialog_22 = Note not found
        exit 0
    fi


#     title=$(echo "$list_recent" | sed -n "${1}p") #save title of the note
    echo -n -e "$cyan\n  " #print a space febore the title
    echo "$captured_note" #printing title
    echo -n -e "  $coloroff" #print a space febore title underscore
    underline "$captured_note" #print underline
    #echo -e "\n" #separation from note
    echo -n -e "$cyan\n  " #print a space febore note

    #detect category
    if [[ $(ls --file-type -d "$app_path/$captured_note") =~ [/]+$ ]]; then
        echo $(ls -Q "$app_path/$captured_note")
    else
        #its not a caategory, print content
        echo "$(cat "$app_path/$captured_note")"
    fi
    echo -e ""

    exit 0
fi


## ADDING A NOTE
################

allparameters="$@"

# Note with content: discard the first parameter is an argument AND check there is a semicolon in the arguments
if [[ "$1" != "-"* && $1 != ";"* && "$@" == *";"* && ! "$allparameters" =~ .*";"$ ]]; then
    title=$(echo "$1" | cut -d ';' -f 1) #save the first part of the string (until the ; chacarter) as a title
    note=$(echo "$1" | cut -d ';' -f 2-) #save the other part as the body of the note
    note="${note#"${note%%[![:space:]]*}"}" #remove spaces at the BEGINING of the note
    note="${note%"${note##*[![:space:]]}"}" #remove spaces at the END of the note

    #save as a file
    echo "$note" > "$app_path/$title"

    if [ -e "$app_path/$title" ]; then
        #saved notification
        echo -n -e "\n  $dialog_5 '$cyan" #dialog_5 = The note
        echo -n "$title"
        echo -e "$coloroff' $dialog_6" #dialog_6 = was saved

        echo -e "$yellow  ($app_path/$title)$coloroff"
        echo "" #line jump
    else
        echo -e "$red  $dialog_7 $app_path/$title\n" #dialog_7 = The note could not be saved in
    fi
    exit 0
fi
#echo "long ${#allparameters}" #testing

# Note without content: discard the first parameter is an argument AND there is at least 4 caracteres (preventing adding notes when asking for printing a category, e.g.: "note a"; "note 12")
# AND exit if a moving pattern is found (eg: nota 5 B)
if [[ "$1" != "-"* && ${#allparameters} -ge 4 && ! "$@" =~ .*";;"$ && ! ( $# -eq 2 && $1 == [1-999]* && "$2" =~ ^[a-zA-Z]+$ ) ]]; then
    title="$@"
    title="${title%%;*}" #remove semicolons at the end:

    title="${title#"${title%%[![:space:]]*}"}" #remove spaces at the begining of the note

    #save as a file
    touch "$app_path/$title"

    if [ -e "$app_path/$title" ]; then
        #saved notification
        echo -n -e "\n  $dialog_5 '$cyan" #dialog_5 = The note
        echo -n "$title"
        echo -e "$coloroff' $dialog_6" #dialog_6 = was saved

        echo -e "$yellow  ($app_path/$title)$coloroff\n"
    else
        echo "$red $dialog_7 $app_path/$title\n" #dialog_7 = The note could not be saved in
    fi
    exit 0
fi


## REMOVE NOTE
##############

#check the first argument is a -[d; del; delete; r; remove] and the second an integer
if [[ ($1 == "-d" || $1 == "-del" || $1 == "-delete" || $1 == "-r" || $1 == "-remove" ) && "$2" =~ ^[0-9a-zA-Z]+$ && "$#" -eq 2 ]]; then

    list_recent #obtener lista de notas

    get_this_note="${2^^}"

    captured_note=$(echo "$list_recent" | while IFS= read -r file; do #get the note
        get_note
    done)

    title="$captured_note"
    #echo "title es: $title"

    if [[ "$title" == "" ]]; then #exit if not found
        echo -e "    $dialog_13\n" #dialog_13 = Does not exist, nothing has been removed
        exit 0
    fi

    #thetect its a folder and has notes inside
    if [[ $(ls --file-type -d "$app_path/$title") =~ [/]+$ ]]; then
        hascontent="$dialog_12" #dialog_12 = category and all its content?
    else
        hascontent="$dialog_11" #dialog_11 = note?
    fi

    userinput=
    while [[ $userinput != [yYsSnN] ]]; do
        echo -n -e "  $dialog_10 $hascontent: '$cyan" #dialog_10 = Do you want to delete this
        echo -n "$title"
        echo -e "$coloroff'"
        read userinput
    done


    if [[ $userinput == [nN] ]]; then
        echo -e "   $dialog_8\n" #dialog_8 = Nothing has been removed
        exit 0
    else
        #eliminar nota/categoría
        rm -d -r "$app_path/$title"
        echo -e "$yellow  $dialog_9 $coloroff\n" #dialog_9 = The note has been deleted

        exit 0
    fi

    exit 0
fi



## CREATE A CATEGORY
############################

#check there are no parameters (-xxx), there is a double semicolon at the end
if [[ $1 != "-"* && $1 != ";"* && "$@" =~ .*";;"$ ]]; then
    category="$@"
    category=$(echo "$category" | sed 's/;*$//') #remove all semicolons at the end

    mkdir "$category" #create category

    if [ -e "$app_path/$category" ]; then #check the file exists (it's saved)
        #saved notification
        echo -n -e "\n  $dialog_35 '$cyan" #dialog_35 = The category
        echo -n "$category"
        echo -e "$coloroff' $dialog_36" #dialog_36 = was saved

        echo -e "$yellow  ($app_path/$category)$coloroff \n"
    else
        echo "$red  $dialog_37 $app_path/$category" #dialog_37 = Could not create category in
    fi

    exit 0
fi




## MOVE NOTE INTO A CATEGORY
############################

# syntaxis: nota 5 B
# check there is only two parameters and they are numeric AND alphabetical
if [[ $# -eq 2 && $1 == [1-999]* && "$2" =~ ^[a-zA-Z]+$ ]]; then

    list_recent #obtener lista de notas

    #find note to move
    get_this_note="$1"
    captured_note=$(echo "$list_recent" | while IFS= read -r file; do #get the note
        get_note
    done)

    #echo "moviendo nota: $captured_note"

    #find folder/category to move in
    get_this_note="${2^^}" #making it UPPERCASE

    captured_category=$(echo "$list_recent" | while IFS= read -r file; do #get the note
        get_note
    done)

    #echo "moviendo a $captured_category"

    #exit from mooving note if the note or category is not found
    if [[ "$captured_note" == "" || "$captured_category" == ""  ]]; then
        echo -e "\n$red  $dialog_18$coloroff\n" #dialog_18 = The note or category cannot be found to move it
        exit 0
    fi

    userinput=
    while [[ $userinput != [yYsSnN] ]]; do
        echo -n -e "  $dialog_14 $cyan" #dialog_14 = Do you want to move the note?
        echo -n "$captured_note"
        echo -n -e "$coloroff $dialog_15 $blue" #dialog_15 = to the category
        echo -n "$captured_category"
        echo -e "$coloroff?"
        read userinput
    done

    if [[ "$userinput" == [yYsS] ]]; then
        echo -n ""
    else
        echo -e "  $dialog_16\n" #dialog_16 = Nothing has moved
        exit 0
    fi

    mv "$captured_note" "$captured_category"

    echo "  $dialog_17" #dialog_17 = The note has moved
    echo -e "$yellow  ($app_path/$captured_category/$captured_note)$coloroff\n"

    exit 0
fi



## IF NO CONDITIONS WERE MATCHED
################################
echo -e "\n$red  $dialog_19$coloroff" #dialog_19 = No operation could be performed
echo -e "  $dialog_20 $yellow nota --help $coloroff($dialog_33 -h; -help; help)\n" #dialog_20 = Get help with the following command:
