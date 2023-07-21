#SBATCH -o ${Eta_run}/SST.o
#SBATCH -e ${Eta_run}/SST.e
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=12:00:00
#SBATCH -J EtaSST
#SBATCH -p triton16



