#' SlurmContainer R6 object.
#'
#' A slurm container is simply a directory with a specific
#' structure, particulary it has a submit.slurm script at the
#' top level.
SlurmContainer <- R6::R6Class("SlurmContainer",
    public = list(
        dir = NULL,
        initialize = function(dir = ".") {
            sub_dirs <- c("/data", "/sources", "/objects")

            is_stain <- Reduce("&", sub_dirs %in% list.dirs(dir))
            if (!is_stain) {
                name <- paste0("job_", private$rand_alphanumeric())
                dir <- paste(getwd(), dir, name, sep = "/")

                for (sub_dir in sub_dirs) {
                    dir.create(paste0(dir, "/.stain", sub_dir), recursive = TRUE,
                               showWarnings = FALSE)
                }

                dir.create(paste0(dir, "/output"), recursive = TRUE,
                            showWarnings = FALSE)
            }

            self$dir <- dir
        },
        add_object = function(name, value) {
            if (length(value) > 1) {
                is_na <- FALSE
            } else {
                is_na <- is.na(value)
            }

            if (!is_na) {
                obj_dir <- paste0(self$dir, "/.stain/objects")
                rdata <- paste0(name, ".Rdata")
                e <- new.env()
                e[[name]] <- value
                save(list = name, envir = e, file = paste(obj_dir, rdata, sep = "/"))
            } else {
                stop("Object must have an non NA value.")
            }
        },
        remove_object = function(name) {
            private$remove_file(paste0(name, ".RData"), "objects")
        },
        add_source = function(file) {
            private$add_file(file, "sources")
        },
        remove_source = function(basename) {
            private$remove_file(file, "sources")
        },
        add_data = function(file) {
            private$add_file(file, "data")
        },
        remove_data = function(basename) {
            private$remove_file(file, "data")
        }
    ),
    private = list(
        add_file = function(file, stain_sub_dir) {
            if (!file.exists(file)) { stop("File does not exist.") }
            dir <- paste(self$dir, ".stain", stain_sub_dir, sep = "/")
            file.copy(file, dir, recursive = TRUE)
        },
        remove_file = function(file, stain_sub_dir) {
            if (!file.exists(file)) { stop("File does not exist.") }
            file <- paste(self$dir, ".stain", stain_sub_dir, file, sep = "/")
            file.remove(file)
        },
        rand_alphanumeric = function(len = 3) {
            population <- c(rep(0:9, each = 5), LETTERS, letters)
            samp <- sample(population, len, replace = TRUE)
            return(paste(samp, collapse = ''))
        }
    )
)
