#' SlurmBashScript R6 object.
#'
#' Generates the necessary bash script to submit through
#' the `sbatch` command.
SlurmBashScript <- R6::R6Class("SlurmBashScript",
    public = list(
        initialize = function(container, main_file, copy_back = "*") {
            private$write_slurm_script(container$dir)
        }
    ),
    private = list(
        write_slurm_script = function(dir) {
            contents <- "
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=12
#SBATCH --time=0:10:00
#SBATCH --mem=16g
#SBATCH -o R_job.o%j


# copy necessary files over
cp -r ./source ./input ./.objects $PFSDIR
cd $PFSDIR

module load hpc-ods
module load pandoc

R CMD BATCH $1

for i in ${@:2}
do
cp -r $i $SLURM_SUBMIT_DIR/output
done

cp -r './$1out' $SLURM_SUBMIT_DIR/output"

            write(contents, file = paste(dir, ".static.slurm", sep = "/"))
        }
    )
)
