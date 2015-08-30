namespace eval ::mug::autoloader {

    # Writes a sourceable script for using local packages
    proc provide_autoloader {path} {
        set destination [file join $path "mug_autoloader.tcl"]
        set mug_path [file join $path mug_packages]

        file mkdir $mug_path

        # List all existing subdirectories in the mug path, so we can keep them
        set packages [glob -directory $mug_path -type d -nocomplain *]
        if { $packages == "" } {
            set output {}
        } else {
            set first {set ::auto_path [linsert $::auto_path 0 }
            set last {]}
            set output $first$packages$last
        }

        set file_id [open $destination "w"]
        puts $file_id $output
        close $file_id
    }

}
