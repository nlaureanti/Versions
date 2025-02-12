    MODULE PARMETA
!>--------------------------------------------------------------------------------------------------
!> MODULE PARMETA
!>
!> USE MODULES: F77KINDS
!>
!> DRIVER     : BOCO
!>              BOCOHF
!>              BOCOV
!>              CHKOUT
!>              CLO89
!>              CLTEND
!>              COLLECT
!>              CONRAD
!>              CUCNVC
!>              DDAMP
!>              DIFCOF
!>              DIGFLT
!>              DIST
!>              DIVHOA
!>              DIVHOAST
!>              DSTRB
!>              E1E290
!>              E290
!>              E2SPEC
!>              E3V88
!>              EBU
!>              EPS
!>              FILT25
!>              FST88
!>              GFDLRD
!>              GOSSIP
!>              GRADFS
!>              GSCOND
!>              GSMCOLUMN
!>              GSMCONST
!>              GSMDRIVE
!>              HADZ
!>              HDIFF
!>              HDIFFS
!>              HZADV
!>              HZADVS
!>              HZADV2
!>              HZADV_LM1
!>              IDSTRB
!>              INIT
!>              INITS
!>              LOC2GLB
!>              LWR88
!>              MIXLEN
!>              MODULE_ACMCLD
!>              MODULE_ACMCLH
!>              MODULE_ACMPRE
!>              MODULE_ACMRDL
!>              MODULE_ACMRDS
!>              MODULE_ACMSFC
!>              MODULE_BOCO
!>              MODULE_C_FRACN
!>              MODULE_CLDWTR
!>              MODULE_CNVCLD
!>              MODULE_CONTIN
!>              MODULE_C_TADJ
!>              MODULE_CTLBLK
!>              MODULE_DYNAM0
!>              MODULE_EXCHM
!>              MODULE_GLB_TABLE
!>              MODULE_INDX
!>              MODULE_LOOPS
!>              MODULE_MAPOT2
!>              MODULE_MAPPINGS
!>              MODULE_MASKS
!>              MODULE_MPPCOM
!>              MODULE_NHYDRO
!>              MODULE_PHYS0
!>              MODULE_PHYS2
!>              MODULE_PPTASM
!>              MODULE_PRFHLD
!>              MODULE_PVRBLS
!>              MODULE_RD1TIM
!>              MODULE_RDPARM
!>              MODULE_SAVMEM
!>              MODULE_SLOPES
!>              MODULE_SOIL
!>              MODULE_TEMPCOM
!>              MODULE_TEMPV
!>              MODULE_TOPO
!>              MODULE_VRBLS
!>              MODULE_Z0EFFT
!>              MPI_FIRST
!>              MPPINIT
!>              NEWFLT
!>              O3INT
!>              OZON2D
!>              PDNEW
!>              PDTEDT
!>              PDTE
!>              PGCOR
!>              PRECPD
!>              PRODQ2
!>              QUILT
!>              RADFS
!>              RADTN
!>              RDTEMP
!>              READ_NHB
!>              READ_RESTRT
!>              READ_RESTRT2
!>              SFCDIF
!>              SFCDIF_BHS
!>              SLP
!>              SLPSIG
!>              SLPSIGSPLINE
!>              SPA88
!>              SURFCE
!>              SWR93
!>              TABLE
!>              TTBLEX
!>              TURBL
!>              TWR
!>              UPDATE
!>              VADZ
!>              VDIFH
!>              VDIFQ
!>              VDIFV
!>              VTADV
!>              VTADVF
!>              VWR
!>              ZENITH
!>              ZERO2
!>              ZERO3
!>              ZERO3_T
!>--------------------------------------------------------------------------------------------------
    USE F77KINDS
!------------------------------------------------------- 
! SET PRIMARY GRID DIMENSIONS AND PRESSURE OUTPUT LEVELS
!------------------------------------------------------- 
    INTEGER(KIND=I4KIND), PARAMETER :: IM    = 119
    INTEGER(KIND=I4KIND), PARAMETER :: JM    = 249
    INTEGER(KIND=I4KIND), PARAMETER :: LM    = 38
    INTEGER(KIND=I4KIND), PARAMETER :: LSM   = 22
!---------------------------------------------------------  
! SET THE NUMBER OF PEs IN THE I-DIRECTION AND J-DIRECTION
!--------------------------------------------------------- 
    INTEGER(KIND=I4KIND), PARAMETER :: INPES =   9
    INTEGER(KIND=I4KIND), PARAMETER :: JNPES =   14
!
    INTEGER(KIND=I4KIND), PARAMETER :: IGSTL =  -5
    INTEGER(KIND=I4KIND), PARAMETER :: IGSTR =   5
!
    INTEGER(KIND=I4KIND), PARAMETER :: JGSTL =  -5
    INTEGER(KIND=I4KIND), PARAMETER :: JGSTR =   5
!
    INTEGER(KIND=I4KIND), PARAMETER :: ITAIL = IM - (INPES * (IM / INPES))
    INTEGER(KIND=I4KIND), PARAMETER :: JTAIL = JM - (JNPES * (JM / JNPES))
!
    INTEGER(KIND=I4KIND), PARAMETER :: IDIM1 = IGSTL
    INTEGER(KIND=I4KIND), PARAMETER :: IDIM2 = IM / INPES + IGSTR + 1
!
    INTEGER(KIND=I4KIND), PARAMETER :: JDIM1 = JGSTL
    INTEGER(KIND=I4KIND), PARAMETER :: JDIM2 = JM / JNPES + JGSTR + 1
!
    END MODULE PARMETA


