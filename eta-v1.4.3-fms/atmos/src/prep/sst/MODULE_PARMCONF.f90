    MODULE PARMCONF
!>--------------------------------------------------------------------------------------------------
!> MODULE PARMCONF
!>
!> USE MODULES: F77KINDS
!>--------------------------------------------------------------------------------------------------
    USE F77KINDS
!------------------------------------------------------- 
! SET PRIMARY GRID DIMENSIONS AND PRESSURE OUTPUT LEVELS
!------------------------------------------------------- 
    INTEGER(KIND=I4KIND), PARAMETER :: IM    = 119
    INTEGER(KIND=I4KIND), PARAMETER :: JM    = 249
    REAL   (KIND=R4KIND), PARAMETER :: DLMD  = .28846153850000000000
    REAL   (KIND=R4KIND), PARAMETER :: DPHD  = .26923076950000000000
    REAL   (KIND=R4KIND), PARAMETER :: TLM0D = -50.0
    REAL   (KIND=R4KIND), PARAMETER :: TPH0D = -19
!
    END MODULE PARMCONF


