      SUBROUTINE CETLIH4(HE,HX,IMOT,JMOT,KSB,IOFFS)
C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C                .      .    .     
C SUBPROGRAM:    CETLIH4     INTERPOLATES
C   PRGRMMR: TREADON         ORG: W/NP2      DATE: 92-12-23
C     
C ABSTRACT:
C     THIS ROUTINE INTERPOLATES DATA IN ARRAY HE FROM HEIGHT
C     POINTS ON AN ETA GRID TO HEIGHT POINTS ON ANOTHER GRID
C     IN ARRAY HX.  THE INTERPOLATION CONSERVES THE AREA 
C     INTEGRAL OF HE.
C     
C     ***WARNING*** 
C     COMPUTATION OF THE INTERPOLATION 'WEIGHTS' CONSUMES 
C     AN ENORMOUS AMOUNT OF CPU TIME, MUCH MORE THAN 
C     THE ACTUAL TIME IT TAKES TO DO THE INTERPOLATION.
C     IT IS MUCH BETTER TO PRECOMPUTE THE REQUIRED
C     WEIGHTS.  SUBROUINE GD2EGK COMPUTES THESE 'WEIGHTS'.
C   .     
C     
C PROGRAM HISTORY LOG:
C   ??-??-??  ???
C   92-12-23  RUSS TREADON - GENERALIZED CODE BY REMOVING 
C                            HARDCODED (IM,JM).
C   93-06-09  RUSS TREADON - EXPANDED COMMENTS.
C   98-06-17  T BLACK      - CONVERSION FROM 1-D TO 2-D
C     
C USAGE:    CETLIH4(HE,HX,IMOT,JMOT,KSB)
C   INPUT ARGUMENT LIST:
C     HE       - DATA ON E-GRID.
C     IMOT     - FIRST DIMENSION OF OUTPUT GRID.
C     JMOT     - SECOND DIMENSION OF OUTPUT GRID.
C     KSB      - NUMBER OF SUB BOXES
C     IOFFS    - WIDTH (IN GRID POINTS) OF SEARCH WINDOW
C                AROUND E-GRID POINT FROM WHICH INTERPOLATING.
C
C   OUTPUT ARGUMENT LIST: 
C     HX       - DATA INTERPOLATED TO THE OUTPUT GRID
C     
C   OUTPUT FILES:
C     NONE
C     
C   SUBPROGRAMS CALLED:
C     UTILITIES:
C       NONE
C     LIBRARY:
C       COMMON   - LLGRDS
C       COMMON   - INDX
C     
C   ATTRIBUTES:
C     LANGUAGE: FORTRAN
C     MACHINE : CRAY C-90
C$$$  
C     
C     
C     INCLUDE ETA GRID DIMENSIONS.  COMPUTE DEPENDENT PARAMETERS.
C     
      INCLUDE "parmeta"
      INCLUDE "parmout"
C
      PARAMETER (IMT=2*IM-1,JMT=JM)
C
C     DECLARE VARIABLES.
      INTEGER NZ(IMX,JMX)
      REAL HE(IM,JM),HX(IMOT,JMOT)
C     
C     INCLUDE COMMON BLOCK.
      INCLUDE "LLGRDS.comm"
      INCLUDE "INDX.comm"
C
      REAL SBLAT(IM,JM),SBLON(IM,JM),DSQMN(IM,JM)
      INTEGER IISB(IM,JM),JJSB(IM,JM)
C     
C     
C**********************************************************************
C     START CETLIH4.
C     
C     ZERO OUTPUT ARRAY AND NORMALIZATION ARRAY.
         HX(1:IMOT,1:JMOT)=0.
         NZ(1:IMOT,1:JMOT)=0
C     
C     SET CONSTANTS.
      JMOT2 = JMOT-2
      IMOT2 = IMOT-2
      SBS=1./KSB
C     
C     LOOP OVER E-GRID.  MOVE SOUTH TO NORTH THROUGH JM2 ROWS. 
C     ON EACH ROW MOVE WEST TO EAST THROUGH THE E-GRID K INDEX.
C     AT EACH K INTERPOLATE DATA IN E-GRID ARRAY HE TO OUTPUT
C     GRID ARRAY HX.
C
!$omp  parallel do
!$omp& private(clat,clon,dsq,ie,iend,ip,is,iw,jp,js,p,pq,q)
      do185: DO J=3,JM-2
C     
      IEND=IM-1-MOD(J+1,2)
C
C        DISTRIBUTE THE E-GRID VALUES (IN ARRAY HE) TO THE SURROUNDING
C        KSB*KSB OUTPUT GRID POINTS.
C     
         doout160: DO JB=1,KSB
         doin160: DO IB=1,KSB
           do175: DO I=2,IEND
C     
C        SET TRANSFORMED (LAT,LON) OF THE K-TH E-GRID MASS POINT.
C        THIS BECOMES THE CENTER OF THE BOX OVER WHICH THE AREA
C        CONSERVING INTERPOLATION IS DONE.
C
         DSQMN(I,J)=  1.
         IISB(I,J) = -1 
         JJSB(I,J) = -1
         JP  = JEGRDK(I,J)
         IF (JP.LT.1) CYCLE  do175
         CLON=HTLON(I,J)
         CLAT=HTLAT(I,j)
C     
C        LOAD THE OUTPUT GRID (I,J) NEAREST TO K-TH E-GRID MASS POINT.
C        IF INTERPOLATION FROM THE K-TH E-GRID MASS POINT TO THE 
C        OUTPUT GRID IS NOT POSSIBLE (AT INDICATED BY ZERO OR NEGATIVE
C        OUTPUT GRID (I,J), DO NOT ATTEMPT INTERPOLATION CENTERED ON 
C        THIS E-GRID MASS POINT.
C
C     
C           FOR THE (IB,JB)-TH SUB-BOX COMPUTE THE TRANSFORMED E-GRID
C           LATITUDE AND LONGITUDE AT THE CENTER OF THIS SUB-BOX.
C
            P=(IB-(KSB+1.)/2.)*SBS
            Q=(JB-(KSB+1.)/2.)*SBS
            PQ=P*Q
            IE=I+IHE(J)
            IW=I+IHW(J)
            SBLON(I,J)=CLON+P*(HTLON(IE,J+1)-CLON)
     1                     +Q*(HTLON(IW,J+1)-CLON)
     2           +PQ*(CLON-HTLON(IE,J+1)-HTLON(IW,J+1)+HTLON(I,J+2))
            SBLAT(I,J)=CLAT+P*(HTLAT(IE,J+1)-CLAT)
     1                     +Q*(HTLAT(IW,J+1)-CLAT)
     2           +PQ*(CLAT-HTLAT(IE,J+1)-HTLAT(IW,J+1)+HTLAT(I,J+2))
           END DO do175
C
         doout150: DO JJ=0,IOFFS
         doin150: DO II=0,IOFFS
C
            do180: DO I=2,IEND
         JP  = JEGRDK(I,J)
         IF (JP.LT.1) CYCLE do180
         IP  = IEGRDK(I,J)

C        SET OUTPUT GRID (I,J) SURROUNDING THE E-GRID MASS POINT.
C 
         IS=IP-(IOFFS-1)
         JS=JP-(IOFFS-1)
C           SEARCH FOR THE OUTPUT GRID POINT NEAREST TO THE CENTER 
C           OF THE (IB,JB)-TH SUB-BOX.  ASSIGN THE (I,J) INDEX OF 
C           THIS POINT TO (IISB,JJSB)
C
             DSQ=(GDTLON((IS+II),(JS+JJ))-SBLON(I,J))**2
     *          +(GDTLAT((IS+II),(JS+JJ))-SBLAT(I,J))**2
               IF(DSQ.LT.DSQMN(I,J)) THEN
                  DSQMN(I,J)=DSQ
                  IISB(I,J)=IS+II
                  JJSB(I,J)=JS+JJ
               ENDIF
            END DO do180
            END DO doin150
            END DO doout150
C     
C           IF INTERPOLATION WAS NOT POSSIBLE TO THE CURRENT
C           OUTPUT GRID SUB-BOX, THEN SKIP THIS SUB-BOX AND 
C           TRY THE NEXT ONE.
C
            do155: DO I=2,IEND
              IF(IISB(I,J).GT.0)THEN
C     
C            ADD E-GRID AMOUNT IN ARRAY HE ON INPUT E-GRID TO THE 
C            NEAREST NEIGHBOR OUTPUT GRID SUB-BOX IDENTIFIED ABOVE.
C
             HX(IISB(I,J),JJSB(I,J))=HX(IISB(I,J),JJSB(I,J))+HE(I,J)
             NZ(IISB(I,J),JJSB(I,J))=NZ(IISB(I,J),JJSB(I,J))+1
            ENDIF
            END DO do155
C     
C        REPEAT FOR NEXT SUB-BOX.
C
         END DO doin160
         END DO doout160
C     
C     REPEAT INTERPOLATION FOR NEXT E-GRID MASS POINT.
C
      END DO do185
C     
C     NORMALIZE OUTPUT GRID AMOUNT IN ARRAY HX BY THE NUMBER OF
C     E-GRID AMOUNTS SUMMED TO OBTAIN THE OUTPUT GRID AMOUNT.
C
!$omp  parallel do
      doout200: DO JJ=1,JMOT
         doin200: DO II=1,IMOT
C     
C           AVOID DIVISION BY ZERO.  NZ=0 INDICATES NO
C           INTERPOLATION WAS POSSIBLE AND SO THE OUTPUT
C           GRID VALUE IN ARRAY HX SHOULD REMAIN THE ZERO
C           IT WAS INITIALIZED TO.
c            IF (NZ(II,JJ).EQ.0) NZ(II,JJ) = 1
C
            IF (NZ(II,JJ).NE.0) THEN
             HX (II,JJ)=HX(II,JJ) / NZ(II,JJ)
            ENDIF
         END DO doin200
      END DO doout200
C     
C     END OF ROUTINE.
C
      RETURN
      END