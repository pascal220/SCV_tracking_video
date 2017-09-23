-----------------------------------------------------------
Visual Tracking Using the Sum of Conditional Variance (SCV)
-----------------------------------------------------------

Version 1.02


-----------------------------------------------------------
Main files in folder :
-----------------------------------------------------------

'scv_trucking_from_video.m' -> Main file

To call the function the following needs to be used:
scv_trucking_from_video('vid_name',start_time,end_time,visualise)

where:
- 'vid_name' -> The path name where the vidoe file is located on the computer
- start_time -> Time in the vidoe at which to start in seconds
- end_time -> Time in the vidoe at which to end in seconds
- visualise -> either "true" or "false", depending if you want to see the algorithm preform in real time
