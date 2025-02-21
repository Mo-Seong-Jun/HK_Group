#!/bin/sh
#PBS -l nodes=1:ppn=4
#PBS -N QE_test_Graphene 
#PBS -q g1 // g2 : Gaussian, g1 : VASP


NPROCS=`wc -l < $PBS_NODEFILE`

hostname
date


cd $PBS_O_WORKDIR

cp $PBS_NODEFILE nodefile

echo $NPROCS

mpirun -genv I_MPI_DEBUG 5 -np $NPROCS /GRAPE/Apps/Espresso/qe-6.1/bin/pw.x < graphene.scf.in > graphene.scf.out
mpirun -genv I_MPI_DEBUG 5 -np $NPROCS /GRAPE/Apps/Espresso/qe-6.1/bin/pw.x < graphene.nscf.in> graphene.nscf.out

cp graphene.win_1 graphene.win 

mpirun -genv I_MPI_DEBUG 5 -np $NPROCS $PathTOWannier/wannier90.x -pp graphene

mpirun -genv I_MPI_DEBUG 5 -np $NPROCS /GRAPE/Apps/Espresso/qe-6.1/bin/pw2wannier90.x < graphene.pw2wan.in> graphene.pw2wan.out

mpirun -genv I_MPI_DEBUG 5 -np $NPROCS $PathTOWannier/wannier90.x graphene

cp graphene.win_2 graphene.win

mpirun -genv I_MPI_DEBUG 5 -np $NPROCS $PathTOWannier/wannier90.x graphene
