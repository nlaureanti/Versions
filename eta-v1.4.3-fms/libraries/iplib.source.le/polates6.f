C-----------------------------------------------------------------------
      SUBROUTINE POLATES6(IPOPT,KGDSI,KGDSO,MI,MO,KM,IBI,LI,GI,
     &                    NO,RLAT,RLON,IBO,LO,GO,IRET)
C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM:  POLATES6   INTERPOLATE SCALAR FIELDS (BUDGET)
C   PRGMMR: IREDELL       ORG: W/NMC23       DATE: 96-04-10
C
C ABSTRACT: THIS SUBPROGRAM PERFORMS BUDGET INTERPOLATION
C           FROM ANY GRID TO ANY GRID FOR SCALAR FIELDS.
C           IT REQUIRES A GRID FOR THE OUTPUT FIELDS (KGDSO(1)>=0).
C           THE ALGORITHM SIMPLY COMPUTES (WEIGHTED) AVERAGES
C           OF NEIGHBOR POINTS ARRANGED IN A SQUARE BOX
C           CENTERED AROUND EACH OUTPUT GRID POINT AND STRETCHING
C           NEARLY HALFWAY TO EACH OF THE NEIGHBORING GRID POINTS.
C           OPTIONS ALLOW CHOICES OF NUMBER OF POINTS IN EACH RADIUS
C           FROM THE CENTER POINT (IPOPT(1)) WHICH DEFAULTS TO 2
C           (IF IPOPT(1)=-1) MEANING THAT 25 POINTS WILL BE AVERAGED;
C           FURTHER OPTIONS ARE THE RESPECTIVE WEIGHTS FOR THE RADIUS
C           POINTS STARTING AT THE CENTER POINT (IPOPT(2:2+IPOPT(1))
C           WHICH DEFAULTS TO ALL 1 (IF IPOPT(2)=-1.).
C           ONLY HORIZONTAL INTERPOLATION IS PERFORMED.
C           THE GRIDS ARE DEFINED BY THEIR GRID DESCRIPTION SECTIONS
C           (PASSED IN INTEGER FORM AS DECODED BY SUBPROGRAM W3FI63).
C           THE CURRENT CODE RECOGNIZES THE FOLLOWING PROJECTIONS:
C             (KGDS(1)=000) EQUIDISTANT CYLINDRICAL
C             (KGDS(1)=001) MERCATOR CYLINDRICAL
C             (KGDS(1)=003) LAMBERT CONFORMAL CONICAL
C             (KGDS(1)=004) GAUSSIAN CYLINDRICAL (SPECTRAL NATIVE)
C             (KGDS(1)=005) POLAR STEREOGRAPHIC AZIMUTHAL
C             (KGDS(1)=202) ROTATED EQUIDISTANT CYLINDRICAL (ETA NATIVE)
C           WHERE KGDS COULD BE EITHER INPUT KGDSI OR OUTPUT KGDSO.
C           AS AN ADDED BONUS THE NUMBER OF OUTPUT GRID POINTS
C           AND THEIR LATITUDES AND LONGITUDES ARE ALSO RETURNED.
C           INPUT BITMAPS WILL BE INTERPOLATED TO OUTPUT BITMAPS.
C           OUTPUT BITMAPS WILL ALSO BE CREATED WHEN THE OUTPUT GRID
C           EXTENDS OUTSIDE OF THE DOMAIN OF THE INPUT GRID.
C           THE OUTPUT FIELD IS SET TO 0 WHERE THE OUTPUT BITMAP IS OFF.
C        
C PROGRAM HISTORY LOG:
C   96-04-10  IREDELL
C   96-10-04  IREDELL   NEIGHBOR POINTS NOT BILINEAR INTERPOLATION
C
C USAGE:    CALL POLATES6(IPOPT,KGDSI,KGDSO,MI,MO,KM,IBI,LI,GI,
C    &                    NO,RLAT,RLON,IBO,LO,GO,IRET)
C
C   INPUT ARGUMENT LIST:
C     IPOPT    - INTEGER (20) INTERPOLATION OPTIONS
C                IPOPT(1) IS NUMBER OF RADIUS POINTS
C                (DEFAULTS TO 2 IF IPOPT(1)=-1);
C                IPOPT(2:2+IPOPT(1)) ARE RESPECTIVE WEIGHTS
C                (DEFAULTS TO ALL 1 IF IPOPT(2)=-1).
C     KGDSI    - INTEGER (200) INPUT GDS PARAMETERS AS DECODED BY W3FI63
C     KGDSO    - INTEGER (200) OUTPUT GDS PARAMETERS
C     MI       - INTEGER SKIP NUMBER BETWEEN INPUT GRID FIELDS IF KM>1
C                OR DIMENSION OF INPUT GRID FIELDS IF KM=1
C     MO       - INTEGER SKIP NUMBER BETWEEN OUTPUT GRID FIELDS IF KM>1
C                OR DIMENSION OF OUTPUT GRID FIELDS IF KM=1
C     KM       - INTEGER NUMBER OF FIELDS TO INTERPOLATE
C     IBI      - INTEGER (KM) INPUT BITMAP FLAGS
C     LI       - LOGICAL*1 (MI,KM) INPUT BITMAPS (IF SOME IBI(K)=1)
C     GI       - REAL (MI,KM) INPUT FIELDS TO INTERPOLATE
C
C   OUTPUT ARGUMENT LIST:
C     NO       - INTEGER NUMBER OF OUTPUT POINTS
C     RLAT     - REAL (MO) OUTPUT LATITUDES IN DEGREES
C     RLON     - REAL (MO) OUTPUT LONGITUDES IN DEGREES
C     IBO      - INTEGER (KM) OUTPUT BITMAP FLAGS
C     LO       - LOGICAL*1 (MO,KM) OUTPUT BITMAPS (ALWAYS OUTPUT)
C     GO       - REAL (MO,KM) OUTPUT FIELDS INTERPOLATED
C     IRET     - INTEGER RETURN CODE
C                0    SUCCESSFUL INTERPOLATION
C                2    UNRECOGNIZED INPUT GRID OR NO GRID OVERLAP
C                3    UNRECOGNIZED OUTPUT GRID
C                31   INVALID UNDEFINED OUTPUT GRID
C                32   INVALID BUDGET METHOD PARAMETERS
C
C SUBPROGRAMS CALLED:
C   GDSWIZ       GRID DESCRIPTION SECTION WIZARD
C   (IJKGDS)     RETURN FIELD POSITION FOR A GIVEN GRID POINT
C   POLFIXS      MAKE MULTIPLE POLE SCALAR VALUES CONSISTENT
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN 77
C
C$$$
CFPP$ EXPAND(IJKGDS)
      INTEGER IPOPT(20)
      INTEGER KGDSI(200),KGDSO(200)
      INTEGER IBI(KM),IBO(KM)
      LOGICAL LI(MI,KM),LO(MO,KM)
      REAL GI(MI,KM),GO(MO,KM)
      REAL RLAT(MO),RLON(MO)
      REAL XPTS(MO),YPTS(MO)
      REAL XPTB(MO),YPTB(MO),RLOB(MO),RLAB(MO)
      INTEGER N11(MO)
      REAL WO(MO,KM)
      PARAMETER(FILL=-9999.)
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  COMPUTE NUMBER OF OUTPUT POINTS AND THEIR LATITUDES AND LONGITUDES.
      IRET=0
      IF(KGDSO(1).GE.0) THEN
        CALL GDSWIZ(KGDSO, 0,MO,FILL,XPTS,YPTS,RLON,RLAT,NO,0,DUM,DUM)
        IF(NO.EQ.0) IRET=3
      ELSE
        IRET=31
      ENDIF
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  SET PARAMETERS
      NB1=IPOPT(1)
      IF(NB1.EQ.-1) NB1=2
      IF(IRET.EQ.0.AND.NB1.LT.0.) IRET=32
      IF(IRET.EQ.0.AND.NB1.GE.20.AND.IPOPT(2).NE.-1) IRET=32
      IF(IRET.EQ.0) THEN
        NB2=2*NB1+1
        NB3=NB2*NB2
        NB4=NB3
        IF(IPOPT(2).NE.-1) THEN
          NB4=IPOPT(2)
          DO IB=1,NB1
            NB4=NB4+8*IB*IPOPT(2+IB)
          ENDDO
        ENDIF
      ELSE
        NB2=0
        NB3=0
        NB4=0
      ENDIF
CnotCMIC$ DO ALL AUTOSCOPE
      DO K=1,KM
        DO N=1,NO
          GO(N,K)=0.
          WO(N,K)=0.
        ENDDO
      ENDDO
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  LOOP OVER SAMPLE POINTS IN OUTPUT GRID BOX
      DO NB=1,NB3
C  LOCATE INPUT POINTS AND COMPUTE THEIR WEIGHTS
        JB=(NB-1)/NB2-NB1
        IB=NB-(JB+NB1)*NB2-NB1-1
        LB=MAX(ABS(IB),ABS(JB))
        WB=1
        IF(IPOPT(2).NE.-1) WB=IPOPT(2+LB)
        IF(WB.NE.0) THEN
          DO N=1,NO
            XPTB(N)=XPTS(N)+IB/REAL(NB2)
            YPTB(N)=YPTS(N)+JB/REAL(NB2)
          ENDDO
          CALL GDSWIZ(KGDSO, 1,NO,FILL,XPTB,YPTB,RLOB,RLAB,NV,0,DUM,DUM)
          CALL GDSWIZ(KGDSI,-1,NO,FILL,XPTB,YPTB,RLOB,RLAB,NV,0,DUM,DUM)
          IF(IRET.EQ.0.AND.NV.EQ.0.AND.LB.EQ.0) IRET=2
          DO N=1,NO
            XI=XPTB(N)
            YI=YPTB(N)
            IF(XI.NE.FILL.AND.YI.NE.FILL) THEN
              I1=NINT(XI)
              J1=NINT(YI)
              N11(N)=IJKGDS(I1,J1,KGDSI)
              ELSE
                N11(N)=0
              ENDIF
          ENDDO
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  INTERPOLATE WITH OR WITHOUT BITMAPS
CnotCMIC$ DO ALL AUTOSCOPE
          DO K=1,KM
            DO N=1,NO
              IF(N11(N).GT.0) THEN
                IF(IBI(K).EQ.0.OR.LI(N11(N),K)) THEN
                  GO(N,K)=GO(N,K)+WB*GI(N11(N),K)
                  WO(N,K)=WO(N,K)+WB
                ENDIF
              ENDIF
            ENDDO
          ENDDO
        ENDIF
      ENDDO
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  COMPUTE OUTPUT BITMAPS AND FIELDS
CnotCMIC$ DO ALL AUTOSCOPE
      DO K=1,KM
        IBO(K)=IBI(K)
        DO N=1,NO
          LO(N,K)=WO(N,K).GE.0.5*NB4
          IF(LO(N,K)) THEN
            GO(N,K)=GO(N,K)/WO(N,K)
          ELSE
            IBO(K)=1
            GO(N,K)=0.
          ENDIF
        ENDDO
      ENDDO
      IF(KGDSO(1).EQ.0) CALL POLFIXS(NO,MO,KM,RLAT,RLON,IBO,LO,GO)
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      END