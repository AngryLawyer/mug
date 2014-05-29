namespace eval ::mug::utils {
    namespace export slurp_file get_installed_package_details set_installed_package_details

    # Read a given file and spit it out
    proc slurp_file {name} {
        set fp [open $name r]
        set file_data [read $fp]
        close $fp
        return $file_data
    }

    # Write a given string to a file
    proc write_file {name data} {
        set fp [open $name w]
        puts $fp $data
        close $fp
    }

    # Check a currently installed package 
    proc get_installed_package_details {package_path} {
        if {[file exists $package_path/.mug_details]} {
            set file_data [slurp_file $package_path/.mug_details]
            return $file_data
        }
        return {}
    } 

    # Write a details file into the installed package
    proc set_installed_package_details {package_path package_details} {
        write_file $package_path/.mug_details $package_details
    }
}
