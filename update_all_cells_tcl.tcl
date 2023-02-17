################################################################################
# Name: update_all_cells_tcl                                                   #
# Purpose: force update all the cells in a specific library		       #
#                                                                              #
# Please use this script at your own discretion and responsibility. Even though#
# This script was tested and passed the QA criteria to meet the intended       #
# specifications and behaviors upon request, the user remains the primary      #
# responsible for the sanity of the results produced by the script.            #
# The user is always advised to check the imported design and make sure the    #
# correct data is present.                                                     #
#                                                                              #
# For further support or questions, please e-mail support@eda-solutions.com    #
#                                                                              #
# Test platform version: S-Edit 2022.2u2 Release build                         #
# Author: Henry Frankland                                                      #
################################################################################
#LIMITATION OF LIABILITY:  Because this Software is provided “AS IS”, NEITHER SIEMENS EDA NOR ITS LICENSORS SHALL BE LIABLE FOR ANY DAMAGES WHATSOEVER IN CONNECTION WITH THE SOFTWARE OR ITS USE.  Without limiting the foregoing, in no event will Mentor Graphics or its licensors be liable for indirect, special, incidental, or consequential damages (including lost profits or savings) whether based on contract, tort (including negligence), strict liability, or any other legal theory, even if Mentor Graphics or its licensors have been advised of the possibility of such damages.  THE FOREGOING LIMITATIONS SHALL APPLY TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW.
#unless otherwise agreed in writing, SIEMENS EDA or its partners has no obligation to support or otherwise maintain Software.”

################################################################################
# --------------------------
# Installation:- 
# --------------------------
# 1. adjust line 48 to the desired zoom level
# 2. for one time use drag and drop the script into S-edit command window,
# for persistent use copy the script into the 
# '%APPDATA%\Roaming\Tanner EDA\scripts\startup.sedit' folder
# --------------------------
# Usage:-
# --------------------------
# 1. Open the L-edit tools
# 2. Ensure the script is sources into the environment with the ################ SCRIPT LOADED update_all_cells_tcl.tcl ################ message. if not perform the installation
# 3. With a design open, type update_proj {"<your library name>" "<another library name>"} and hit enter
# 4. The script will now go through the library and update every cell
#
#       ------------------- function_name 
#       |           ------- list of libraries {'Lib_a' 'Lib_b'}
#       |           |
#   update_proj {"liba"}
# --------------------------
# Notes:
# --------------------------

#########################################################################
#                                                                       #
#   History:                                                            #
#   Version 0.0 | 07/02/2023 - started work on script                   #
#   Version 0.1 | 15/02/2023 - finished first draft                     #
#   Version 0.2 | 16/02/2023 - finished debugging                       #
#   Version 1.0 | 16/02/2023 - first user release                       #
#########################################################################

set WRITE_LOG 2
set RUN_ID ""
set TOOL_NAME [lindex [workspace version] 0]
set LOG_DIRECTORY "$::env(appdata)\\Tanner EDA"

proc loop_through_cells {project lib_name cell_list lookup} {
    
    foreach cell $cell_list {
        if {$::WRITE_LOG >= 2} {write $::LOG_DIRECTORY [creat_log_ID "Looking at cell $cell" "INFO"] $::RUN_ID}

        set views_for_cell [lindex [lindex $lookup 1] [lsearch [lindex $lookup 0] $cell]]
        if {$::WRITE_LOG >= 2} {write $::LOG_DIRECTORY [creat_log_ID "Looking at views: $views_for_cell --- for cell $cell" "INFO"] $::RUN_ID}
        foreach view $views_for_cell {
            if {$::WRITE_LOG >= 2} {write $::LOG_DIRECTORY [creat_log_ID "executing  librarynavigator update_cells command with: -- primary $project -- lib $lib_name -- cell $cell -- view $view" "INFO"] $::RUN_ID}
            librarynavigator update_cells -primary $project -lcvs [list [list $lib_name $cell $view]]
        }
    }
}

proc create_simple_cell_view_list {primary lib} {
    ### create a list of list of cell views that correspond to the index of the related cell name {{a b c}{{a1 a2} {b1 b2} {c1 c2}}}
    set lib_view_list_all [database cells -library $primary -libraries $lib -lcv]
    
    set cells_index {}
    set cells_views {}

    foreach view $lib_view_list_all {
        set cell_name [lindex $view 1]
        set lookupIndex [lsearch $cells_index $cell_name]
        if {$lookupIndex != -1} {
            #if cell exists then edit the corresponding index in cell_views
            lset cells_views [list $lookupIndex end+1] [lindex $view 2]        
        } elseif {$lookupIndex == -1} {
            #if cell has not been looked at before, append the cell to the index and add a sublist at the end of the view list
            lappend cells_index $cell_name
            lset cells_views {end+1 0} [lindex $view 2]
        } else {
            write $::LOG_DIRECTORY [Generic_messages "ERROR" [creat_log_ID "ERROR in cellview function while looking at: view $view -- IN $cell_name -- IN -- $lib" "ERROR"]] $::RUN_ID
            exit 1
        }
    }
    puts [list $cells_index $cells_views]
    return [list $cells_index $cells_views]
}

#template messages 
proc Generic_messages {mode msg} {
    switch $mode {
		"ERROR" {
            set generic_message "\n################ ERROR ################
            ERROR: $msg
            WARNING: EXITING script
            ################ ERROR ################"
            return $generic_message
		}
		"RUN" {
			set generic_message  "\n################ RUNNING SCRIPT $msg ################"
            return $generic_message
		}
		"LOADED" {
			set generic_message  "\n################ SCRIPT LOADED $msg ################"
            return $generic_message
		}
		default {
			set generic_message  "error in switch case val, mode=$mode"
            return $generic_message
		}
	}
}

proc message_builder {message_list seperator} {
    set msg ""
    set list_length [llength $message_list]

    for {set i 0} { $i < $list_length} {incr i} {
        
        if {$i == [expr {$list_length -1}]} {
            append msg [lindex $message_list $i]
            continue
        }
        append msg [lindex $message_list $i]
        append msg $seperator
    }
    return $msg
}

proc creat_log_ID {msg level} {
    set message ""
    set seperator " -- "
    
    set valid_levels {"INFO" "LOW" "HIGH" "CRITICAL"}
    #gaurd clause only choose valid log level
    if {[lsearch $valid_levels $level] == -1} {puts "invalid log level"; throw}
    #Elements defines a list that defines the order of a string
    set elements [list $level [set Date [clock format [clock seconds] -format {%d_%m_%Y_%H_%M_%S}]] $msg]
    
    append message [message_builder $elements $seperator]

    return $message
}


proc gen_id {} {
    ###Create an ID with format DD_MM_YY_ID, where id is just the linux time when the ID function was executed
    set seperator "_"
    set local_RUN_ID [list [clock format [clock seconds] -format {%d_%m_%Y}] [clock micro]]

    set local_syntaxed_run_ID [message_builder $local_RUN_ID $seperator]
    return $local_syntaxed_run_ID
}

#creates file and writes out the log
proc write {dir msg ID} {
	
    
    set filename $::TOOL_NAME
	append filename "_debug_$ID"
	set file "$dir\\$filename.txt"
	if { [catch {set file_ID [open $file a+]} excuse] } {puts "unable to open log $dir for write"}
	
    #write a message to file and close
    puts $file_ID $msg
	close $file_ID

}

proc get_defs_project_info {} {
    set lib_defs_path [database path -defs]
    set defs_path_list [file split $lib_defs_path]
    set defs_path_list_length [llength $defs_path_list]
    
    set proj_info(Project) [lindex $defs_path_list end-1]
    set proj_info(lib_defs_name) [file tail $lib_defs_path]
    set proj_info(proj_path) [file dirname $lib_defs_path]
    if {$::WRITE_LOG == 2} {write $::LOG_DIRECTORY [creat_log_ID [array get proj_info] "INFO"] $::RUN_ID}
    return [array get proj_info]
}

proc update_cells_in_libraries {project lib_list} {
    set all_designs [database designs]
    

    foreach lib $lib_list {
        set cell_view_lookup_table [create_simple_cell_view_list $project $lib]
        #gaurd clause, only continue if the selected library is in the active project
        if {[lsearch $all_designs $lib] == -1} {
            puts "ERROR - did not find library $lib in open project"
            if {$::WRITE_LOG == 2} {write $::LOG_DIRECTORY [creat_log_ID "Disregarding $lib" "LOW"] $::RUN_ID}
            continue
        }
        if {$::WRITE_LOG >= 1} {write $::LOG_DIRECTORY [creat_log_ID "Looking at library $lib" "INFO"] $::RUN_ID}
        
        set cell_list [lindex $cell_view_lookup_table 0]
        if {$::WRITE_LOG == 2} {write $::LOG_DIRECTORY [creat_log_ID "cell list $cell_list" "INFO"] $::RUN_ID}

        #execute cell update function
        loop_through_cells $project $lib $cell_list $cell_view_lookup_table
    }
}

proc update_proj {libs} {
    Generic_messages "RUN" "update_cells"
    
    set ::RUN_ID [gen_id]

    if {$::WRITE_LOG >= 1} {write $::LOG_DIRECTORY [Generic_messages "RUN" "update_cells"] $::RUN_ID}

    set project_info [get_defs_project_info]
    #lsearch here is used to read the associated array value
    
    update_cells_in_libraries [lindex $project_info [expr {[lsearch $project_info "Project"] + 1}]] $libs
}

puts [Generic_messages "LOADED" "update_all_cells_tcl.tcl"]
