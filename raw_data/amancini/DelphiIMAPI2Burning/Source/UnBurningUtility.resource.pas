unit UnBurningUtility.resource;

interface

  resourcestring

  Burning_Aboring              = 'Abort in progress...' ;
  Disk_Erase                   = 'Disk wiping...'; 
  Disk_Erase_compleate         = 'Disk wipe completed.';

  Media_Eject_Not_Supported    = 'The burner does not support automatic closing of the disc tray. Please proceed manually and continue?';
  Media_eject_Not_Supported_2  = 'The burner does not support automatic ejection of the disc tray, please manually open the tray and continue.';
  Unknow_status_eject          = 'Unable to verify the status of the disc tray, proceed manually and continue?';

  Sync_Driver                  = 'Synchronization of driver...';
  Acq_driver                   = 'Acquiring exclusive control of the driver...';
  Verifying_disk               = 'Verifying disk...';
  Cancellation                 = 'Cancellation...';
  Burn_completed               = 'Burn completed.';
  Insert_disk                  = 'Please insert a disk into drive: %s';
  Disk_detected                = 'Disc detected...';

  Invalid_Disk                 = 'The disc type is valid..';
  Disk_not_empty               = 'The disk is not empty...';
  Insert_empty_disk            = 'Please insert a blank disc into drive : %s'; 
  Disk_is_empty                = 'Disk is empty...'; 
  Invalid_disk_for_driver      = 'The disc in the drive is not suitable for this type, Please insert another type of disc in the drive : %s';

  Time_progress                = 'Time spent: %S%S Estimated time: %s';
  Finalization_str             = 'Finalization...';
  Disk_request                 = 'Disk request...';

  Erase_request                = 'The disc in the unit: %S is not empty, do you want to proceed with the cancellation?';
  Burn_Not_possible_rw         = 'It is not possible to burn on rewritable discs insert a new disc in the unit: %s';

  Time_progress_Format         = 'Disk formatting%sPassed time: %s%sEstimated time: %s';

  Disk_validation              = 'Disk validation...';
  Disk_formatting              = 'Disk formatting...';
  init_hw                      = 'Initialization hardware';
  Laser_calibration            = 'Laser calibration...';
  Disk_writing                 = 'Disco writing in progress...';
  
implementation

end.
