#!/usr/bin/env python
import os
import sys
import datetime
from shutil import copyfile
import run_experiments

# ------------------------------------------------------------------------------
def run_batches():

  # Base files
  params_dir = "/home/li9i/catkin_ws/src/relief_pipeline_localisation/configuration_files/"
  dft_params_file = params_dir + "pipeline_dft.yaml"
  general_params_file = params_dir + "pipeline_general.yaml"

  amcl_params_file = "/home/li9i/catkin_ws/src/relief_amcl_mod/configuration_files/amcl_params.yaml"

  # Switchable files
  conf_files_base = "/home/li9i/catkin_ws/src/pipeline_evaluator/scripts/"
  dft_params_0 = conf_files_base + "pipeline_dft_0.yaml"
  dft_params_1 = conf_files_base + "pipeline_dft_1.yaml"
  pipeline_general_params_0 = conf_files_base + "pipeline_general_0.yaml"
  pipeline_general_params_1 = conf_files_base + "pipeline_general_1.yaml"
  pipeline_general_params_2 = conf_files_base + "pipeline_general_2.yaml"
  amcl_params_0 = conf_files_base + "amcl_params_0.yaml"
  amcl_params_1 = conf_files_base + "amcl_params_1.yaml"
  amcl_params_2 = conf_files_base + "amcl_params_2.yaml"
  amcl_params_3 = conf_files_base + "amcl_params_3.yaml"
  amcl_params_4 = conf_files_base + "amcl_params_4.yaml"
  amcl_params_h_0 = conf_files_base + "amcl_params_h_0.yaml"
  amcl_params_h_1 = conf_files_base + "amcl_params_h_1.yaml"
  amcl_params_h_2 = conf_files_base + "amcl_params_h_2.yaml"
  amcl_params_h_3 = conf_files_base + "amcl_params_h_3.yaml"
  amcl_params_h_4 = conf_files_base + "amcl_params_h_4.yaml"
  amcl_params_h90_0 = conf_files_base + "amcl_params_h90_0.yaml"
  amcl_params_h90_1 = conf_files_base + "amcl_params_h90_1.yaml"
  amcl_params_h90_2 = conf_files_base + "amcl_params_h90_2.yaml"
  amcl_params_h90_3 = conf_files_base + "amcl_params_h90_3.yaml"
  amcl_params_h90_4 = conf_files_base + "amcl_params_h90_4.yaml"

  dft_params = []
  dft_params.append(dft_params_0)
  dft_params.append(dft_params_1)

  pipeline_general_params = []
  pipeline_general_params.append(pipeline_general_params_0)
  pipeline_general_params.append(pipeline_general_params_1)
  pipeline_general_params.append(pipeline_general_params_2)

  amcl_params = []
  amcl_params.append(amcl_params_0)
  amcl_params.append(amcl_params_1)
  amcl_params.append(amcl_params_2)
  amcl_params.append(amcl_params_3)
  amcl_params.append(amcl_params_4)

  amcl_params_h = []
  amcl_params_h.append(amcl_params_h_0)
  amcl_params_h.append(amcl_params_h_1)
  amcl_params_h.append(amcl_params_h_2)
  amcl_params_h.append(amcl_params_h_3)
  amcl_params_h.append(amcl_params_h_4)

  amcl_params_h90 = []
  amcl_params_h90.append(amcl_params_h90_0)
  amcl_params_h90.append(amcl_params_h90_1)
  amcl_params_h90.append(amcl_params_h90_2)
  amcl_params_h90.append(amcl_params_h90_3)
  amcl_params_h90.append(amcl_params_h90_4)


  non_dft = True
  dft = False

#### amcl-icp simulations ###

  if non_dft:
    # soft_50_closed_loop
    copyfile(pipeline_general_params[1], general_params_file)

    for j in range(0,5):
      copyfile(amcl_params_h[j], amcl_params_file)
      run_experiments.run_experiments()

    copyfile(dft_params[0], dft_params_file)

    # open_loop, soft_1_closed_loop, hard_closed_loop
    for i in range(0,3):
      copyfile(pipeline_general_params[i], general_params_file)

      for j in range(0,5):
        copyfile(amcl_params[j], amcl_params_file)
        run_experiments.run_experiments()




#### amcl-icp-dft simulations ###
  if dft:
    # soft_50_closed_loop
    copyfile(pipeline_general_params[1], general_params_file)

    for j in range(0,5):
      copyfile(amcl_params_h[j], amcl_params_file)
      run_experiments.run_experiments()

    copyfile(dft_params[1], dft_params_file)

    # open_loop, soft_1_closed_loop, hard_closed_loop
    for i in range(0,3):
      copyfile(pipeline_general_params[i], general_params_file)

      for j in range(0,5):
        copyfile(amcl_params[j], amcl_params_file)
        run_experiments.run_experiments()


# Soft-closed-loop but hybrid - 90%
#  copyfile(pipeline_general_params[1], general_params_file)
  #for k in range(0,2):
    #copyfile(dft_params[k], dft_params_file)

    #for j in range(0,5):
      #copyfile(amcl_params_h90[j], amcl_params_file)
      #run_experiments.run_experiments()


# ------------------------------------------------------------------------------
def main():

  run_batches()


# ------------------------------------------------------------------------------
if __name__== "__main__":
  main()
