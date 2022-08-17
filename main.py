# from dot import *
from Frac import *
from mathTech import *
from new import *
#example: 1.3, 2.1/ 2.1, 8.4/ 4.2, 6.3/ 7.1, 8.1 =>10.935
#dotList: [[1.1, 1.2], [2.1, 2.2], [3.1, 3.2], [4.1, 4.2]]
# ########DotList: [Dot(1.1, 1.2), Dot(2.1, 2.2), Dot(3.1, 3.2), Dot(4.1, 4.2)]
#FracList: [[Frac(11,10), Frac(6,5)], ...]
#multipledList:[]
#소수형태로 점 하나씩 입력
dotList=[[0,0] for _ in range(4)]
# DotList=[Dot(0,0) for _ in range(4)]
FracList=[[Frac(0,0), Frac(0,0)] for _ in range(4)]
xbunmolist=[0 for _ in range(4)]
ybunmolist=[0 for _ in range(4)]


for i in range(4):
    dotList[i][0], dotList[i][1]=map(float, input().split(', '))
print(dotList)


# for i in range(4):
#     DotList[i]=Dot(dotList[i][0], dotList[i][1])
for i in range(4):
    FracList[i][0]=toFrag(dotList[i][0])
    FracList[i][1]=toFrag(dotList[i][1])
    xbunmolist[i]=FracList[i][0].bunmo()
    ybunmolist[i]=FracList[i][1].bunmo()
xlcm=lcmarr(xbunmolist)
ylcm=lcmarr(ybunmolist)
xList=[int(dotList[i][0]*xlcm) for i in range(4)]
yList=[int(dotList[i][0]*ylcm) for i in range(4)]
poly=[(xList[i], yList[i]) for i in range(4)]
print(poly)
B_points = find_B_points(poly)
A_points = find_A_points(poly, B_points)
A = len(A_points)
B = len(B_points)
S = A + B / 2 - 1
print(f'A:{A}, B:{B}, S:{S}, realS:{S/(xlcm*ylcm)}')
