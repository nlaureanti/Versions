    module variables
!
! Dimension 1D variable
!
      integer, parameter         :: kmax=22
      real,dimension(kmax)       :: pr       !

      DATA pr/50., 100.,150.,200.,250.,300.,350.,   &
     &        400.,450.,500.,550.,600.,650.,   &
     &        700.,750.,800.,850.,900.,925.,      &
     &        950.,1000.,1020./
     

    end module variables
