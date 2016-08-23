#' SlurmContainer R6 object.
#'
#' A slurm container is simply a directory with a specific
#' structure, particulary it has a submit.slurm script at the
#' top level.
SlurmContainer <- R6::R6Class("SlurmContainer",
    public = list(
        dir = NULL,
        initialize = function(dir = ".") {
            name <- paste0("job_", private$rand_alphanumeric())
            dir <- paste(dir, name, sep = "/")

            for (sub_dir in c("/input", "/ouput", "/sources", "/.objects")) {
                dir.create(paste0(dir, sub_dir), recursive = TRUE,
                           showWarnings = FALSE)
            }
        }
    ),
    private = list(
        rand_alphanumeric = function(len = 3) {
            population <- c(rep(0:9, each = 5), LETTERS, letters)
            samp <- sample(population, len, replace = TRUE)
            return(paste(samp, collapse = ''))
        }
    )
)