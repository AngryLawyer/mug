namespace eval ::mug::cache {
    namespace export cache_directory_path

    variable CACHE_ROOT /tmp

    proc cache_directory_name {name tag} {
        if {$tag != {}} {
            return $name-$tag
        } else {
            return $name
        }
    }

    proc cache_directory_path {name tag} {
        variable CACHE_ROOT
        return $CACHE_ROOT/[cache_directory_name $name $tag]
    }

    proc ensure_cache {cache_directory} {
        file mkdir $cache_directory
    }

    proc clean_cache {cache_directory} {
        variable CACHE_ROOT
        file delete -force $cache_directory
    }
}
