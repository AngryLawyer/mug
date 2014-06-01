namespace eval ::mug::teapot {

    variable TEAPOT_URL http://teapot.activestate.com

    # Args are defined like {name comparator source version}
    # Get a URL really simply
    proc get_page {url} {
        set token [::http::geturl $url]
        set data [::http::data $token]
        ::http::cleanup $token          
        return $data
    }

    # From a Teapot URL, extract the meaningful data
    proc extract_teapot_string {teapot_string} {
        set start [string first {[[TPM[[} $teapot_string]
        set end [string first {]]MPT]]} $teapot_string]
        return [string range $teapot_string [expr {$start + 7}] [expr {$end - 1}]]
    }

    # Get the relevant teapot info from a given Url
    proc get_teapot_info {url} {
        set data [get_page $url]
        return [extract_teapot_string $data]
    }

    proc find_teapot_package {package_name {version "any"} {platform "tcl"}} {
        variable TEAPOT_URL
        # Find the package in our packages list
        set packages [get_teapot_info $TEAPOT_URL/package/list]
        # FIXME: We should really cache this :(
        puts $packages

        #set named_packages [filter {package_tuple {
        #    upvar 2 package_name package_name version version platform platform
        #    if {[lindex $package_tuple 1] == $package_name &&
        #        [match_version [lindex $package_tuple 2] $version] &&
        #        [match_platform [lindex $package_tuple 3] $platform]} {
        #        return 1
        #    }
        #}} $packages]

        #return [pick_newest $named_packages]
    }

    proc get_repo_name {repo_description} {
        return [lindex [split $repo_description @] 0]
    }

    proc get_repo_version {repo_description} {
        return [lindex [split $repo_description @] 1]
    }

    proc install_repo {repo_name cache_directory repo_tag} {
        # We're doing a fresh install of a repo
        ::mug::cache::clean_cache $cache_directory
        ::mug::cache::ensure_cache $cache_directory

        # TODO: Do the install
        # Copy copy copy
        file copy $cache_directory ./mug_packages/$repo_name
        find_teapot_package $repo_name
        # Remove copied git directory
        file delete -force ./mug_packages/$repo_name/.git 
        ::mug::utils::set_installed_package_details ./mug_packages/$repo_name $repo_name-$repo_tag-teapot
        ::mug::cache::clean_cache $cache_directory
    }

    proc install {package_description} {

        set repo_name [get_repo_name $package_description]
        set repo_tag [get_repo_version $package_description]

        set cache_directory [::mug::cache::cache_directory_path $repo_name $repo_tag]

        # Try and find the repo first

        ::mug::install::clean_repo $repo_name $repo_tag teapot 
        install_repo $repo_name $cache_directory $repo_tag

        if {$repo_tag != {}} {
            return "$repo_name@$repo_tag mug_packages/$repo_name"
        } else {
            return "$repo_name mug_packages/$repo_name"
        }
    }
}
