## I. TASK
  » edit set_parameters;  % to set multiple options
  » main;                 % to run the task
  make sure there's enough maps in //data/maps

  different options can be set using the flags. these flags are specified in "set_mode.m". the different modes can be specified from "set_session.m". you can define new sessions and select it by changing the value of [parameters.session]

## II. FMRI ANALYSIS

the preprocessing is: spike correction, realignment, coregistration, normalisation, smoothing.
i haven't used the slice-time correction or the fieldmaps

