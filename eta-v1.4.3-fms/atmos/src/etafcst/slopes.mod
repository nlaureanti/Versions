V34 :0x24 slopes
17 MODULE_SLOPES.f90 S624 0
07/20/2023  16:19:29
use f77kinds public 0 direct
use parmeta private
enduse
D 58 23 6 2 60 59 0 0 0 0 0
 55 54 11 55 54 57
 55 56 57 55 56 58
D 61 23 6 3 63 62 0 0 0 0 0
 55 54 11 55 54 57
 55 56 57 55 56 58
 0 61 59 11 61 61
S 624 24 0 0 0 9 1 0 5013 5 0 A 0 0 0 0 B 0 1 0 0 0 0 0 0 0 0 0 0 28 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 slopes
S 627 23 0 0 0 6 670 624 5037 4 0 A 0 0 0 0 B 400000 16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 624 0 0 0 0 idim1
S 628 23 0 0 0 6 671 624 5043 4 0 A 0 0 0 0 B 400000 16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 624 0 0 0 0 idim2
S 629 23 0 0 0 6 672 624 5049 4 0 A 0 0 0 0 B 400000 16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 624 0 0 0 0 jdim1
S 630 23 0 0 0 6 673 624 5055 4 0 A 0 0 0 0 B 400000 16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 624 0 0 0 0 jdim2
S 631 23 0 0 0 6 660 624 5061 4 0 A 0 0 0 0 B 400000 16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 624 0 0 0 0 lm
R 660 16 3 parmeta lm
R 670 16 13 parmeta idim1
R 671 16 14 parmeta idim2
R 672 16 15 parmeta jdim1
R 673 16 16 parmeta jdim2
S 674 3 0 0 0 7 0 1 0 0 0 A 0 0 0 0 B 0 0 0 0 0 0 0 0 0 19 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7
S 675 3 0 0 0 7 0 1 0 0 0 A 0 0 0 0 B 0 0 0 0 0 0 0 0 -1 -5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7
S 676 3 0 0 0 7 0 1 0 0 0 A 0 0 0 0 B 0 0 0 0 0 0 0 0 0 23 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7
S 677 3 0 0 0 7 0 1 0 0 0 A 0 0 0 0 B 0 0 0 0 0 0 0 0 0 25 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7
S 678 3 0 0 0 7 0 1 0 0 0 A 0 0 0 0 B 0 0 0 0 0 0 0 0 0 29 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7
S 679 3 0 0 0 7 0 1 0 0 0 A 0 0 0 0 B 0 0 0 0 0 0 0 0 0 725 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7
S 680 3 0 0 0 7 0 1 0 0 0 A 0 0 0 0 B 0 0 0 0 0 0 0 0 -1 -130 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7
S 681 7 4 0 4 58 685 624 5202 800004 100 A 0 0 0 0 B 0 22 0 0 0 0 0 0 0 0 0 0 686 0 0 0 0 0 0 0 0 0 0 624 0 0 0 0 isld
S 682 3 0 0 0 7 0 1 0 0 0 A 0 0 0 0 B 0 0 0 0 0 0 0 0 0 38 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7
S 683 3 0 0 0 7 0 1 0 0 0 A 0 0 0 0 B 0 0 0 0 0 0 0 0 0 27550 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7
S 684 3 0 0 0 7 0 1 0 0 0 A 0 0 0 0 B 0 0 0 0 0 0 0 0 0 595 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7
S 685 7 4 0 4 61 1 624 5207 800004 100 A 0 0 0 0 B 0 25 0 0 0 2912 0 0 0 0 0 0 686 0 0 0 0 0 0 0 0 0 0 624 0 0 0 0 vtms
S 686 11 0 0 4 9 1 624 5212 40800000 805000 A 0 0 0 0 B 0 28 0 0 0 113112 0 0 681 685 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 _slopes$0
A 54 2 0 0 0 7 674 0 0 0 54 0 0 0 0 0 0 0 0 0 0 0
A 55 2 0 0 0 7 675 0 0 0 55 0 0 0 0 0 0 0 0 0 0 0
A 56 2 0 0 0 7 676 0 0 0 56 0 0 0 0 0 0 0 0 0 0 0
A 57 2 0 0 0 7 677 0 0 0 57 0 0 0 0 0 0 0 0 0 0 0
A 58 2 0 0 0 7 678 0 0 0 58 0 0 0 0 0 0 0 0 0 0 0
A 59 2 0 0 0 7 679 0 0 0 59 0 0 0 0 0 0 0 0 0 0 0
A 60 2 0 0 0 7 680 0 0 0 60 0 0 0 0 0 0 0 0 0 0 0
A 61 2 0 0 0 7 682 0 0 0 61 0 0 0 0 0 0 0 0 0 0 0
A 62 2 0 0 0 7 683 0 0 0 62 0 0 0 0 0 0 0 0 0 0 0
A 63 2 0 0 0 7 684 0 0 0 63 0 0 0 0 0 0 0 0 0 0 0
Z
Z