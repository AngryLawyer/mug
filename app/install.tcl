#FIXME: Abstract this away
source [file join [file dirname [info script]] "git.tcl"]

namespace eval ::mug::install {
    namespace export install install_directory

    proc ensure_mug_packages_directory {} {
        set path [install_directory]
        if {[file exists $path]} {
            if {[file isdirectory $path] == 0} {
                return -code error "Non-directory found in $path"
            }
        } else {
            file mkdir $path
        }
    }

    proc install_item {item} {
        if {[::mug::git::is_git_url $item] == 1} {
            ::mug::git::install $item
        } else {
            puts "$item is not a Git repo"
        }
    }

    proc install_directory {} {
        return "mug_packages"
    }

    proc install {items} {
        # Do we have any items?
        if {[llength $items] > 0} {
            ensure_mug_packages_directory
            foreach item $items {
                puts [install_item $item]
            }
        } else {
            # Otherwise install from a file
            if {[file exists "mug-requirements.txt"]} {
                set items [split [slurp_file "mug-requirements.txt"] "\n"]
                foreach item $items {
                    set item [string trim $item]
                    if {$item != {}} {
                        puts [install_item $item]
                    }
                }
            } else {
                #We have nothing to install
            }
        }
    }

    # Read a given file and spit it out
    proc slurp_file {name} {
        set fp [open $name r]
        set file_data [read $fp]
        close $fp
        return $file_data
    }
}
